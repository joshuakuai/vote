/*
 * CMLSessionPool.h
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */

#ifndef CMLSESSIONPOOL_H_
#define CMLSESSIONPOOL_H_
#include <vector>
#include "CMLSession.h"

using namespace std;

class CMLSessionPool {
public:
	CMLSessionPool();
	virtual ~CMLSessionPool();
	vector<CMLSession*> sessionVector;
	vector<int> freeSessionLocationVector;

	//新建Session,除了Session被判定为闲散状态，否则任何情况都不应该关闭Session
	void newSession(int client_fd);

private:
	vector<pthread_t> sessionThreadVector;
	pthread_t idomHeartSessionThread;
	pthread_mutex_t sessionResourseMutex;

	//Session垃圾回收员
	void sessionGarbageCollector();

	//削减Session活跃度（如果Session为维持状态）
	static void *idomHeartSession(void *msg);

	//会话子线程
	static void *startSessionThread(void *msg);
};

#endif /* CMLSESSIONPOOL_H_ */
