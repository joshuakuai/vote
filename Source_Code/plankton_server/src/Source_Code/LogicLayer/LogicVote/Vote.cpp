/*
 * Vote.cpp
 *
 *  Created on: Nov 13, 2013
 *      Author: kuaijianghua
 */

#include "Vote.h"
#include "../../Common/Converter.h"
#include "../../Common/LocationCalculator.h"

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
	string queryString =
			"SELECT idvote,first_name,last_name,color_index,longitude,latitude FROM vote WHERE first_name IN(SELECT first_name from user WHERE vote.idinitiator=user.iduser) AND last_name IN(SELECT last_name from user WHERE vote.idinitiator=user.iduser) AND (longitude-"
					+ longitudeString + ")<1 AND (latitude-" + latitudeString
					+ ")<1 AND end_time>" + timeString
					+ " AND is_Finish=false;";
	vector<vector<string> > sqlResult = this->database->querySQL(queryString);

	//form the result
	vector<Vote*> result;

	for (unsigned int i = 0; i < sqlResult.size(); i++) {
		Vote *vote = new Vote(this->database);

		vote->voteid = Converter::string_to_int(sqlResult[i][0]);
		vote->initiator = sqlResult[i][1] + sqlResult[i][2];
		vote->colorIndex = Converter::string_to_int(sqlResult[i][3]);
		vote->longitude = Converter::string_to_double(sqlResult[i][4]);
		vote->latitude = Converter::string_to_double(sqlResult[i][5]);

		//calculate the distance
		double distance = LocationCalculator::calculateDistance(vote->longitude,
				vote->latitude, this->longitude, this->latitude);

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
	}

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
