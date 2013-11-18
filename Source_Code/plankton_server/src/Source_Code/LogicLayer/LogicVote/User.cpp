/*
 * User.cpp
 *
 *  Created on: Nov 3, 2013
 *      Author: kuaijianghua
 */

#include "User.h"
#include "../../Common/md5.h"
#include "../../Common/Converter.h"

User::User(DLDatabase *database) {
	userid = -1;
	this->database = database;
	errorMessage = "";
}

bool User::checkIfEmailExist() {
	//Check if the email is exist
	string queryString = "SELECT * FROM user WHERE email='" + email + "';";

	vector<vector<string> > result = database->querySQL(queryString);
	if (result.size() == 0) {
		return false;
	}else{
		return true;
	}
}

bool User::signInWithPassword()
{
	//check if this user has password
	string queryString = "SELECT * FROM user WHERE email='" + email + "' AND password IS NULL;";
	vector<vector<string> > result = database->querySQL(queryString);

	if(result.size() > 0){
		this->errorMessage = "This user does not set any password.Please use Email verify login.";
		return false;
	}

	//convert the password to md5
	MD5 md5Password(password);

	queryString = "SELECT iduser FROM user WHERE email='" + email + "' AND password='" + md5Password.md5() + "';";
	result = database->querySQL(queryString);

	if(result.size() > 0){
		//verify success
		this->userid = Converter::string_to_int(result[0][0]);
		return true;
	}else{
		this->errorMessage = "Password invalid.";
		return false;
	}
}

bool User::getUserByEmail(string email)
{
	string queryString = "SELECT * FROM user WHERE email='" + email + "';";

	vector<vector<string> > result = this->database->querySQL(queryString);

	if(result.size() > 0){
		this->userid = Converter::string_to_int(result[0][0]);
		this->firstName = result[0][1];
		this->lastName = result[0][2];
		this->email = result[0][3];
		this->password = result[0][4];
		this->token = result[0][5];
		return true;
	}else{
		return false;
	}
}

bool User::signUp()
{
	string queryString = "INSERT INTO user(email,last_name,first_name) VALUES('" + email + "','" + lastName + "','" + firstName + "');";

	return database->executeSQL(queryString);
}

bool User::getUserByID(int userid)
{
	string queryString = "SELECT * FROM user WHERE iduser=" + Converter::int_to_string(userid) + ";";

	vector<vector<string> > result = this->database->querySQL(queryString);

	if(result.size() > 0){
		this->userid = Converter::string_to_int(result[0][0]);
		this->firstName = result[0][1];
		this->lastName = result[0][2];
		this->email = result[0][3];
		this->password = result[0][4];
		this->token = result[0][5];
		return true;
	}else{
		return false;
	}
}

bool User::getUserByID()
{
	return this->getUserByID(this->userid);
}

bool User::updateUser()
{
	string queryString = "UPDATE user SET email='" + email +"',first_name='" + firstName + "',last_name='" + lastName + "',token='" + token + "',password='" + password + "' WHERE iduser=" + Converter::int_to_string(userid) + ";";
	return database->executeSQL(queryString);
}
