/*
 * User.h
 *
 *  Created on: 2013-7-2
 *      Author: Joshua
 */

#ifndef USER_H_
#define USER_H_

#include <string>

using namespace std;

/*
 * Base class for all player(customer)
 */
class User {
public:
	User(){
		sessionID = -1;
		userID = -1;
		userName = "";
	}

	virtual ~User(){

	}

	int sessionID;
	int userID;
	string userName;

protected:

};

#endif /* USER_H_ */
