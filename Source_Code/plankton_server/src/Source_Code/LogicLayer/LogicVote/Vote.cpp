/*
 * Vote.cpp
 *
 *  Created on: Nov 13, 2013
 *      Author: kuaijianghua
 */

#include "Vote.h"
#include "../../Common/Converter.h"
#include "../../Common/LocationCalculator.h"
#include "../../Common/Pusher.h"
#include "../../Common/md5.h"
#include "VoteOption.h"
#include "VoteSelection.h"
#include "User.h"

Vote::Vote(DLDatabase *database) {
	this->initiatorid = -1;
	this->voteid = -1;
	this->colorIndex = -1;
	this->initiator = "";
	this->title = "";
	this->password = "";
	this->maxValidUser = -1;
	this->database = database;
	this->longitude = 0.0;
	this->latitude = 0.0;
	this->createTime = -1;
	this->endTime = -1;
	this->isFnished = true;
}

Vote::~Vote() {
	this->database = NULL;
}

vector<Vote*> Vote::indexVoteNearByLocation() {
	//Convert the log/lat to string
	string longitudeString = Converter::double_to_string(this->longitude);
	string latitudeString = Converter::double_to_string(this->latitude);

	//get current time
	time_t now = time(NULL);
	string timeString = Converter::time_t_to_mysql_datetime_string(now);

	//get the vote in the same location and available
	std::ostringstream stringStream;
	stringStream << "SELECT vote.idvote,user.first_name,user.last_name,vote.color_index,vote.longitude,vote.latitude FROM vote,user WHERE vote.idinitiator=user.iduser AND (" << longitudeString << "-vote.longitude"<< ")<1 AND (" << latitudeString
			<< "-vote.latitude)<1 AND end_time>'" << timeString
			<< "' AND is_Finish=false;";

	string queryString = stringStream.str();

	vector<vector<string> > sqlResult = this->database->querySQL(queryString);

	cout<<"The vote near by number:" <<sqlResult.size() << endl;

	//form the result
	vector<Vote*> result;

	for (unsigned int i = 0; i < sqlResult.size(); i++) {
		Vote *vote = new Vote(this->database);

		vote->voteid = Converter::string_to_int(sqlResult[i][0]);
		vote->initiator = sqlResult[i][1] + " " + sqlResult[i][2];
		vote->colorIndex = Converter::string_to_int(sqlResult[i][3]);
		vote->longitude = Converter::string_to_double(sqlResult[i][4]);
		vote->latitude = Converter::string_to_double(sqlResult[i][5]);

		//calculate the distance
		double distance = LocationCalculator::calculateDistance(vote->longitude,
				vote->latitude, this->longitude, this->latitude);

		cout<< "The distance is about " << distance << endl;
		if (distance < 1) {
			result.push_back(vote);
		} else {
			delete vote;
		}
	}

	return result;
}

bool Vote::getVoteByID() {
	string queryString = "SELECT * FROM vote WHERE idvote="
			+ Converter::int_to_string(this->voteid);

	vector<vector<string> > result = this->database->querySQL(queryString);

	if (result.size() == 0) {
		this->errorMessage == "Can't find Vote.";
		return false;
	} else {
		this->setVoteByDatabaseResult(result);
	}

	//get initiator name
	queryString = "SELECT first_name,last_name FROM user WHERE iduser="
			+ Converter::int_to_string(this->initiatorid);

	result = this->database->querySQL(queryString);

	if (result.size() == 0) {
		this->errorMessage == "Can't find Initiator.";
		return false;
	}

	this->initiator = result[0][0] + result[0][1];

	return true;
}

bool Vote::getVoteByInitiatorIDAndCreateTime() {
	string queryString = "SELECT * FROM vote WHERE idinitiator="
			+ Converter::int_to_string(this->initiatorid) + " AND create_time='" + Converter::time_t_to_mysql_datetime_string(this->createTime) + "';" ;

	vector<vector<string> > result = this->database->querySQL(queryString);

	if (result.size() == 0) {
		this->errorMessage == "Can't find Vote.";
		return false;
	} else {
		this->setVoteByDatabaseResult(result);
		return true;
	}
}

