/*
 * LLLogicParticleBattle.h
 *
 *  Created on: 2013-3-29
 *      Author: Joshua
 */

#ifndef LLLOGICPARTICLEBATTLE_H_
#define LLLOGICPARTICLEBATTLE_H_

#include "../LLLogicBase.h"
#include "../../DataLayer/DLDatabase.h"

using namespace std;

class LLLogicParticleBattle: public LLLogicBase {
public:
	typedef enum _ParticleBattleRequestType{
		UploadToken = 0
	}ParticleBattleRequestType;

	LLLogicParticleBattle(){
    	database = new DLDatabase;
    	database->initDB("localhost", "root", "199143a", "ParticleBattle");
    }

	virtual ~LLLogicParticleBattle(){
		delete database;
	}

	string excuteRequest(string requestString,short version,unsigned int sessionID);

private:
	//数据库
	DLDatabase *database;

	//上传Token
	bool uploadToken(string tokenString);
};

#endif /* LLLOGICPARTICLEBATTLE_H_ */
