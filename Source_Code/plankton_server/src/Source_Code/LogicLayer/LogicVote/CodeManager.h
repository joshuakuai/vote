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
	CodeConfirmRecord(){
		userData = NULL;
		code = "";
		createTime = -1;
	}
	User *userData;
	string code;
	time_t createTime;
};

using namespace std;

class CodeManager {
public:
	//单例方法
	static CodeManager * Instance() {
		if (0 == _instance) {
			_instance = new CodeManager;
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

	string getCode(User* userData);

	//*if it cannot match any email, this value does not change -1
	// if there is a match, but the code is wrong, the value turn to 0
	// if the code is right, the value turn to 1*
	int codeConfirm(string emailAdd, string code,User &userData);

	//call this method after success codefirm
	void earseUser(string emailAdd);

private:
	CodeManager(){
		//初始化互斥锁
		if(pthread_mutex_init(&getCodeMutex,NULL) != 0){
			string log = string("======Failed to create the CodeManager's thread mutex======");
			PLog::logFatal(log);
		}
	};
	virtual ~CodeManager(){
		//销毁互斥锁
		pthread_mutex_destroy(&getCodeMutex);
	};

	static CodeManager* _instance;

	//user waiting list
	list<CodeConfirmRecord*> codeConfirmList;

	pthread_mutex_t getCodeMutex;
};

#endif /* CODEMANAGER_H_ */