bool Vote::getVoteByOptionID(int optionID) {
	string queryString =
			"SELECT * FROM vote,voteOption WHERE voteOption.idvoteOption="
					+ Converter::int_to_string(optionID)
					+ " AND vote.idvote=voteOption.idvote;";

	vector<vector<string> > result = this->database->querySQL(queryString);

	if (result.size() == 0) {
		this->errorMessage == "Can't find Vote.";
		return false;
	} else {
		this->setVoteByDatabaseResult(result);
		return true;
	}
}

void Vote::setVoteByDatabaseResult(vector<vector<string> > result) {
	if (result.size() == 0) {
		return;
	}

	this->voteid = Converter::string_to_int(result[0][0]);
	this->initiatorid = Converter::string_to_int(result[0][1]);
	this->title = result[0][2];
	this->maxValidUser = Converter::string_to_int(result[0][3]);
	this->password = result[0][4];
	this->longitude = Converter::string_to_double(result[0][5]);
	this->latitude = Converter::string_to_double(result[0][6]);
	this->createTime = Converter::mysql_datetime_string_to_time_t(result[0][7]);
	this->endTime = Converter::mysql_datetime_string_to_time_t(result[0][8]);
	this->isFnished = Converter::string_to_int(result[0][9]);
	this->colorIndex = Converter::string_to_int(result[0][10]);
}

bool Vote::newVote() {
	//encrypt the password
	MD5 md5(password);
	password = md5.md5();

	std::ostringstream stringStream;
	//cout<< "Initiator id is" << initiatorid <<endl;
	stringStream
			<< "INSERT INTO vote(idinitiator,title,max_valid_user,password,longitude,latitude,create_time,end_time,color_index) VALUES("
			<< initiatorid << ",'" << title << "'," << maxValidUser << ",'"
			<< password << "','" << longitude << "','" << latitude << "','"
			<< Converter::time_t_to_mysql_datetime_string(createTime) << "','"
			<< Converter::time_t_to_mysql_datetime_string(endTime) << "',"
			<< colorIndex << ");";
	string queryString = stringStream.str();

	//cout<< "Request sql statment is:" << queryString <<endl;
	//cout<< createTime << "    " << endTime << endl;

	if (this->database->executeSQL(queryString)) {
		return true;
	} else {
		this->errorMessage = "Failed to save Vote.";
		return false;
	}
}

vector<vector<string> > Vote::getDuplicateNameList() {
	vector<vector<string> > result;

	if (this->voteid == -1) {
		this->errorMessage = "Invalid voteID.";
		return result;
	}

	//get vote's all selection
	VoteOption tmpVoteOption(this->database);
	tmpVoteOption.idvote = this->voteid;

	vector<VoteOption*> optionList = tmpVoteOption.getVoteOptionsByVoteid();

	if (optionList.size() == 0) {
		this->errorMessage = "This vote does not have any option.";
		return result;
	}

	vector<VoteSelection*> selectionList;

	//get all selection of each option
	for (unsigned int i = 0; i < optionList.size(); i++) {
		//get the option id
		int voteOptionID = optionList[i]->idvoteOption;

		VoteSelection tmpSelection(this->database);
		tmpSelection.idvoteOption = voteOptionID;

		//get the selection list
		vector<VoteSelection*> tmpSelectionList =
				tmpSelection.getSelectionByVoteOptionID();

		for (unsigned int j = 0; j < tmpSelectionList.size(); j++) {
			selectionList.push_back(tmpSelectionList[j]);
		}

		delete optionList[i];
	}

	optionList.clear();

	//check if there is any duplicate
	vector<vector<string> > tmpNameList;

	for (unsigned int i = 0; i < selectionList.size(); i++) {
		//check if this selection is pending
		if (selectionList[i]->state != 0) {
			//confirmed or canceled
			continue;
		}

		//get the user name
		User tmpUser(this->database);
		tmpUser.userid = selectionList[i]->iduser;
		tmpUser.getUserByID();

		string userFullName = tmpUser.firstName + " " + tmpUser.lastName;

		bool hasFindOverlap = false;
		for (unsigned int j = 0; j < tmpNameList.size(); j++) {
			if (tmpNameList[j][0].compare(userFullName) == 0) {
				//push back this email and break
				tmpNameList[j].push_back(tmpUser.email);
				hasFindOverlap = true;
				break;
			}
		}

		if (!hasFindOverlap) {
			//did not find any name overlap
			vector<string> nameInfoList;
			nameInfoList.push_back(userFullName);
			nameInfoList.push_back(tmpUser.email);

			tmpNameList.push_back(nameInfoList);
		}
	}

	//add those has overlap to the result

	for (unsigned int i = 0; i < tmpNameList.size(); i++) {
		if (tmpNameList[i].size() > 2) {
			result.push_back(tmpNameList[i]);
		}
	}

	return result;
}

