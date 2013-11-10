/*
 * PLDataLayer.h
 *
 *  Created on: Nov 10, 2013
 *      Author: kuaijianghua
 */

#ifndef PLDATALAYER_H_
#define PLDATALAYER_H_

#include <vector>
#include <string>
#include "DLDatabase.h"

using namespace std;

class PLDataLayer {
public:
	//单例方法
	static PLDataLayer * Instance() {
		if (0 == _instance) {
			_instance = new PLDataLayer;
		}
		return _instance;
	}

	//释放方法
	static void Release() {
		if (NULL != _instance) {
			delete _instance;
			_instance = NULL;
		}
	}

	void setDatabaseInfoFromConfigureManager();
	void addDatabaseWithName(string name);
	DLDatabase * getDatabaseByName(string name);

private:
	PLDataLayer(){};
	virtual ~PLDataLayer(){
		//delete all database
		vector<DLDatabase*>::iterator it = databaseList.begin();

		for(;it != databaseList.end(); it++){
			delete (*it);
		}

		databaseList.clear();
	};

	string userName;
	string address;
	string password;

	vector<DLDatabase*> databaseList;

	static PLDataLayer* _instance;
};

#endif /* PLDATALAYER_H_ */
