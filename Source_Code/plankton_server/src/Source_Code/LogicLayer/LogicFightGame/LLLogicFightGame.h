/*
 * LLLogicFightGame.h
 *
 *  Created on: 2013-4-14
 *      Author: Joshua
 */

#ifndef LLLOGICFIGHTGAME_H_
#define LLLOGICFIGHTGAME_H_

#include "../LLLogicBase.h"
#include "../../DataLayer/DLDatabase.h"
#include "../LogicUserManagement/LLLogicUserManagement.h"

class LLLogicFightGame: public LLLogicBase {
public:
	typedef enum _ParticleBattleRequestType{
		searchOpposite = 0
	}ParticleBattleRequestType;

	LLLogicFightGame(){
    	database = new DLDatabase;
    	database->initDB("localhost", "root", "199143a", "PlanktonServer");
    }

	virtual ~LLLogicFightGame(){
		delete database;
	}

	string excuteRequest(string requestString,short version,unsigned int sessionID);

private:
	//数据库
	DLDatabase *database;

	//登入匹配系统
	bool loginRankSystem(User *user,unsigned int battleRank,unsigned int battleLevel);

	//传递战斗信息
	bool transferBattleInfo(int actionID);

	//主动退出匹配系统
	bool logoutRankSystem(unsigned int userID);
};

#endif /* LLLOGICFIGHTGAME_H_ */
