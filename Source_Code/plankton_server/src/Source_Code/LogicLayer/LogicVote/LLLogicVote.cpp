/*
 * LLLogicVote.cpp
 *
 *  Created on: Nov 3, 2013
 *      Author: kuaijianghua
 */

#include "LLLogicVote.h"

bool LLLogicVote::doesAutoScanOpened = false;

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

		//set request type
		sendValue["requestType"] = requestType;

		switch (requestType) {
		case SignUp: {
			string firstName = receivedValue["firstName"].asString();
			string lastName = receivedValue["lastName"].asString();
			string email = receivedValue["email"].asString();

			sendValue["success"] = this->signUp(firstName, lastName, email);

			break;
		}
		case CheckCode: {
			string email = receivedValue["email"].asString();
			string code = receivedValue["code"].asString();
			int checkType = receivedValue["checkType"].asInt();

			int userID;
			bool hasPassword;
			sendValue["success"] = this->checkCode(email, code, checkType,
					userID, hasPassword);
			if (sendValue["success"].asBool()) {
				sendValue["userid"] = userID;
				sendValue["hasPassword"] = hasPassword;
			}

			break;
		}
		case SignInWithPassword: {
			string email = receivedValue["email"].asString();
			string password = receivedValue["password"].asString();

			int userID;
			sendValue["success"] = this->signInWithPassword(email, password,
					userID);
			if (sendValue["success"].asBool()) {
				sendValue["userid"] = userID;
			}

			break;
		}
		case SignInWithEmail: {
			string email = receivedValue["email"].asString();

			sendValue["success"] = this->signInWithEmail(email);
			break;
		}
		case ResendCode: {
			string email = receivedValue["email"].asString();
			string firstName = receivedValue["firstName"].asString();
			string lastName = receivedValue["lastName"].asString();
			int resendType = receivedValue["resendType"].asInt();

			sendValue["success"] = this->resendCode(email, firstName, lastName,
					resendType);
			break;
		}
		case SearchVote: {
			int searchType = receivedValue["searchtype"].asInt();
			sendValue["searchtype"] = searchType;

			if (searchType == 0) {
				//get the longitude and latitude
				double longitude = receivedValue["longitude"].asDouble();
				double latitude = receivedValue["latitude"].asDouble();

				sendValue["success"] = this->searchVoteByLocation(longitude,
						latitude, sendValue);
			} else {
				int voteid = receivedValue["voteid"].asInt();
				sendValue["success"] = this->searchVoteByID(voteid, sendValue);
			}

			break;
		}
		case GetDuplicateSelection: {
			int voteid = receivedValue["voteid"].asInt();
			sendValue["success"] = this->getDuplicateNameList(voteid,
					sendValue);
			break;
		}
		case CancelSelection: {
			int voteid = receivedValue["voteid"].asInt();
			string email = receivedValue["email"].asString();
			sendValue["success"] = this->cancelUserSelection(voteid, email);
			break;
		}
		case AdminResolveVote: {
			int voteid = receivedValue["voteid"].asInt();
			sendValue["success"] = this->adminResolveVote(voteid);
			break;
		}
		default: {
			return "{\"msg\":\"Invalid request type\",\"success\":false}";
			break;
		}
		}
	} else {
		return "{\"msg\":\"Invalid jsonString\",\"success\":false}";
	}

	if (!sendValue["msg"].asBool()) {
		sendValue["msg"] = this->errorString;
	}

	return writer.write(sendValue);
}

