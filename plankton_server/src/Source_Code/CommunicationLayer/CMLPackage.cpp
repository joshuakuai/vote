/*
 * CMLPackage.cpp
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */

#include "CMLPackage.h"
#include <string.h>

string CMLPackage::formPackage(string packageContent,short type,short version){
	//组成包头
	char sendDataBuffer[sizeof(CMLPackageHead)];
	bzero(sendDataBuffer, sizeof(CMLPackageHead));
	CMLPackageHead *sendDataHead = (CMLPackageHead*)&sendDataBuffer[0];
	sendDataHead->indication = CML_PACKAGE_INDICATION;

	//检查服务器是否开启了加密模式
	sendDataHead->isEncrypt = false;

	sendDataHead->logicLayerType = type;
	sendDataHead->logicLayerVersion = version;
	sendDataHead->packageLength = packageContent.length();

	string packageHeadString = "";
	packageHeadString = packageHeadString.append(sendDataBuffer,sizeof(CMLPackageHead));

	return packageHeadString.append(packageContent);
}

string CMLPackage::getPackageContent(string packageString){
	//直接返回包头以外的内容
	return packageString.substr(sizeof(CMLPackageHead));
}