bool Vote::setVoteFinish() {
	if (this->voteid == -1) {
		this->errorMessage = "Invalid vote id.";
		return false;
	}

	string voteString = Converter::int_to_string(this->voteid);

	string queryString = "UPDATE vote SET is_finish=true WHERE idvote="
			+ voteString + ";";

	if (this->database->executeSQL(queryString)) {
		//get all user's token
		queryString =
				"SELECT user.token FROM vote,voteOption,voteSelection,user WHERE vote.idvote="
						+ voteString
						+ " AND vote.idvote=voteOption.idvote AND voteOption.idvoteOption=voteSelection.idvoteOption AND voteSelection.iduser=user.iduser";
		vector<vector<string> > result = this->database->querySQL(queryString);

		if (result.size() != 0) {
			//form the token list vector
			vector<string> tokenStringList;

			for (unsigned int i = 0; i < result.size(); i++) {
				tokenStringList.push_back(result[i][0]);
			}

			char log[100];
			sprintf(log, "Vote(%d) has a final result, check it out!",
					this->voteid);

			PusherContent content;
			content.badge = 1;
			content.content = string(log);
			content.sound = "default";

			Pusher::Instance()->pushNotification(content, tokenStringList);
		}

		return true;
	} else {
		this->errorMessage = "Failed to close vote.";
		return false;
	}
}

bool Vote::setAllPendingVoteSelectionConfirmed() {
	std::ostringstream stringStream;
	stringStream
			<< "UPDATE voteSelection,vote,voteOption SET voteSelection.state=1 WHERE vote.idvote="
			<< this->voteid
			<< " AND vote.idvote=voteOption.idvote AND voteOption.idvoteOption=voteSelection.idvoteOption AND voteSelection.state=0";
	string queryString = stringStream.str();

	return this->database->executeSQL(queryString);
}

//MUST GET THE VOTE'S INFO BEFORE CALL THIS METHOD
bool Vote::hasReachMaxValidNumber() {
	if (this->voteid == -1) {
		this->errorMessage = "Invalid vote id.";
		return false;
	}

	string queryString =
			"SELECT * FROM vote,voteOption,voteSelection WHERE vote.idvote=voteOption.idvote AND voteOption.idvoteOption = voteSelection.idvoteOption AND voteSelection.state=1";

	vector<vector<string> > result = this->database->querySQL(queryString);

	if ((int) result.size() == this->maxValidUser) {
		return true;
	} else {
		return false;
	}
}

vector<Vote*> Vote::getAllUnfinishedVote() {
	//get all unfinished votes
	string queryString = "SELECT * FROM vote WHERE is_finish=false";

	vector<vector<string> > sqlResult = this->database->querySQL(queryString);

	vector<Vote*> result;
	for (unsigned int i = 0; i < sqlResult.size(); i++) {
		Vote *tmpVote = new Vote(this->database);

		tmpVote->initiatorid = Converter::string_to_int(sqlResult[i][1]);
		tmpVote->title = sqlResult[i][2];
		tmpVote->maxValidUser = Converter::string_to_int(sqlResult[i][3]);
		tmpVote->password = sqlResult[i][4];
		tmpVote->longitude = Converter::string_to_double(sqlResult[i][5]);
		tmpVote->latitude = Converter::string_to_double(sqlResult[i][6]);
		tmpVote->createTime = Converter::mysql_datetime_string_to_time_t(
				sqlResult[i][7]);
		tmpVote->endTime = Converter::mysql_datetime_string_to_time_t(
				sqlResult[i][8]);
		tmpVote->isFnished = Converter::string_to_int(sqlResult[i][9]);
		tmpVote->colorIndex = Converter::string_to_int(sqlResult[i][10]);

		result.push_back(tmpVote);
	}

	return result;
}

