/*
 * PLLogicLayer.h
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */

#ifndef PLLOGICLAYER_H_
#define PLLOGICLAYER_H_
#include <string>
#include "LogicUserManagement/LLLogicUserManagement.h"
#include "LogicParticleBattle/LLLogicParticleBattle.h"
#include "LogicVote/LLLogicVote.h"

using namespace std;

class PLLogicLayer {
public:
	//构造函数
	PLLogicLayer(unsigned int sessionID) {
		this->sessionID = sessionID;
		_userManagementLogicExcutor = new LLLogicUserManagement;
		_particleLogicExcutor = new LLLogicParticleBattle;
		_voteLogicExcutor = new LLLogicVote;
	}

	//析构
	virtual ~PLLogicLayer() {
		delete _userManagementLogicExcutor;
		delete _particleLogicExcutor;
		delete _voteLogicExcutor;
	}

	unsigned int sessionID; //使用此逻辑层对象的SessionID

	string excuteRequestWithLogicTypeAndVersion(string content, short type,
			short version);

protected:
	//用户管理逻辑器
	LLLogicUserManagement *_userManagementLogicExcutor;

	//粒子战争逻辑器
	LLLogicParticleBattle *_particleLogicExcutor;

	//Vote logic excutor
	LLLogicVote *_voteLogicExcutor;
};

#endif /* PLLOGICLAYER_H_ */
