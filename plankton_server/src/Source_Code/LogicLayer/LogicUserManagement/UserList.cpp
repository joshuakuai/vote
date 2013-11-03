/*
 * UserList.cpp
 *
 *  Created on: 2013-7-2
 *      Author: Joshua
 */

#include "UserList.h"

UserList* UserList::_instance = NULL;

bool UserList::userLogin(User *user)
{
	pthread_mutex_lock(&listMutex);
	//查找是否登录过
	for(unsigned int i = 0;i<userList.size();i++){
		User *cacheUser = userList[i];
		if(user->userID == cacheUser->userID){
			pthread_mutex_unlock(&listMutex);
			return false;
		}
	}

	//检查是否有空闲位置
	if(this->freeUserLocationList.size() != 0){
		int freeLocation = freeUserLocationList[freeUserLocationList.size()-1];
		userList[freeLocation] = user;
		freeUserLocationList.pop_back();
	}else{
		userList.push_back(user);
	}

	pthread_mutex_unlock(&listMutex);

	return true;
}

void UserList::userLogout(unsigned int sessionID)
{
	pthread_mutex_lock(&listMutex);
	//检查是否上线
	for(unsigned int i = 0;i<userList.size();i++){
		User *cacheUser = userList[i];
		if(cacheUser->sessionID == sessionID){
			//下线，释放用户
			delete cacheUser;
			userList[i] = NULL;
			freeUserLocationList.push_back(i);
			break;
		}
	}
	pthread_mutex_unlock(&listMutex);
}

void UserList::notify(string notificationName, void *arg)
{
	if(notificationName == "SessionRelease"){
		//有一个Session被释放了，查看是否登录,如果有登录则释放
		this->userLogout((long)arg);
	}
}
