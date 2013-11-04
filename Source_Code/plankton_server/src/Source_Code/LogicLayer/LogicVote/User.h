/*
 * User.h
 *
 *  Created on: Nov 3, 2013
 *      Author: kuaijianghua
 */

#ifndef USER_H_
#define USER_H_
#include <string>

using namespace std;

class User {
public:
	User();
	virtual ~User();

	int userid;
	string firstName;
	string lastName;
	string email;
	string password;
	string token;
};

#endif /* USER_H_ */
