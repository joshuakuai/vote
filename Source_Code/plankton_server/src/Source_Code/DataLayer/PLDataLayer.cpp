/*
 * PLDataLayer.cpp
 *
 *  Created on: Nov 10, 2013
 *      Author: kuaijianghua
 */

#include "PLDataLayer.h"
#include "../Common/ConfigureManager.h"
#include "../Common/PLog.h"

PLDataLayer* PLDataLayer::_instance = NULL;

void PLDataLayer::setDatabaseInfoFromConfigureManager()
{
	this->userName = ConfigureManager::Instance()->value["DatabaseUserName"].asString();
	this->password = ConfigureManager::Instance()->value["DatabasePassword"].asString();
	this->address = ConfigureManager::Instance()->value["DatabaseAddress"].asString();

	if(userName.empty() || password.empty() || address.empty()){
		PLog::logFatal("Database profile does not correct,please check configure file.");
	}
}


void PLDataLayer::addDatabaseWithName(string name)
{
	DLDatabase *database = new DLDatabase;
	if(database->initDB(address, userName, password, name)){
		this->databaseList.push_back(database);
	}else{
		PLog::logWarning("Can't initial database "+name);
	}
}

DLDatabase * PLDataLayer::getDatabaseByName(string name)
{
	vector<DLDatabase*>::iterator it = databaseList.begin();

	for(;it != databaseList.end(); it++){
		if(name.compare((*it)->getDatabaseName()) == 0){
			return (*it);
		}
	}

	PLog::logWarning("Can't find database "+name);

	return NULL;
}
