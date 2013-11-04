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
	errorMessage = NULL;
}

bool checkIfEmailExist(string email)
{

}

bool signUp(string firstName,string lastName,string email)
{

}
