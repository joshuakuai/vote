/*
 * RankSystem.h
 *
 *  Created on: 2013-7-4
 *      Author: Joshua
 */

#ifndef RANKSYSTEM_H_
#define RANKSYSTEM_H_

#include <list>
#include <pthread.h>
#include "../../Common/Observer.h"
#include "../../Common/PLog.h"
#include "FightGamePlayer.h"

/*
 * 匹配系统
 */
class RankSystem: public Observer {
public:
	//单例方法
	static RankSystem * Instance() {
		if (0 == _instance) {
			_instance = new RankSystem;
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

	list<FightGamePlayer*> rankList;  //匹配链表
	pthread_mutex_t listMutex;

	void addPlayer(FightGamePlayer* player);   //新玩家进入匹配列表
	void removePLayer(unsigned int userID);  //移除玩家

	void notify(string notificationName, void *arg);  //实现通知方法
protected:
	static RankSystem* _instance;

	RankSystem() {
		notificationNameList.push_back("SessionRelease");
		//初始化互斥锁
		if (pthread_mutex_init(&listMutex, NULL) != 0) {
			PLog::logFatal("匹配系统创建互斥锁失败!");
		}
		//开始匹配线程
		pthread_t matchThread = NULL;
		if (pthread_create(&matchThread, NULL, &beginMatch, NULL) != 0) {
			PLog::logFatal("创建匹配线程失败!");
		}
	}

	virtual ~RankSystem() {
		//清除所有用户
		for (std::list<FightGamePlayer*>::iterator it = rankList.begin();
				it != rankList.end();) {
			FightGamePlayer *cachePlayer = *it;
			delete cachePlayer;
			cachePlayer = NULL;
		}
		rankList.clear();
		//销毁互斥锁
		pthread_mutex_destroy(&listMutex);
	}

	static void *beginMatch(void *msg);  //匹配算法线程
};

#endif /* RANKSYSTEM_H_ */
