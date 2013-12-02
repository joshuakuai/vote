/*
 * Vote.h
 *
 *  Created on: Nov 13, 2013
 *      Author: kuaijianghua
 */

#ifndef VOTE_H_
#define VOTE_H_

#include <vector>
#include "../../DataLayer/DLDatabase.h"

class Vote {
public:
	Vote(DLDatabase *database);
	virtual ~Vote();

	int voteid;
	int initiatorid;
	string initiator;
	string title;
	string password;
	time_t createTime;
	time_t endTime;
	bool isFnished;
	int maxValidUser;
	int colorIndex;
	double longitude;
	double latitude;

	string errorMessage;

	//get the vote near by 1000m
	vector<Vote*> indexVoteNearByLocation();
	vector<Vote> getVoteHistoryWithInitiatorID();
	vector<Vote> getVoteHistoryWithParticipantsID(int participantID);
	vector<vector<string> > getDuplicateNameList();
	bool setVoteFinish();
	bool setAllPendingVoteSelectionConfirmed();
	bool getVoteByID();
	bool getVoteByInitiatorIDAndCreateTime();
	bool getVoteByOptionID(int optionID);
	int  currentValidNumber();
	bool hasReachMaxValidNumber();
	bool newVote();
	bool checkPassword();
	int getPendingSelectionNumber();

	vector<Vote*> getAllUnfinishedVote();

private:
	//数据库
	DLDatabase *database;

	void setVoteByDatabaseResult(vector<vector<string> > result);
	vector<Vote> getVoteListBySQLResult(vector<vector<string> > sqlResult);
};

#endif /* VOTE_H_ */
