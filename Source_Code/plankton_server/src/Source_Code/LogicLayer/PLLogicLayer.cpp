/*
 * PLLogicLayer.cpp
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */

#include "PLLogicLayer.h"
#include "../Common/PLog.h"

string PLLogicLayer::excuteRequestWithLogicTypeAndVersion(string content,short type,short version){
	string resultString = "";
	LLLogicBase *logicExcutor = NULL;

	//根据请求生成不同的逻辑处理者
	switch(type){
		case CML_PACKAGE_PLANKTON_LOGIC_LAYER_USER_MANAGEMENT:{
			PLog::logHint("======当前使用用户管理逻辑器======");
			//logicExcutor = _userManagementLogicExcutor;
			break;
		}

		//例子战争
		case CML_PACKAGE_PLANKTON_LOGIC_LAYER_PARTICLE_BATTLE:{
			PLog::logHint("======当前使用粒子战争逻辑器======");
			//logicExcutor = _particleLogicExcutor;
			break;
		}

		//格斗
		case CML_PACKAGE_PLANKTON_LOGIC_LAYER_FIGHT_GAME:{
			break;
		}

		//Vote
		case CML_PACKAGE_VOTE:{
			PLog::logHint("======Current Use Vote Excutor======");
			logicExcutor = _voteLogicExcutor;
			break;
		}

		default:{
			PLog::logWarning("======请求找不到适合的逻辑器!======");
			return "";
		}
	}

	resultString = logicExcutor->excuteRequest(content,version,sessionID);

	return resultString;
}
