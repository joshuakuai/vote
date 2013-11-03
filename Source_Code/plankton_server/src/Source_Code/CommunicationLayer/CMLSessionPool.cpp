/*
 * CMLSessionPool.cpp
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */

#include <stdio.h>
#include "CMLSessionPool.h"
#include "../Common/PLog.h"

CMLSessionPool::CMLSessionPool() {
	idomHeartSessionThread = NULL;
	//初始化互斥锁
	if(pthread_mutex_init(&sessionResourseMutex,NULL) != 0){
		string log = string("======会话池创建互斥锁失败!======");
		PLog::logFatal(log);
	}
}

CMLSessionPool::~CMLSessionPool() {
	//我们不应该自己删除掉会话,所以不清除会话
	//删除互斥锁
	pthread_mutex_destroy(&sessionResourseMutex);
	//释放Vector资源
	sessionVector.clear();
	sessionThreadVector.clear();
	freeSessionLocationVector.clear();
	PLog::logHint("======会话池清理完毕======");
}

/*整个列表是随着链接数字的增长来增长的，被关闭的会话位置将会留下供新的会话使用
 * 理论上来讲,最大的会话数将会成为当前系统的承载极限.
 * 新建操作将会锁住会话池.
 * 由于pthread的特性所限，不能使用成员函数进行回调，将会影响到整体设计
 * 将会在这个函数新建会话线程并且交给线程自身来释放
 */
void CMLSessionPool::newSession(int client_fd){
	//检查空闲会话资源
	CMLSession *newSession = new CMLSession(client_fd);

	//session id 即在会话池中的位置
	pthread_t sessionThread = NULL;
	unsigned int sessionID;
	//锁住会话池子
	pthread_mutex_lock(&sessionResourseMutex);
	if(freeSessionLocationVector.empty()){
		PLog::logHint("======资源池可复用资源为零======");
		//如果没有空位置，直接压入列表末尾
		sessionVector.push_back(newSession);
		sessionThreadVector.push_back(sessionThread);
		sessionID = sessionVector.size()-1;
	}else{
		//获取最后一位空闲位置
		int cacheLocation = freeSessionLocationVector[freeSessionLocationVector.size()-1];
		freeSessionLocationVector.pop_back();
		sessionID = cacheLocation;
		sessionVector[cacheLocation] = newSession;
		sessionThreadVector[cacheLocation] = sessionThread;
	}
	//解锁
	pthread_mutex_unlock(&sessionResourseMutex);
	newSession->setID(sessionID);

	//初始化会话线程
	if(pthread_create(&sessionThread,NULL,&startSessionThread,newSession) != 0){
		char log[30];
		sprintf(log,"%d号会话======创建会话线程失败!======",sessionID);
		PLog::logWarning(string(log));
		//把这个空闲位置重新记住
		freeSessionLocationVector.push_back(sessionID);
	}

	//启动垃圾回收员
	this->sessionGarbageCollector();
}

//Session垃圾回收员
void CMLSessionPool::sessionGarbageCollector(){
	//回收资源时不能添加资源
	pthread_mutex_lock(&sessionResourseMutex);
	PLog::logHint("======开启资源回收员======");
	int collectResource = 0;
	for(unsigned int i =0 ;i< sessionVector.size();i++){
		CMLSession *cacheSession = sessionVector[i];
		if(cacheSession && cacheSession->isDead == true){
			//会话已死，启动回收机制
			//添加空闲资源
			freeSessionLocationVector.push_back(cacheSession->getID());
			//销毁会话对象
			sessionVector[cacheSession->getID()] = NULL;
			delete cacheSession;
			collectResource++;
		}
	}
	char log[30];
	sprintf(log,"======资源回收员回收了%d个资源======",collectResource);
	PLog::logHint(string(log));
	pthread_mutex_unlock(&sessionResourseMutex);
}

//会话线程,此方法为静态方法，不可控
void *CMLSessionPool::startSessionThread(void *msg){
	//分离此线程，保证线程结束后系统能回收线程资源
	pthread_detach(pthread_self());

	CMLSession *newSession = (CMLSession*)msg;

	//开始会话,阻塞方法
	newSession->startSession();

	PLog::logHint("======有一个会话结束了======");

	//线程结束，判定死亡
	newSession->setDead();

	return NULL;
}
