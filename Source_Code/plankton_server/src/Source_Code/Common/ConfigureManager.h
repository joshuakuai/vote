/*
 * ConfigureManager.h
 *
 *  Created on: 2013-6-26
 *      Author: Joshua
 */

#ifndef CONFIGUREMANAGER_H_
#define CONFIGUREMANAGER_H_

#include <stdlib.h>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <string>
#include "../Lib/json.h"
#include "PLog.h"

using namespace std;

class ConfigureManager {
public:
	//单例方法
	static ConfigureManager * Instance() {
		if (0 == _instance) {
			_instance = new ConfigureManager;
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

	bool encrypt;        //是否启用加密
	string encryptKey;   //加密秘匙
	PlogLevel plogLevel; //服务器模式
	int maxUserNumber;   //同时链接玩家数量最大值
	int serverPort;      //服务器端口号

	void reset();  //重置设置
	void save();   //保存文件

protected:
	static ConfigureManager* _instance;

	ConfigureManager(){
		//从文件读取JSON数据串
		Json::Reader reader;
		Json::Value value;

		ifstream configureFile("config");
		if (!configureFile.is_open()) {
			//配置文件打开失败，使用默认配置
			PLog::logWarning("配置文件打开失败，使用默认配置");
			this->reset();
			this->save();
		} else {
			configureFile.seekg(0, configureFile.end);
			int length = configureFile.tellg();
			configureFile.seekg(0, configureFile.beg);
			char * buffer = new char[length];
			//read data as a block
			configureFile.read(buffer, length);
			configureFile.close();
			string fileString = string(buffer);
			delete []buffer;

			//打开成功，文件内容为空，则还是使用默认配置
			if (fileString.length() == 0) {
				PLog::logWarning("配置文件打开失败，使用默认配置");
				this->reset();
				this->save();
			} else {
				//根据文本进行设置
				reader.parse(fileString, value);
				serverPort = value["ServerPort"].asInt();
				encrypt = value["Encrypt"].asBool();
				encryptKey = value["EncryptKey"].asString();
				plogLevel = (PlogLevel) value["PLogLevel"].asInt();
				maxUserNumber = value["MaxUserNumber"].asInt();
				PLog::setLogLevel(plogLevel);
			}
		}
	}

	virtual ~ConfigureManager(){
		this->save();
	}
};

#endif /* CONFIGUREMANAGER_H_ */
