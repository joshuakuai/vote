/*
 * CodeManager.cpp
 *
 *  Created on: Nov 3, 2013
 *      Author: shinezhao
 */

#include "CodeManager.h"
#include <ctime>
#include <cstdlib>

string CodeManager::getCode(User* userData){
	//generate current time
	char timetmp[9];
	time_t t = time(0);

	strftime(timetmp, sizeof(timetmp), "%y%j%H%M", localtime(&t));

	//check if user has already send the code
	list<CodeConfirmRecord>::iterator it = codeConfirmList.begin();

	for(;it != codeConfirmList.end();++it){
		string recordEmail = (*it).userData->email;
		if(recordEmail.compare(userData->email) != 0){
			//now we should refresh the code's create time and resend
			(*it).createTime = timetmp;
			return (*it).code;
		}
	}

	//no record, we create new record
	CodeConfirmRecord newRecord;
	newRecord.createTime = timetmp;
	newRecord.userData = userData;

	//create new code
	short ranNum;

	srand((unsigned)t);
	for(short i=0; i<4; i++){
		ranNum = rand()%10;
		newRecord.code.push_back((char)ranNum);
	}
	
	//push to list
	codeConfirmList.push_back(newRecord);

	//return the code
	return newRecord.code;
}

int CodeManager::codeConfirm(string emailAdd, string code){
	list<CodeConfirmRecord>::iterator it = codeConfirmList.begin();

	for(; it != codeConfirmList.end(); it++){
		string recordEmail = (*it).userData->email;
		string recordCode = (*it).code;

		if(recordEmail.compare(emailAdd) == 0){
			if(recordCode.compare(code) == 0){
				return 1;
			}else{
				return 0;
			}
		}
	}

	return -1;
}
