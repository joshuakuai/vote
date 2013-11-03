/*
 * LLLogicDefault.h
 *
 *  Created on: Feb 7, 2013
 *      Author: joshuakuai
 */

#ifndef LLLOGICUSERMANAGEMENT_H_
#define LLLOGICUSERMANAGEMENT_H_

#include "../LLLogicBase.h"
#include "../../DataLayer/DLDatabase.h"
#include "User.h"
#include <vector>

using namespace std;

class LLLogicUserManagement:public LLLogicBase {
public:
	typedef enum _UserManagementRequestType{
		Register = 0,
		Login
	}_UserManagementRequestType;

	LLLogicUserManagement(){
    	database = new DLDatabase;
    	database->initDB("localhost", "root", "199143a", "PlanktonServer");
    }

	virtual ~LLLogicUserManagement(){
		delete database;
	}

	string excuteRequest(string requestString,short version,unsigned int sessionID);

private:
	//数据库
	DLDatabase *database;

	//注册
	bool registerUser(string name,string password,string tokenString,string appName);

	//登录
	bool login(string name,string password,string tokenString,string appName,unsigned int sessionID);
};

#endif /* LLLOGICUSERMANAGEMENT_H_ */
