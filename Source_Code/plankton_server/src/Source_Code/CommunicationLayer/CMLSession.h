/*
 * CMLSession.h
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */

#ifndef CMLSESSION_H_
#define CMLSESSION_H_

#include <netinet/in.h>
#include <pthread.h>
#include <string>
#include "../Common/NotificationCenter.h"
#include "../LogicLayer/PLLogicLayer.h"

#define SOCKET_BUFFER_SIZE 1024*10  //接收缓存最大值

using namespace std;

class CMLSession{
public:
	CMLSession(int socketInstance){
		id = -1;
		logicLayer = new PLLogicLayer(id);
		sessionSocket = socketInstance;
		isDead = false;
	}

	virtual ~CMLSession(){
		delete logicLayer;
		//发出Session销毁广播
		NotificationCenter::Instance()->postNotification("SessionRelease",(void*)this->id);
	};

	int sessionSocket;
	bool isDead;
	PLLogicLayer *logicLayer;
	//开启对话，对话将会在子线程运行
	void startSession();

	//标记为死亡，关闭socket等
	void setDead();

	//发送信息，同一时间只能发送一个信息
	void sendData(string content,short logicType,short logicVersion);

	//id setter and getter
	void setID(int id){
		this->id = id;
		logicLayer->sessionID = id;
	}

	unsigned int getID(){
		return this->id;
	}

private:
	pthread_mutex_t sendDatamutex;
	int id;
};

#endif /* CMLSESSION_H_ */
