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

	//check if user has already send the code
	list<CodeConfirmRecord>::iterator it = codeConfirmList.begin();

	for (; it != codeConfirmList.end();++it) {
		string recordEmail = (*it).userData->email;
		if (recordEmail.compare(userData->email) == 0) {
			//now we should refresh the code's create time and resend
			(*it).createTime = timeTmp;
			return (*it).code;
		}
	}

	//delete any record if the time interval of which is more than 5 minutes
	it = codeConfirmList.begin();
	for (; it != codeConfirmList.end();) {
		double timeSpan = difftime(timeTmp, (*it).createTime);
		if (timeSpan > 300) {
			it = codeConfirmList.erase(it);
		}else{
			it++;
		}
	}

	//no record, we create new record
	CodeConfirmRecord newRecord;
	newRecord.createTime = timeTmp;
	//TODO:we should deep copy this data
	newRecord.userData = userData;

	//create new code
	short ranNum;

	srand((unsigned) timeTmp);
	for (short i = 0; i < 4; i++) {
		ranNum = rand() % 10;
		ranNum += 48;
		newRecord.code.push_back((char) ranNum);
	}

	//push to list
	codeConfirmList.push_back(newRecord);

	pthread_mutex_unlock(&getCodeMutex);

	//return the code
	return newRecord.code;
}

int CodeManager::codeConfirm(string emailAdd, string code,User &userData) {
	list<CodeConfirmRecord>::iterator it = codeConfirmList.begin();

	for (; it != codeConfirmList.end(); it++) {
		string recordEmail = (*it).userData->email;
		string recordCode = (*it).code;

		if (recordEmail.compare(emailAdd) == 0) {
			if (recordCode.compare(code) == 0) {

				//get current time,compare if this code is expire
				time_t timeTmp = time(NULL);
				double timeSpan = difftime(timeTmp, (*it).createTime);
				if (timeSpan > 300) {
					break;
				}
				userData.email = (*it).userData->email;
				userData.lastName = (*it).userData->lastName;
				userData.firstName = (*it).userData->firstName;
				return 1;
			} else {
				return 0;
			}
		}
	}

	return -1;
}

void CodeManager::earseUser(string emailAdd)
{
	pthread_mutex_lock(&getCodeMutex);

	//check if user has already send the code
	list<CodeConfirmRecord>::iterator it = codeConfirmList.begin();

	for (; it != codeConfirmList.end();++it) {
		string recordEmail = (*it).userData->email;
		if (recordEmail.compare(emailAdd) == 0) {
			codeConfirmList.erase(it);
			break;
		}
	}

	pthread_mutex_unlock(&getCodeMutex);
}
