/*
 * LLLogicVote.h
 *
 *  Created on: Nov 3, 2013
 *      Author: kuaijianghua
 */

#ifndef LLLOGICVOTE_H_
#define LLLOGICVOTE_H_

#include "../LLLogicBase.h"
#include "../../DataLayer/DLDatabase.h"
#include "../../Common/PLog.h"
#include "../../Common/md5.h"
#include "../../Lib/json.h"
#include <vector>

class LLLogicVote:public LLLogicBase {
public:
	typedef enum _VoteRequestType{
		Register = 0,
		Login
	}VoteRequestType;

	LLLogicVote(){
    	database = new DLDatabase;
    	database->initDB("localhost", "root", "123456", "Vote");
    }

	virtual ~LLLogicVote(){
		delete database;
	}

	string excuteRequest(string requestString,short version,unsigned int sessionID);

private:
	//数据库
	DLDatabase *database;

	//注册
	bool signUp(string firstName,string lastName,string email);

	//登录
	bool login(string name,string password,string tokenString,string appName,unsigned int sessionID);
};

#endif /* LLLOGICVOTE_H_ */
