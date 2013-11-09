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
	string queryString = "SELECT * FROM user WHERE email='" + email + "'";

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
	string queryString = "SELECT * FROM user WHERE email='" + email + "' AND password IS NULL";
	vector<vector<string> > result = database->querySQL(queryString);

	if(result.size() > 0){
		this->errorMessage = "This user does not set any password.Please use Email verify login.";
		return false;
	}

	//convert the password to md5
	MD5 md5Password(password);

	queryString = "SELECT iduser FROM user WHERE email='" + email + "' AND password='" + md5Password.md5() + "'";
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

bool User::signUp()
{
	string queryString = "INSERT INTO user(email,last_name,first_name) VALUES('" + email + "','" + lastName + "','" + firstName + "')";

	return database->executeSQL(queryString);
}