int Vote::getPendingSelectionNumber() {
	string queryString =
			"SELECT * FROM vote,voteOption,voteSelection WHERE vote.idvote=voteOption.idvote AND voteOption.idvoteOption = voteSelection.idvoteOption AND voteSelection.state=0";

	vector<vector<string> > result = this->database->querySQL(queryString);

	return result.size();
}

int Vote::currentValidNumber() {
	string queryString =
			"SELECT * FROM vote,voteOption,voteSelection WHERE vote.idvote=voteOption.idvote AND voteOption.idvoteOption = voteSelection.idvoteOption AND voteSelection.state=1";

	vector<vector<string> > result = this->database->querySQL(queryString);

	return result.size();
}

bool Vote::checkPassword() {
	//encrypt the password
	MD5 md5(password);
	password = md5.md5();

	std::ostringstream stringStream;
	stringStream << "SELECT * FROM vote WHERE idvote=" << this->voteid
			<< " AND password='" << this->password << "';";
	string queryString = stringStream.str();

	vector<vector<string> > result = this->database->querySQL(queryString);

	if (result.size() != 0) {
		return true;
	} else {
		return false;
	}
}

vector<Vote> Vote::getVoteHistoryWithInitiatorID() {
	std::ostringstream stringStream;
	stringStream << "SELECT * FROM vote WHERE idinitiator=" << this->initiatorid
			<< ";";
	string queryString = stringStream.str();

	vector<vector<string> > sqlResult = this->database->querySQL(queryString);

	return this->getVoteListBySQLResult(sqlResult);
}

vector<Vote> Vote::getVoteHistoryWithParticipantsID(int participantID) {
	std::ostringstream stringStream;
	stringStream
			<< "SELECT vote.idvote,vote.idinitiator,vote.title,vote.max_valid_user,vote.password,vote.longitude,vote.latitude,vote.create_time,vote.end_time,vote.is_finish,vote.color_index"
			<< " FROM vote,voteOption,voteSelection,user WHERE user.iduser="
			<< participantID
			<< " AND user.iduser=voteSelection.iduser AND voteSelection.idvoteOption=voteOption.idvoteOption AND voteOption.idvote=vote.idvote;";
	string queryString = stringStream.str();

	vector<vector<string> > sqlResult = this->database->querySQL(queryString);

	return this->getVoteListBySQLResult(sqlResult);
}

vector<Vote> Vote::getVoteListBySQLResult(vector<vector<string> > sqlResult) {
	vector<Vote> result;

	for (unsigned int i = 0; i < sqlResult.size(); i++) {
		Vote tmpVote(this->database);

		tmpVote.voteid = Converter::string_to_int(sqlResult[i][0]);
		tmpVote.initiatorid = Converter::string_to_int(sqlResult[i][1]);
		tmpVote.title = sqlResult[i][2];
		tmpVote.maxValidUser = Converter::string_to_int(sqlResult[i][3]);
		tmpVote.password = sqlResult[i][4];
		tmpVote.longitude = Converter::string_to_double(sqlResult[i][5]);
		tmpVote.latitude = Converter::string_to_double(sqlResult[i][6]);
		tmpVote.createTime = Converter::mysql_datetime_string_to_time_t(
				sqlResult[i][7]);
		tmpVote.endTime = Converter::mysql_datetime_string_to_time_t(
				sqlResult[i][8]);
		tmpVote.isFnished = Converter::string_to_int(sqlResult[i][9]);
		tmpVote.colorIndex = Converter::string_to_int(sqlResult[i][10]);

		result.push_back(tmpVote);
	}

	return result;
}
