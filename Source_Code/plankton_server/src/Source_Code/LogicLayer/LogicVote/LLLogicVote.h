/*
 * LLLogicVote.h
 *
 *  Created on: Nov 3, 2013
 *      Author: kuaijianghua
 */

#ifndef LLLOGICVOTE_H_
#define LLLOGICVOTE_H_

#include "../LLLogicBase.h"
#include "../../DataLayer/PLDataLayer.h"
#include "../../Common/PLog.h"
#include "../../Common/md5.h"
#include "../../Lib/json.h"
#include "../../Common/MailManager.h"
#include "User.h"
#include "CodeManager.h"
#include <list>

using namespace std;

class LLLogicVote:public LLLogicBase {
public:
	typedef enum _VoteRequestType{
		SignUp = 0,
		CheckCode,
		SignInWithPassword,
		SignInWithEmail,
		ResendCode,
		UploadToken
	}VoteRequestType;

	LLLogicVote(){
		mailManager = MailManager::Instance();
		codeManager = CodeManager::Instance();
    	database = PLDataLayer::Instance()->getDatabaseByName("Vote");
    }

	virtual ~LLLogicVote(){}

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
	bool checkCode(string email,string code,int checkType,int &userID,bool &hasPassword);

	//resend the code
	bool resendCode(string email,string firstName,string lastName,int resendType);

	//login with password
	bool signInWithPassword(string email,string password,int &userID);

	//login with email
	bool signInWithEmail(string email);

	//upload Token
	bool uploadToken(int userID,string token);

	//登录
	bool login(string name,string password,string tokenString,string appName,unsigned int sessionID);
};

#endif /* LLLOGICVOTE_H_ */
