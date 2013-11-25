//Create by Joshua Kuai in 2013-01-30
//Email:385592871@qq.com
#include "CommunicationLayer/PLCommunicationLayer.h"
#include "LogicLayer/PLLogicLayer.h"
#include "Common/ConfigureManager.h"
#include "Common/NotificationCenter.h"
#include "Common/MailManager.h"
#include "Common/Pusher.h"
#include "DataLayer/PLDataLayer.h"

int main(){
	//实例化配置管理器
	ConfigureManager::Instance();

	//实例化通知中心
	NotificationCenter::Instance();

	//Initial Database
	PLDataLayer::Instance()->setDatabaseInfoFromConfigureManager();
	PLDataLayer::Instance()->addDatabaseWithName("Vote");

	//Initial Email Manager
	MailManager::Instance()->setMailInfoFromConfigureManager();

	//Initial Pusher and begin auto push
	Pusher::Instance()->beginAutoPush();

	//开启通讯层
	PLCommunicationLayer *communicationLayer = new PLCommunicationLayer();
	communicationLayer->start();

	//使用完毕后删除通讯层、逻辑层、通知中心、配置管理器
	delete communicationLayer;
	NotificationCenter::Release();
	ConfigureManager::Release();
	PLDataLayer::Release();
	Pusher::Release();
	return 0;
}

