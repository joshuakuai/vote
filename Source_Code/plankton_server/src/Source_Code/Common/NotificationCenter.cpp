/*
 * NotificationCenter.cpp
 *
 *  Created on: 2013-3-17
 *      Author: Joshua
 */

#include "NotificationCenter.h"

NotificationCenter* NotificationCenter::_instance = NULL;

void NotificationCenter::addObserver(Observer *newObserver) {
	pthread_mutex_lock(&vectormutex);
	//查找是否已经存在
	for(unsigned int i= 0;i<observerVector.size();i++)
	{
		if(observerVector[i] == newObserver){
			return;
		}
	}
	observerVector.push_back(newObserver);
	pthread_mutex_unlock(&vectormutex);
}

void NotificationCenter::removeObserver(Observer *observer) {
	pthread_mutex_lock(&vectormutex);
	vector<Observer*>::iterator itr = observerVector.begin();
	for(unsigned int i= 0;i<observerVector.size();i++,itr++)
	{
		if(observerVector[i] == observer){
			observerVector.erase(itr);
		}
	}
	pthread_mutex_unlock(&vectormutex);
}

void NotificationCenter::postNotification(string notificationName,void *arg) {
	pthread_mutex_lock(&vectormutex);

	for(unsigned int i= 0;i<observerVector.size();i++)
	{
		for(unsigned int j = 0;j<observerVector[i]->notificationNameList.size();j++){
			if(observerVector[i]->notificationNameList[j] == notificationName){
				//观察者观察的某个类型和通知相同，则通知观察者
				observerVector[i]->notify(notificationName,arg);
			}
		}
	}

	pthread_mutex_unlock(&vectormutex);
}
