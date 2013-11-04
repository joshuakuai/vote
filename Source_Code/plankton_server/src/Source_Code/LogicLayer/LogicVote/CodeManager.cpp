/*
 * CodeManager.cpp
 *
 *  Created on: Nov 3, 2013
 *      Author: shinezhao
 */

#include "CodeManager.h"
#include<ctime>


CodeManager::CodeManager() {
	// TODO Auto-generated constructor stub

}

CodeManager::~CodeManager() {
	// TODO Auto-generated destructor stub
}

string CodeManager::getCode(string emailAdd){
	//verification information, contains Email, Code, Created time
	ListString veriInfo;
	string code;
	char timetmp[9];
	string time;
	short ranNum;

	time_t t = time(0);

	//set srand
	srand((unsigned)t);
	for(short i=0; i<4; i++){
		ranNum = rand()%10;
		code.push_back((char)ranNum);
	}

	//get time store in timetmp
	strftime(timetmp, sizeof(timetmp), "%y%j%H%M", localtime(&t));
	time = timetmp;

	//list to store a group infomation
	veriInfo.push_back(emailAdd);
	veriInfo.push_back(code);
	veriInfo.push_back(time);
	
	//veriInfo list -> userWl list
	userWl.push_back(veriInfo);

}

int CodeManager::idConfirm(string emailAdd, string code){
	ListList::iterator userIndex;
	ListString::iterator infoIndex;

	//*if it cannot match any email, this value does not change -1
	// if there is a match, but the code is wrong, the value turn to 0
	// if the code is right, the value turn to 1*
	short userMark = -1;

	for(userIndex = userWl.begin(); userIndex!= userWl.end(); userIndex++){
		infoIndex = (*userIndex).begin();
		if(!(emailAdd.compare(*infoIndex)){
			userMark ++;
			infoIndex ++;
			if(!(code.compare(*infoIndex))){
				userMark ++;
			}
			break;
		}
	}
	return userMark;
}
