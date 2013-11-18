/*
 * VoteSelection.cpp
 *
 *  Created on: Nov 18, 2013
 *      Author: kuaijianghua
 */

#include "VoteSelection.h"
#include "../../Common/Converter.h"

VoteSelection::VoteSelection(DLDatabase *database) {
	this->database = database;
	this->iduser = -1;
	this->idvoteOption = -1;
	this->state = -1;
}

VoteSelection::~VoteSelection() {
	this->database = NULL;
}

vector<VoteSelection*> VoteSelection::getSelectionByVoteOptionID() {
	string queryString = "SELECT * FROM voteSelection WHERE idvoteOption="
			+ Converter::int_to_string(this->idvoteOption);

	vector<vector<string> > voteSelectionList = this->database->querySQL(
			queryString);

	vector<VoteSelection*> result;

	if (voteSelectionList.size()) {
		this->errorMessage = "This option does not have any selection";
		return result;
	}

	for (unsigned int i = 0; i < voteSelectionList.size(); i++) {
		VoteSelection *tmpSelection = new VoteSelection(this->database);

		tmpSelection->idvoteOption = Converter::string_to_int(voteSelectionList[i][0]);
		tmpSelection->iduser = Converter::string_to_int(voteSelectionList[i][1]);
		tmpSelection->state = Converter::string_to_int(voteSelectionList[i][2]);

		result.push_back(tmpSelection);
	}

	return result;
}
