/*
 * LLLogicVote.cpp
 *
 *  Created on: Nov 3, 2013
 *      Author: kuaijianghua
 */

#include "LLLogicVote.h"

string LLLogicVote::excuteRequest(string requestString, short version,
		unsigned int sessionID) {
	//获得请求类型
	Json::Reader reader;
	Json::Value receivedValue;
	Json::Value sendValue;
	Json::FastWriter writer;

	if (reader.parse(requestString, receivedValue)) {
		//根据请求版本进行执行

		//根据请求类型进行执行
		int requestType = receivedValue["requestType"].asInt();

		switch (requestType) {
		case SignUp: {
			string firstName = receivedValue["firstName"].asString();
			string lastName = receivedValue["lastName"].asString();
			string email = receivedValue["email"].asString();

			sendValue["success"] = this->signUp(firstName, lastName, email);
			sendValue["msg"] = this->errorString;
			return writer.write(sendValue);
		}
		case CheckCode: {
			string email = receivedValue["email"].asString();
			string code = receivedValue["code"].asString();
			int checkType = receivedValue["checkType"].asInt();

			int userID;
			bool hasPassword;
			sendValue["success"] = this->checkCode(email, code, checkType,userID,hasPassword);
			if(sendValue["success"].asBool()){
				sendValue["userid"] = userID;
				sendValue["hasPassword"] = hasPassword;
			}else{
				sendValue["msg"] = this->errorString;
			}

			return writer.write(sendValue);
		}
		case SignInWithPassword: {
			string email = receivedValue["email"].asString();
			string password = receivedValue["password"].asString();

			int userID;
			sendValue["success"] = this->signInWithPassword(email, password,userID);
			if(sendValue["success"].asBool()){
				sendValue["userid"] = userID;
			}
			sendValue["msg"] = this->errorString;
			return writer.write(sendValue);
		}
		case SignInWithEmail: {
			string email = receivedValue["email"].asString();

			sendValue["msg"] = this->signInWithEmail(email);
			sendValue["msg"] = this->errorString;
			return writer.write(sendValue);
		}
		case ResendCode: {
			string email = receivedValue["email"].asString();
			string firstName = receivedValue["firstName"].asString();
			string lastName = receivedValue["lastName"].asString();
			int resendType = receivedValue["resendType"].asInt();

			sendValue["success"] = this->resendCode(email, firstName, lastName,
					resendType);
			sendValue["msg"] = this->errorString;
			return writer.write(sendValue);
		}

		default: {
			return "{\"msg\":\"Invalid request type\",\"success\":false}";
			break;
		}
		}
	}

	return "{\"msg\":\"Invalid jsonString\",\"success\":false}";
}

//注册
bool LLLogicVote::signUp(string firstName, string lastName, string email) {
	if (firstName.empty() || lastName.empty() || email.empty()) {
		this->errorString = "Content can't be null";
		return false;
	}

	//check if this email has been registered
	User *userObject = new User(this->database);

	//set up the data
	userObject->firstName = firstName;
	userObject->lastName = lastName;
	userObject->email = email;

	if (userObject->checkIfEmailExist()) {
		this->errorString = "Email has been registered.";
		return false;
	}

	//put this user into the sign up holding list, wait until the code confirm success
	string code = this->codeManager->getCode(userObject);

	//send the code to the email
	string mailContent =
			"Dear customer,\n\nYour dynamic Code is " + code
					+ ".\nPlease confirm your code as soon as possible.\n\nThank you.\nRampageworks";
	mailManager->sendMail(mailContent, email, "[Vote]Confrim Vote");
	return true;
}

bool LLLogicVote::checkCode(string email, string code, int checkType,int &userID,bool &hasPassword) {
	if (email.empty() || code.empty()) {
		this->errorString = "Content can't be null";
		return false;
	}

	//set return
	User *userObject = new User(this->database);

	if(checkType == 1){
		//check if the email is exsit if use wanna use email to login
		if (!userObject->checkIfEmailExist()) {
			this->errorString = "This user does not exist.";
			return false;
		}
	}

	//check the code is exist
	int result = this->codeManager->codeConfirm(email, code, *userObject);

	if (result == 1) {
		//check success
		//clean that record in code manager
		this->codeManager->earseUser(email);
		if (checkType == 0) {
			//this checking code is for signUp
			//signUp to database now
			bool result = userObject->signUp();
			hasPassword = false;

			//get user id
			userObject->getUserByEmail(email);
			userID = userObject->userid;

			delete userObject;
			return result;
		}else{
			userObject->getUserByEmail(email);
			hasPassword = userObject->password.empty() ? false:true;
			userID = userObject->userid;
		}
		return true;
	} else if (result == 0) {
		this->errorString = "Wrong code";
		return false;
	} else {
		this->errorString = "No record or expired.";
		return false;
	}
}

bool LLLogicVote::signInWithPassword(string email, string password,int &userID) {
	if (email.empty() || password.empty()) {
		this->errorString = "Content can't be null";
		return false;
	}

	User userObject(this->database);
	userObject.email = email;
	userObject.password = password;

	bool result = userObject.signInWithPassword();
	if(result){
		userID = userObject.userid;
	}else{
		this->errorString = userObject.errorMessage;
	}

	return result;
}

bool LLLogicVote::signInWithEmail(string email) {
	if (email.empty()) {
		this->errorString = "Content can't be null";
		return false;
	}

	//check if this email has been registered
	User *userObject = new User(this->database);

	//set up the data
	userObject->email = email;

	//put this user into the sign in holding list, wait until the code confirm success
	string code = this->codeManager->getCode(userObject);

	//send the code to the email
	string mailContent =
			"Dear voter,\n\nYour dynamic Code is " + code
					+ ".\nPlease confirm your code as soon as possible.\n\nThank you.\nRampageworks";
	mailManager->sendMail(mailContent, email, "[Vote]Confrim Vote");

	return true;
}

bool LLLogicVote::uploadToken(int userID,string token)
{
	User userObject(this->database);
	if(userObject.getUserByID(userID)){
		userObject.token = token;
		if(userObject.updateUser()){
			return true;
		}else{
			this->errorString = userObject.errorMessage;
			return false;
		}
	}else{
		this->errorString = "Can't find user.";
		return false;
	}
}

bool LLLogicVote::resendCode(string email, string firstName, string lastName,int resendType)
{
	if(resendType == 0){
		//sign up resend
		return this->signUp(firstName,lastName,email);
	}else if(resendType == 1){
		//sign in resend
		return this->signInWithEmail(email);
	}else{
		this->errorString = "Invalid resendType";
		return false;
	}
}
