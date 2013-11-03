/*
 * NotificationCenter.h
 *
 *  Created on: 2013-3-17
 *      Author: Joshua
 */

#ifndef NOTIFICATIONCENTER_H_
#define NOTIFICATIONCENTER_H_
#include <vector>
#include "PLog.h"
#include <stdio.h>
#include "Observer.h"
#include <pthread.h>

class NotificationCenter {
public:
	//单例方法
	static NotificationCenter * Instance() {
		if (0 == _instance) {
			_instance = new NotificationCenter;
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

	//添加观察者
	void addObserver(Observer *newObserver);

	//删除观察者
	void removeObserver(Observer *observer);

	//发送通知
	void postNotification(string notificationName, void *arg);

protected:
	static NotificationCenter* _instance;

	pthread_mutex_t vectormutex;

	vector<Observer*> observerVector;

	NotificationCenter() {
		//初始化互斥锁
		if (pthread_mutex_init(&vectormutex, NULL) != 0) {
			PLog::logWarning(string("======通知中心创建互斥锁失败!======"));
		}
	}
	virtual ~NotificationCenter() {
		observerVector.clear();
		//销毁互斥锁
		pthread_mutex_destroy(&vectormutex);
	}
};

#endif /* NOTIFICATIONCENTER_H_ */
