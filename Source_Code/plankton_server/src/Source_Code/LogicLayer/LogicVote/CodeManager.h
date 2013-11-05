/*
 * CodeManager.h
 *
 *  Created on: Nov 3, 2013
 *      Author: shinezhao
 */

#ifndef CODEMANAGER_H_
#define CODEMANAGER_H_

#include <list>
#include <string>
#include <ctime>
#include <pthread.h>
#include "User.h"


//record struct
struct CodeConfirmRecord{
	User *userData;
	string code;
	time_t createTime;
};

using namespace std;

class CodeManager {
public:
	CodeManager(){};
	virtual ~CodeManager(){};
	string getCode(User* userData);

	//*if it cannot match any email, this value does not change -1
	// if there is a match, but the code is wrong, the value turn to 0
	// if the code is right, the value turn to 1*
	int codeConfirm(string emailAdd, string code);

	//user waiting list
	list<CodeConfirmRecord> codeConfirmList;
	pthread_mutex_t getCodeMutex;
};

#endif /* CODEMANAGER_H_ */
