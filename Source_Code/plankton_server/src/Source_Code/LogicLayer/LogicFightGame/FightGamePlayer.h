/*
 * FightGamePlayer.h
 *
 *  Created on: 2013-7-4
 *      Author: Joshua
 */

#ifndef FIGHTGAMEPLAYER_H_
#define FIGHTGAMEPLAYER_H_

#include "../LogicUserManagement/User.h"

typedef enum _PlayerStatus{
	online = 0,
	offline
}PlayerStatus;

/*
 * Player of this game
 */
class FightGamePlayer:public User{
public:
	FightGamePlayer(User *user,unsigned int battleRank,unsigned int battlePoint){
		this->sessionID = user->sessionID;
		this->userID = user->userID;
		this->userName = user->userName;

		this->battleRank = battleRank;
		this->battlePoint = battlePoint;
		this->currentLifePoint = 100;
		this->currentStatus = online;
	};

	virtual ~FightGamePlayer(){};

	//属性点数,只存需要传递或者使用的数据
	unsigned int battleRank;  //玩家对战等级
	unsigned int battlePoint; //玩家对战点数
	int currentLifePoint;     //玩家当前生命值

    //当前状态
    PlayerStatus currentStatus;
private:
};

#endif /* FIGHTGAMEPLAYER_H_ */
