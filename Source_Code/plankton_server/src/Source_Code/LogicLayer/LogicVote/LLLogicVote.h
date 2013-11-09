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
#include "../../Common/ConfigureManager.h"
#include "../../Common/md5.h"
#include "../../Lib/json.h"
#include "User.h"
#include "CodeManager.h"
#include "MailManager.h"
#include <list>

using namespace std;

class LLLogicVote:public LLLogicBase {
public:
	typedef enum _VoteRequestType{
		SignUp = 0,
		CheckCode,
		SignInWithPassword,
		SignInWithEmail,
		ResendCode
	}VoteRequestType;

	LLLogicVote(){
		//configure mail manager
		ConfigureManager *configManager = ConfigureManager::Instance();
		string trustFileName = configManager->value["EmailTrustFileName"].asString();
		string contentFileName = configManager->value["EmailContentFileName"].asString();
		string sender = configManager->value["EmailAddress"].asString();
		string senderPassword= configManager->value["EmailPassword"].asString();
		mailManager = new MailManager(trustFileName,contentFileName,sender,senderPassword);

		codeManager = new CodeManager();
    	database = new DLDatabase;
    	database->initDB("localhost", "root", "123456", "Vote");
    }

	virtual ~LLLogicVote(){
		delete database;
		delete codeManager;
		delete mailManager;
	}

	string excuteRequest(string requestString,short version,unsigned int sessionID);

private:
	//数据库
	DLDatabase *database;

	//Code Manager
	CodeManager *codeManager;

	//Mail Manager
	MailManager *mailManager;

	//注册
	bool signUp(string firstName,string lastName,string email);

	//check code,checkType 0:signUp 1:signIn
	bool checkCode(string email,string code,int checkType);

	//resend the code
	bool resendCode(string email,string firstName,string lastName,int resendType);

	//login with password
	bool signInWithPassword(string email,string password);

	//登录
	bool login(string name,string password,string tokenString,string appName,unsigned int sessionID);
};

#endif /* LLLOGICVOTE_H_ */
