/*
 * CodeManager.h
 *
 *  Created on: Nov 3, 2013
 *      Author: shinezhao
 */

#ifndef CODEMANAGER_H_
#define CODEMANAGER_H_

#include<list>
#include<string>

using namespace std;

class CodeManager {
public:
	CodeManager();
	virtual ~CodeManager();
	typedef list<string> ListString;
	typedef list<list<string>> ListList;
	string getCode(string emailAdd);
	int idConfirm(string emailAdd, string code);

	//user waiting list
	ListList userWl;
};

#endif /* CODEMANAGER_H_ */
