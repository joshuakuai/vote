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
#include "Vote.h"
#include "VoteOption.h"
#include "VoteSelection.h"
#include "CodeManager.h"
#include <list>

using namespace std;

class LLLogicVote: public LLLogicBase {
public:
	typedef enum _VoteRequestType {
		Unknow = -1,
		SignUp = 0,
		CheckCode,
		SignInWithPassword,
		SignInWithEmail,
		ResendCode,
		UploadToken,
		SearchVote,
		GetDuplicateSelection,
		CancelSelection,
		AdminResolveVote,
		InitialVote,
		JoinVote,
		ViewProcessingVote,
		IndexHistory,
		ViewHistoryVote,
		SetPassword,
		AutoPassword,
		GetParticipants
	} VoteRequestType;

	LLLogicVote() {
		mailManager = MailManager::Instance();
		codeManager = CodeManager::Instance();
		database = PLDataLayer::Instance()->getDatabaseByName("Vote");

		if (!doesAutoScanOpened) {
			PLog::logHint("LogicVote-Prepare to start auto-scan.");
			pthread_t sessionThread = NULL;

			if (pthread_create(&sessionThread, NULL, &autoScanFinishedVote,
					NULL) != 0) {
				PLog::logFatal("Can initial auto-scan");
			} else {
				doesAutoScanOpened = true;
			}
		}
	}

	virtual ~LLLogicVote() {
	}

	string excuteRequest(string requestString, short version,
			unsigned int sessionID);

private:
	//Indicator of auto-scan
	static bool doesAutoScanOpened;

	//数据库
	DLDatabase *database;

	//Code Manager
	CodeManager *codeManager;

	//Mail Manager
	MailManager *mailManager;

	//auto scan finished vote
	static void *autoScanFinishedVote(void *msg);

	//注册
	bool signUp(string firstName, string lastName, string email);

	//check code,checkType 0:signUp 1:signIn
	bool checkCode(string email, string code, int checkType, int &userID,
			bool &hasPassword);

	//resend the code
	bool resendCode(string email, string firstName, string lastName,
			int resendType);

	//login with password
	bool signInWithPassword(string email, string password, int &userID);

	//login with email
	bool signInWithEmail(string email);

	//upload Token
	bool uploadToken(int userID, string token);

	//search vote by location
	bool searchVoteByLocation(double longitude, double latitude,
			Json::Value &sendValue);

	//search vote by id
	bool searchVoteByID(int voteid, Json::Value &sendValue);

	//get vote duplicate selection
	//return the name list that have different choice
	bool getDuplicateNameList(int voteid, Json::Value &sendValue);

	//cancel the user's selection
	bool cancelUserSelection(int voteid, string userEmail);

	//Call this after the admin finish resolve duplicate name
	bool adminResolveVote(int voteid);

	//Initialize a vote, endTime's scale is minutes
	bool initializeVote(string title, int maxValidN, string passwd,
			double longitude, double latitude, int endTime, int userid,
			vector<string> contentVector, int color);

	//Give an selection for an vote
	bool joinVote(int voteOptionID,int userid);

	//view a processing vote
	bool viewProcessingVote(int voteid, string password, Json::Value &sendValue);

	//get the list of history
	//Request type: 1:user as initiator 2:user as participant
	bool getHistoryVoteList(int userid, int requestType, Json::Value &sendValue);

	//view the history vote detial
	bool viewHistoryVoteDetial(int voteid, int userid, Json::Value &sendValue);

	//set password
	bool setPassword(int userid, string oldPass, string newPass);

	//will send Email after generate auto password.
	bool generateAutoPassword(int userid);

	//get all participants of a vote
	bool getParticipants(int voteid, Json::Value &sendValue);

	//登录
	//bool login(string name,string password,string tokenString,string appName,unsigned int sessionID);
};

#endif /* LLLOGICVOTE_H_ */
