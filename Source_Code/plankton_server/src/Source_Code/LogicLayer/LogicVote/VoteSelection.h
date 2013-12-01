/*
 * VoteSelection.h
 *
 *  Created on: Nov 18, 2013
 *      Author: kuaijianghua
 */

#ifndef VOTESELECTION_H_
#define VOTESELECTION_H_

#include <string>
#include <vector>
#include "../../DataLayer/DLDatabase.h"

using namespace std;

class VoteSelection {
public:
	VoteSelection(DLDatabase *database);
	virtual ~VoteSelection();

	int idvoteOption;
	int iduser;

	//-1:canceled 0:pending 1;confirm
	int state;

	string errorMessage;

	vector<VoteSelection*> getSelectionByVoteOptionID();
	bool newSelection();
	bool setAllSelectionPendingWithName(string userFirstName,string userLastName);
	bool setSelectionConfirm();
	bool cancelSelection(int voteid,string userEmail);

private:
	//数据库
	DLDatabase *database;
};

#endif /* VOTESELECTION_H_ */
