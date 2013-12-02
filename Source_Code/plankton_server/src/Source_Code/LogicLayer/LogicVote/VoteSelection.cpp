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

		tmpSelection->idvoteOption = Converter::string_to_int(
				voteSelectionList[i][0]);
		tmpSelection->iduser = Converter::string_to_int(
				voteSelectionList[i][1]);
		tmpSelection->state = Converter::string_to_int(voteSelectionList[i][2]);

		result.push_back(tmpSelection);
	}

	return result;
}

bool VoteSelection::cancelSelection(int voteid, string userEmail) {
	string queryString =
			"UPDATE voteOption,user,vote,voteSelection SET voteSelection.state=-1 WHERE vote.idvote="
					+ Converter::int_to_string(voteid) + " AND user.email='"
					+ userEmail + "';";

	return this->database->executeSQL(queryString);
}

bool VoteSelection::newSelection() {
	//all new selection will be pending
	std::ostringstream stringStream;
	stringStream
			<< "INSERT INTO voteSelection(idvoteOption,iduser,state) VALUES("
			<< idvoteOption << "," << this->iduser << ",0);";

	string queryString = stringStream.str();

	return this->database->executeSQL(queryString);
}

bool VoteSelection::setAllSelectionPendingWithName(string userFirstName,
		string userLastName) {
	std::ostringstream stringStream;
	stringStream
			<< "UPDATE voteSelection,user SET voteSelection.state=0 WHERE user.iduser=voteSelection.iduser AND user.first_name='"
			<< userFirstName << "' AND user.last_name='" << userLastName
			<< "';";
	string queryString = stringStream.str();

	return this->database->executeSQL(queryString);
}

bool VoteSelection::setSelectionConfirm() {
	std::ostringstream stringStream;
	stringStream << "UPDATE voteSelection SET state=1 WHERE idvoteOption="
			<< this->idvoteOption << " AND iduser=" << this->iduser << ";";
	string queryString = stringStream.str();

	return this->database->executeSQL(queryString);
}

bool VoteSelection::getVoteSelection(vector<int> optionIDList) {
	std::ostringstream stringStream;
	stringStream << "SELECT * FROM voteSelection WHERE iduser=" << iduser << " AND (";

	for(unsigned int i =0;i<optionIDList.size();i++){
		stringStream <<" idvoteOption=" << optionIDList[i];

		if(optionIDList.size() == i+1){
			stringStream << ");";
		}else{
			stringStream << " OR";
		}
	}

	string queryString = stringStream.str();

	vector<vector<string> > sqlResult = this->database->querySQL(queryString);

	if(sqlResult.size()==0){
		this->errorMessage = "Can't find selection!";
		return false;
	}else{
		this->idvoteOption = Converter::string_to_int(sqlResult[0][0]);
		this->iduser = Converter::string_to_int(sqlResult[0][1]);
		this->state = Converter::string_to_int(sqlResult[0][2]);
		return true;
	}
}
