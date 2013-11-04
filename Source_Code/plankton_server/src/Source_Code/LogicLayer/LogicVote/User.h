/*
 * User.h
 *
 *  Created on: Nov 3, 2013
 *      Author: kuaijianghua
 */

#ifndef USER_H_
#define USER_H_

#include <string>
#include "../../DataLayer/DLDatabase.h"

using namespace std;

class User {
public:
	User(DLDatabase *database);
	virtual ~User(){};

	int userid;
	string firstName;
	string lastName;
	string email;
	string password;
	string token;

	string errorMessage;

	bool checkIfEmailExist();
	bool signUp();

private:
	//数据库
	DLDatabase *database;
};

#endif /* USER_H_ */
