/*
 * VoteOption.h
 *
 *  Created on: Nov 18, 2013
 *      Author: kuaijianghua
 */

#ifndef VOTEOPTION_H_
#define VOTEOPTION_H_

#include <string>
#include "../../DataLayer/DLDatabase.h"

using namespace std;

class VoteOption {
public:
	VoteOption(DLDatabase *database);
	virtual ~VoteOption();

	string errorMessage;

	int idvoteOption;
	string content;
	int idvote;

	vector<VoteOption*> getVoteOptionsByVoteid();
	bool newVoteOption();

private:
	//数据库
	DLDatabase *database;
};

#endif /* VOTEOPTION_H_ */
