/*
 * User.cpp
 *
 *  Created on: Nov 3, 2013
 *      Author: kuaijianghua
 */

#include "User.h"

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

bool User::signUp()
{
	string queryString = "INSERT INTO user(email,lastName,firstName) VALUES('" + email + "','" + lastName + "','" + firstName + "')";

	return database->executeSQL(queryString);
}