//auto scan finished vote
//static method, can't control
void *LLLogicVote::autoScanFinishedVote(void *msg) {
	//分离此线程，保证线程结束后系统能回收线程资源
	pthread_detach(pthread_self());

	DLDatabase *database = PLDataLayer::Instance()->getDatabaseByName("Vote");

	//Execute this every 600 seconds
	while (1) {
		Vote tmpVote(database);
		vector<Vote*> unfinishedVoteList = tmpVote.getAllUnfinishedVote();

		for (unsigned int i = 0; i < unfinishedVoteList.size(); i++) {
			Vote* vote = unfinishedVoteList[i];

			//check if the vote has pass the end time
			time_t timeTmp = time(NULL);
			double timeSpan = difftime(timeTmp, tmpVote.endTime);
			if (timeSpan > 0){
				//check there if there is no pending selection
				if(vote->getPendingSelectionNumber() == 0){
					vote->setVoteFinish();
				}
			}

			delete vote;
		}

		sleep(600);
	}

	return NULL;
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

bool LLLogicVote::checkCode(string email, string code, int checkType,
		int &userID, bool &hasPassword) {
	if (email.empty() || code.empty()) {
		this->errorString = "Content can't be null";
		return false;
	}

	//set return
	User userObject(this->database);

	userObject.email = email;

	if (checkType == 1) {
		//check if the email is exsit if use wanna use email to login
		if (!userObject.checkIfEmailExist()) {
			this->errorString = "This user does not exist.";
			return false;
		}
	}

	//check the code is exist
	int result = this->codeManager->codeConfirm(email, code, userObject);

	if (result == 1) {
		//check success
		//clean that record in code manager
		this->codeManager->earseUser(email);
		if (checkType == 0) {
			//this checking code is for signUp
			//signUp to database now
			bool result = userObject.signUp();
			hasPassword = false;

			//get user id
			userObject.getUserByEmail(email);
			userID = userObject.userid;

			return result;
		} else {
			userObject.getUserByEmail(email);
			hasPassword = userObject.password.empty() ? false : true;
			userID = userObject.userid;
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

bool LLLogicVote::signInWithPassword(string email, string password,
		int &userID) {
	if (email.empty() || password.empty()) {
		this->errorString = "Content can't be null";
		return false;
	}

	User userObject(this->database);
	userObject.email = email;
	userObject.password = password;

	bool result = userObject.signInWithPassword();
	if (result) {
		userID = userObject.userid;
	} else {
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

	//check if the email is exsit if use wanna use email to login
	if (!userObject->checkIfEmailExist()) {
		this->errorString = "This user does not exist.";
		return false;
	}

	//put this user into the sign in holding list, wait until the code confirm success
	string code = this->codeManager->getCode(userObject);

	//send the code to the email
	string mailContent =
			"Dear voter,\n\nYour dynamic Code is " + code
					+ ".\nPlease confirm your code as soon as possible.\n\nThank you.\nRampageworks";
	mailManager->sendMail(mailContent, email, "[Vote]Confrim Vote");

	return true;
}

bool LLLogicVote::uploadToken(int userID, string token) {
	User userObject(this->database);
	if (userObject.getUserByID(userID)) {
		userObject.token = token;
		if (userObject.updateUser()) {
			return true;
		} else {
			this->errorString = userObject.errorMessage;
			return false;
		}
	} else {
		this->errorString = "Can't find user.";
		return false;
	}
}

bool LLLogicVote::searchVoteByLocation(double longitude, double latitude,
		Json::Value &sendValue) {
	if (longitude > 180 || longitude < -180 || latitude > 90
			|| latitude < -90) {
		this->errorString = "Invalid location.";
		return false;
	}

	Vote *vote = new Vote(this->database);
	vote->longitude = longitude;
	vote->latitude = latitude;

	vector<Vote*> result = vote->indexVoteNearByLocation();

	delete vote;

	//establish the array in send value
	Json::Value arrayValue(Json::arrayValue);

	for (unsigned int i = 0; i < result.size(); i++) {
		Vote *tmpVote = result[i];

		Json::Value arrayItemValue;
		arrayItemValue["initiator"] = tmpVote->initiator;
		arrayItemValue["voteid"] = tmpVote->voteid;
		arrayItemValue["color"] = tmpVote->colorIndex;

		arrayValue.append(arrayItemValue);

		delete tmpVote;
	}

	sendValue["votelist"] = arrayValue;

	result.clear();

	return true;
}

bool LLLogicVote::searchVoteByID(int voteid, Json::Value &sendValue) {
	Vote tmpVote(this->database);
	tmpVote.voteid = voteid;

	//get the vote
	if (tmpVote.getVoteByID()) {
		//check if this vote has fnished
		time_t currentTime = time(NULL);
		double timeSpan = difftime(currentTime, tmpVote.endTime);
		if (tmpVote.isFnished || timeSpan > 0) {
			this->errorString = "This vote even has already finished.";
			return false;
		}

		//establish the array in send value
		Json::Value arrayValue(Json::arrayValue);
		Json::Value arrayItem;
		arrayItem["initiator"] = tmpVote.initiator;
		arrayItem["voteid"] = tmpVote.voteid;
		arrayItem["color"] = tmpVote.colorIndex;

		arrayValue.append(arrayItem);
		sendValue["votelist"] = arrayValue;

		return true;
	} else {
		this->errorString = tmpVote.errorMessage;
		return false;
	}
}

bool LLLogicVote::resendCode(string email, string firstName, string lastName,
		int resendType) {
	cout << "The content is" << email << firstName << lastName << endl;
	if (resendType == 0) {
		//sign up resend
		return this->signUp(firstName, lastName, email);
	} else if (resendType == 1) {
		//sign in resend
		return this->signInWithEmail(email);
	} else {
		this->errorString = "Invalid resendType";
		return false;
	}
}

bool LLLogicVote::getDuplicateNameList(int voteid, Json::Value &sendValue) {
	Vote tmpVote(this->database);
	tmpVote.voteid = voteid;

	if (!tmpVote.getVoteByID()) {
		this->errorString = "This vote does not exist.";
		return false;
	}

	//Duplicate vote could be overtime but can't be finished
	if (tmpVote.isFnished) {
		this->errorString = "This vote even has already finished.";
		return false;
	}

	vector<vector<string> > result = tmpVote.getDuplicateNameList();

	Json::Value resultListArray(Json::arrayValue);

	for (unsigned int i = 0; i < result.size(); i++) {
		Json::Value arrayItem;
		Json::Value emailList(Json::arrayValue);
		for (unsigned int j = 0; j < result[i].size(); j++) {
			if (j == 0) {
				arrayItem["name"] = result[i][0];
			} else {
				emailList[j] = result[i][j];
			}
		}

		arrayItem["emaillist"] = emailList;
		resultListArray.append(arrayItem);
	}

	sendValue["duplicatelist"] = resultListArray;

	return true;
}

bool LLLogicVote::cancelUserSelection(int voteid, string userEmail) {
	if (userEmail.empty()) {
		this->errorString = "Email can't be null.";
		return false;
	}

	VoteSelection tmpSelection(this->database);

	return tmpSelection.cancelSelection(voteid, userEmail);
}

bool LLLogicVote::adminResolveVote(int voteid) {
	//get the vote
	Vote tmpVote(this->database);
	tmpVote.voteid = voteid;
	tmpVote.getVoteByID();

	time_t timeTmp = time(NULL);
	double timeSpan = difftime(timeTmp, tmpVote.endTime);
	if (timeSpan > 0 || tmpVote.hasReachMaxValidNumber()) {
		//if the vote end time has passed,set this vote finished
		if (tmpVote.setVoteFinish()) {
			return true;
		} else {
			this->errorString = tmpVote.errorMessage;
			return false;
		}
	}
	return true;
}
