/*
 * Encrypt.h
 *
 *  Created on: 2013-6-13
 *      Author: Joshua
 */

#ifndef ENCRYPT_H_
#define ENCRYPT_H_

#include <string>
#include <string.h>
#include "ConfigureManager.h"

using namespace std;

//加密器
class Encrypt {
public:
	//指定KEY
	Encrypt(char *key){
		strcpy(this->key,key);
	};

	//从配置中读取KEY
	Encrypt(){
		strcpy(this->key,ConfigureManager::Instance()->encryptKey.c_str());
	}

	virtual ~Encrypt(){};

	//加密最高支持1024长度
	string encrypt(string encryptContent);
	string decrypt(string decryptContent);

private:
	char key[16+1];  //加密Key,不超过16个字节
	//加密核心函数
	int Do_DES(char* strSrc, char* strKey, char* strDest, char flag);
	//加密容器长度计算
	int caculateEncryptLength(string content);
	//对输入的字节串作BCD编码扩展
	int ByteToBCD(unsigned char* bytes, int count,unsigned char* strBCD);
	//把输入的BCD编码串还原成字节串
	int BCDToByte(unsigned char* strBCD, int count, unsigned char* bytes);
};

#endif /* ENCRYPT_H_ */

