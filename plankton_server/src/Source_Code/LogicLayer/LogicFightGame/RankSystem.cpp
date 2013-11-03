/*
 * RankSystem.cpp
 *
 *  Created on: 2013-7-4
 *      Author: Joshua
 */

#include "RankSystem.h"
#include "FightGame.h"

RankSystem* RankSystem::_instance = NULL;

void RankSystem::addPlayer(FightGamePlayer* player)
{
	pthread_mutex_lock(&listMutex);
	if(rankList.empty()){
		rankList.push_back(player);
	}else{
		//队列系统中有其他玩家,根据战斗力进行排序
		for(std::list<FightGamePlayer*>::iterator it = rankList.begin();it != rankList.end();it++){
			FightGamePlayer *cachePlayer = *it;
			if(cachePlayer->battleRank <= player->battleRank){
				rankList.insert(it,player);
			}
		}
	}
	pthread_mutex_unlock(&listMutex);
}

void RankSystem::removePLayer(unsigned int userID)
{

}

//匹配算法，其中将会剔除掉离线的玩家
//从程序开始后将会一直执行至结束
void *RankSystem::beginMatch(void *msg)
{
	RankSystem *rankSystem = RankSystem::Instance();
	while(true){
		pthread_mutex_lock(&rankSystem->listMutex);
		FightGamePlayer *playerA = NULL;
		FightGamePlayer *playerB = NULL;
		for(std::list<FightGamePlayer*>::iterator it = rankSystem->rankList.begin();it != rankSystem->rankList.end();){
			FightGamePlayer *cachePlayer = *it;
			//如果该玩家处于离线模式，则剔除出排位系统
			if(cachePlayer->currentStatus == offline){
				rankSystem->removePLayer(cachePlayer->userID);
				continue;
			}else{
				if(playerA == NULL){
					playerA = cachePlayer;
					continue;
				}else{
					//赋值为PLAYERB
					playerB = cachePlayer;
					//向游戏房间管理器注册游戏

					//置空A，B
					playerA = NULL;
					playerB = NULL;
				}
			}
		}
		pthread_mutex_unlock(&rankSystem->listMutex);
		sleep(4);
	}
	return NULL;
}

void RankSystem::notify(string notificationName, void *arg)
{

}
