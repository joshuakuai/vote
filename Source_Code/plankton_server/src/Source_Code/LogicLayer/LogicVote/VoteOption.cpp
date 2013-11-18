/*
 * VoteOption.cpp
 *
 *  Created on: Nov 18, 2013
 *      Author: kuaijianghua
 */

#include "VoteOption.h"
#include "../../Common/Converter.h"

VoteOption::VoteOption(DLDatabase *database) {
	this->database = database;
	this->idvote = -1;
	this->idvoteOption = -1;
	this->content = "";
	this->errorMessage = "";
}

VoteOption::~VoteOption() {
	this->database = NULL;
}

vector<VoteOption*> VoteOption::getVoteOptionsByVoteid() {
	if (this->idvote == -1) {
		this->errorMessage = "VoteID invalid!";
		return NULL;
	}

	string queryString = "SELECT * FROM voteOption WHERE idvoteOption="
			+ Converter::int_to_string(this->idvote);

	vector<vector<string> > voteOptionResult = this->database->querySQL(queryString);

	vector<VoteOption*> result;

	for(unsigned int i =0; i<voteOptionResult.size() ;i++){
		VoteOption *tmpOption = new VoteOption(this->database);

		tmpOption->idvoteOption = Converter::string_to_int(voteOptionResult[i][0]);
		tmpOption->content = voteOptionResult[i][1];
		tmpOption->idvote = Converter::string_to_int(voteOptionResult[i][2]);

		result.push_back(tmpOption);
	}

	return result;
}

