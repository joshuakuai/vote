/*
 * CMLSession.cpp
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */

#include <unistd.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <iostream>
#include <sys/wait.h>
#include <string.h>
#include <stdio.h>
#include "CMLSession.h"
#include "../Common/PLog.h"
#include "CMLPackage.h"
#include "../Common/Encrypt.h"

using namespace std;

void CMLSession::setDead(){
	char log[30];
	sprintf(log,"%d号会话======销毁会话======",id);
	PLog::logHint(string(log));
	//关闭socket
	close(sessionSocket);
	//销毁互斥锁
	pthread_mutex_destroy(&sendDatamutex);
	isDead = true;
	//发送会话销毁通知
	NotificationCenter *center = NotificationCenter::Instance();
	center->postNotification(string("NotificationSessionDidDead"),(void*)id);
}

//开启对话，对话将会在子线程运行,请确保会话ID以及SOCKET实例已传递
void CMLSession::startSession(){
	char log[30];
	sprintf(log,"%d号会话======会话开启======",id);
	PLog::logHint(string(log));

	//初始化互斥锁
	if(pthread_mutex_init(&sendDatamutex,NULL) != 0){
		sprintf(log,"%d号会话======创建互斥锁失败!======",id);
		PLog::logWarning(string(log));
	}

	string packageString = "";

	struct timeval receivedTimeout = {30,0};
	struct timeval sendTimeout = {10,0};

	//发送时限
	setsockopt(sessionSocket,SOL_SOCKET,SO_SNDTIMEO,(char *)&sendTimeout,sizeof(struct timeval));
	//接收时限
	setsockopt(sessionSocket,SOL_SOCKET,SO_RCVTIMEO,(char *)&receivedTimeout,sizeof(struct timeval));

	while(true){
		//开始接受请求
		char buffer[SOCKET_BUFFER_SIZE];
		bzero(buffer, SOCKET_BUFFER_SIZE);
		sprintf(log,"%d号会话======开始接受请求======",id);
		PLog::logHint(string(log));
		int receiveLength = recv(sessionSocket,buffer,SOCKET_BUFFER_SIZE,0);
		if(receiveLength < 0){
			sprintf(log,"%d号会话======接受请求失败!======",id);
			PLog::logWarning(string(log));
			break;
		}else if(receiveLength == 0){
			sprintf(log,"%d号会话======接受的请求为空！======",id);
			PLog::logWarning(string(log));
			break;
		}else{
			sprintf(log,"%d号会话======接受的请求长度为%d！======",id,receiveLength);
			PLog::logWarning(string(log));
		}

		//验证包头,这里有三种情况
		//第一是包还未接受完毕，但是包头验证成功，这种情况将会继续接受。
		//第二是包发送完毕并且包的长度正确，这种将会进行抽离包内容并且交由逻辑层处理
		//第三是包发送超过包头所定的长度，将会直接忽视掉后面那一条的信息
		buffer[receiveLength] = '\0';
		packageString = packageString.append(buffer,receiveLength);
		CMLPackageHead *head = (CMLPackageHead*)&packageString[0];

		if(head->indication != CML_PACKAGE_INDICATION ||
		   head->packageLength > packageString.length()-sizeof(CMLPackageHead)){
			sprintf(log,"%d号会话======包当前不是有效的!======",id);
			PLog::logWarning(string(log));

			if(head->indication != CML_PACKAGE_INDICATION){
				sprintf(log,"%d号会话======包头标识校验失败!======",id);
				PLog::logWarning(string(log));
				break;
			}
			//检查包长度是否合法
			if(head->packageLength+sizeof(CMLPackageHead) > 1024*10){
				sprintf(log,"%d号会话======包长度超过规定最大值!======",id);
				PLog::logWarning(string(log));
				break;
			}

			//标识正确，长度合法，继续接收。
			continue;
		}else{
			sprintf(log,"%d号会话======包验证成功,开始进行逻辑分析======",id);
			PLog::logHint(string(log));
			//抽离包内容
			string packageContentString = CMLPackage::getPackageContent(packageString);

			//检查是否加密过
			if(head->isEncrypt){
				//解密包内容
				Encrypt *encrypt = new Encrypt();
				packageContentString = encrypt->decrypt(packageContentString);
			}

			//执行逻辑请求
			string logicLayerResultString = logicLayer->excuteRequestWithLogicTypeAndVersion(packageContentString,head->logicLayerType,head->logicLayerVersion);

			//发送执行结果
			this->sendData(logicLayerResultString,head->logicLayerType,head->logicLayerVersion);

			//清理包缓存
			packageString.clear();
		}
	}
}

void CMLSession::sendData(string content,short logicType,short logicVersion){
	pthread_mutex_lock(&sendDatamutex);

	//组成包
	string sendString = CMLPackage::formPackage(content,logicType,logicVersion);

	char log[30];
	sprintf(log,"%d号会话开始发送包,包长度为%d",id,(int)content.length());
	PLog::logHint(string(log));
	int sendLength =  send(sessionSocket,content.c_str(),content.length(),0);

	if(sendLength < 0){
		sprintf(log,"%d号会话======发送包失败!======",id);
		PLog::logWarning(string(log));
	}else{
		sprintf(log,"%d号会话======发送包成功，长度为%d======",id,sendLength);
		PLog::logHint(string(log));
	}

	pthread_mutex_unlock(&sendDatamutex);
}
