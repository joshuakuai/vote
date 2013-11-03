//Create by Joshua Kuai in 2013-01-30
//Email:385592871@qq.com
#include "CommunicationLayer/PLCommunicationLayer.h"
#include "LogicLayer/PLLogicLayer.h"
#include "Common/ConfigureManager.h"
#include "Common/NotificationCenter.h"

int main(){
	//实例化配置管理器
	ConfigureManager::Instance();

	//实例化通知中心
	NotificationCenter::Instance();

	//开启通讯层
	PLCommunicationLayer *communicationLayer = new PLCommunicationLayer();
	communicationLayer->start();

	//使用完毕后删除通讯层、逻辑层、通知中心、配置管理器
	delete communicationLayer;
	NotificationCenter::Release();
	ConfigureManager::Release();
	return 0;
}

