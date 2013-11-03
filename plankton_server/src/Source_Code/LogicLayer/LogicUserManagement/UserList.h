/*
 * UserList.h
 *
 *  Created on: 2013-7-2
 *      Author: Joshua
 */

#ifndef USERLIST_H_
#define USERLIST_H_

#include <vector>
#include <pthread.h>
#include "../../Common/Observer.h"
#include "../../Common/PLog.h"
#include "User.h"

using namespace std;

class UserList:public Observer{
public:
	//单例方法
	static UserList * Instance() {
		if (0 == _instance) {
			_instance = new UserList;
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

	bool userLogin(User *user);               //用户登录
	void userLogout(unsigned int sessionID); //用户登出

	void notify(string notificationName,void *arg);  //实现通知方法
protected:
	static UserList* _instance;

	vector<User*> userList;
	vector<int> freeUserLocationList;
	pthread_mutex_t listMutex;

	UserList(){
		notificationNameList.push_back("SessionRelease");
		//初始化互斥锁
		if(pthread_mutex_init(&listMutex,NULL) != 0){
			PLog::logFatal("用户列表创建互斥锁失败!");
		}
	}

	virtual ~UserList(){
		//清除所有用户
		for(unsigned int i = 0;i<userList.size();i++){
			delete userList[i];
			userList[i] = NULL;
		}
		userList.clear();
		//销毁互斥锁
		pthread_mutex_destroy(&listMutex);
	}
};

#endif /* USERLIST_H_ */
