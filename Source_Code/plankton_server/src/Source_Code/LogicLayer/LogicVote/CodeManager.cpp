/*
 * CodeManager.cpp
 *
 *  Created on: Nov 3, 2013
 *      Author: shinezhao
 */

#include "CodeManager.h"
#include <cstdlib>

string CodeManager::getCode(User* userData) {
	//generate current time

	//only one user could get code at the same time
	pthread_mutex_lock(&getCodeMutex);

	//get current time
	time_t timeTmp = time(NULL);

	//delete any record if the time interval of which is more than 5 minutes
	list<CodeConfirmRecord>::iterator it = codeConfirmList.begin();

	for (; it != codeConfirmList.end(); ++it) {
		double timeSpan = difftime(timeTmp, (*it).createTime);
		if (timeSpan > 300) {
			codeConfirmList.erase(it);
			it--;
		}
	}

	//check if user has already send the code
	it = codeConfirmList.begin();

	for (; it != codeConfirmList.end(); ++it) {
		string recordEmail = (*it).userData->email;
		if (recordEmail.compare(userData->email) == 0) {
			//now we should refresh the code's create time and resend
			(*it).createTime = timeTmp;
			return (*it).code;
		}
	}

	//no record, we create new record
	CodeConfirmRecord newRecord;
	newRecord.createTime = timeTmp;
	newRecord.userData = userData;

	//create new code
	short ranNum;

	srand((unsigned) timeTmp);
	for (short i = 0; i < 4; i++) {
		ranNum = rand() % 10;
		newRecord.code.push_back((char) ranNum);
	}

	//push to list
	codeConfirmList.push_back(newRecord);

	//return the code
	return newRecord.code;

	pthread_mutex_unlock(&getCodeMutex);
}

int CodeManager::codeConfirm(string emailAdd, string code) {
	list<CodeConfirmRecord>::iterator it = codeConfirmList.begin();

	for (; it != codeConfirmList.end(); it++) {
		string recordEmail = (*it).userData->email;
		string recordCode = (*it).code;

		if (recordEmail.compare(emailAdd) == 0) {
			if (recordCode.compare(code) == 0) {
				return 1;
			} else {
				return 0;
			}
		}
	}

	return -1;
}
