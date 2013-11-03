/*
 * FightGame.h
 *
 *  Created on: 2013-7-4
 *      Author: Joshua
 */

#ifndef FIGHTGAME_H_
#define FIGHTGAME_H_

#include <time.h>
#include "FightGamePlayer.h"

/*
 * 类似于战斗房间，用于记录玩家当前的游戏状况
 */
class FightGame {
public:
	FightGame();
	virtual ~FightGame();

	int gameID;  //游戏ID

	FightGamePlayer *playerA;
	FightGamePlayer *playerB;

	//用于记录其中一个玩家掉线时间
	//如果两个玩家都掉线了，那么就双输
	struct tm * offlineTime;


};

#endif /* FIGHTGAME_H_ */
