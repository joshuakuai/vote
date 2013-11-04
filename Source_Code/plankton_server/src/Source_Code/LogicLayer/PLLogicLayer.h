/*
 * PLLogicLayer.h
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */

#ifndef PLLOGICLAYER_H_
#define PLLOGICLAYER_H_
#include <string>
#include "LogicVote/LLLogicVote.h"

using namespace std;

class PLLogicLayer {
public:
	//构造函数
	PLLogicLayer(unsigned int sessionID) {
		this->sessionID = sessionID;
		_voteLogicExcutor = new LLLogicVote;
	}

	//析构
	virtual ~PLLogicLayer() {

		delete _voteLogicExcutor;
	}

	unsigned int sessionID; //使用此逻辑层对象的SessionID

	string excuteRequestWithLogicTypeAndVersion(string content, short type,
			short version);

protected:
	//Vote logic excutor
	LLLogicVote *_voteLogicExcutor;
};

#endif /* PLLOGICLAYER_H_ */
