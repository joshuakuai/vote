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
	vector<VoteOption*> result;

	if (this->idvote == -1) {
		this->errorMessage = "VoteID invalid!";
		return result;
	}

	string queryString = "SELECT * FROM voteOption WHERE idvoteOption="
			+ Converter::int_to_string(this->idvote);

	vector<vector<string> > voteOptionResult = this->database->querySQL(
			queryString);

	for (unsigned int i = 0; i < voteOptionResult.size(); i++) {
		VoteOption *tmpOption = new VoteOption(this->database);

		tmpOption->idvoteOption = Converter::string_to_int(
				voteOptionResult[i][0]);
		tmpOption->content = voteOptionResult[i][1];
		tmpOption->idvote = Converter::string_to_int(voteOptionResult[i][2]);

		result.push_back(tmpOption);
	}

	return result;
}

bool VoteOption::newVoteOption() {
	std::ostringstream stringStream;
	stringStream << "INSERT INTO voteOption(content,idvote) VALUES(" << content
			<< "," << idvote << ");";
	string queryString = stringStream.str();

	if (this->database->executeSQL(queryString)) {
		return true;
	} else {
		this->errorMessage = "Failed to save Vote Option.";
		return false;
	}
}

