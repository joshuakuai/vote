/*
 * PLCommunicationLayer.cpp
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */

#include "PLCommunicationLayer.h"
#include "../Common/ConfigureManager.h"
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#define BACKLOG 30        /* 最大同时连接请求数 */

PLCommunicationLayer::PLCommunicationLayer() {
	//初始化会话池
	sessionPool = new CMLSessionPool();
}

PLCommunicationLayer::~PLCommunicationLayer() {
	//释放会话池
	delete sessionPool;
	//释放监听
	this->stop();
	PLog::logHint(string("======服务器关闭！======"));
}

//Start the communication layer
void PLCommunicationLayer::start(){
	//开启SOCKET监听,阻塞模式
    int sock_fd,client_fd;             /*sock_fd：监听socket；client_fd：数据传输socket */
    struct sockaddr_in my_addr;        /* 本机地址信息 */
    struct sockaddr_in remote_addr;    /* 客户端地址信息 */
    sock_fd = socket(AF_INET, SOCK_STREAM, 0);
    if(sock_fd == -1) {
        PLog::logFatal(string("======Socket创建出错！======"));
        return;
    }else{
    	PLog::logHint(string("======Socket创建成功！======"));
    }
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(ConfigureManager::Instance()->serverPort);
    my_addr.sin_addr.s_addr = INADDR_ANY;
    bzero(&(my_addr.sin_zero),8);
    if(bind(sock_fd, (struct sockaddr *)&my_addr, sizeof(struct sockaddr)) == -1) {
    	PLog::logFatal(string("======Bind Socket出错！======"));
        return;
    }else{
    	PLog::logHint(string("======Bind Socket成功！======"));
    }

    if(listen(sock_fd, BACKLOG) == -1) {
    	PLog::logFatal(string("======Listen Socket出错！======"));
        return;
    }else{
    	PLog::logHint(string("======Listen Socket成功！======"));
    }

    PLog::logHint(string("======服务器成功启动！======"));
    //监听成功，开始接受数据
    unsigned int sin_size;
    while(true) {
        sin_size = sizeof(struct sockaddr_in);
        if((client_fd = accept(sock_fd, (struct sockaddr *)&remote_addr, &sin_size)) == -1) {
        	PLog::logWarning(string("Accept出错!"));
            continue;
        }else{
        	string hintString = "从";
        	hintString.append(inet_ntoa(remote_addr.sin_addr));
        	hintString.append("收到了一个链接请求..");
        	PLog::logHint(hintString);
        }

        //从会话池中开启一个会话
        PLog::logHint(string("======新建会话======"));
        sessionPool->newSession(client_fd);
        PLog::logHint(string("======新建会话结束======"));
    }
}

//Stop the communication layer,this method may not be called from outside for most cases
void PLCommunicationLayer::stop(){
	//关闭监听
}

//Send package to the session which contains in the vector
void PLCommunicationLayer::broadcast(vector<char*> sessionVector){
	//TODO：实现广播发包
}

