/*
 * LLLogicBase.h
 *
 *  Created on: Feb 7, 2013
 *      Author: joshuakuai
 */

#ifndef LLLOGICBASE_H_
#define LLLOGICBASE_H_
#include <string>

//Logic layer type
#define CML_PACKAGE_PLANKTON_LOGIC_LAYER_USER_MANAGEMENT 0x01
#define CML_PACKAGE_PLANKTON_LOGIC_LAYER_PARTICLE_BATTLE 0x02
#define CML_PACKAGE_PLANKTON_LOGIC_LAYER_FIGHT_GAME 0x03

using namespace std;

class LLLogicBase {
public:
	string errorString;

	virtual ~LLLogicBase(){
		errorString = "";
	};
	virtual string excuteRequest(string requestString,short version,unsigned int sessionID) = 0;
};

#endif /* LLLOGICBASE_H_ */
