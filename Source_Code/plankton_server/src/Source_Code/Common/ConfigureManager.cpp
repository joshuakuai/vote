/*
 * ConfigureManager.cpp
 *
 *  Created on: 2013-6-26
 *      Author: Joshua
 */

#include "ConfigureManager.h"

ConfigureManager* ConfigureManager::_instance = NULL;

//重置设置
void ConfigureManager::reset(){
	encrypt = false;
	encryptKey = "";
	plogLevel = Normal;
	maxUserNumber = 100;
	serverPort = 13145;
	PLog::setLogLevel(plogLevel);
}

//保存至文件
void ConfigureManager::save(){
	ofstream configureFile("config");
	if(!configureFile.is_open()){
		PLog::logWarning("保存配置文件失败!");
	}else{
		Json::Value value;
		value["Encrypt"] = this->encrypt;
		value["EncryptKey"] = this->encryptKey;
		value["PLogLevel"] = this->plogLevel;
		value["ServerPort"] = this->serverPort;
		value["MaxUserNumber"] = this->maxUserNumber;
		configureFile<<value.toStyledString();
		configureFile.close();
	}
}
