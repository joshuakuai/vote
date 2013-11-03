/*
 * PLog.cpp
 *
 *  Created on: Feb 3, 2013
 *      Author: joshuakuai
 */

#include <iostream>
#include "PLog.h"

using namespace std;

PlogLevel PLog::logLevel = Normal;

void PLog::setLogLevel(PlogLevel level){
	logLevel = level;
}

void PLog::logWithType(char *content,PlogType type){
	switch(logLevel){
		case None:{
			//do nothing
			break;
		}

		case Normal:{
			//only print fatal log
			if(type == Fatal){
				cout<<content<<endl;
			}
			break;
		}

		case Verbose:{
			//print any thing
			cout<<content<<endl;
			break;
		}

		default:
			break;
	}
}

void PLog::logWarning(string content){
	char *cacheContent = (char*)content.c_str();
	PLog::logWithType(cacheContent,Warning);
}

void PLog::logHint(string content){
	char *cacheContent = (char*)content.c_str();
	PLog::logWithType(cacheContent,Hint);
}

void PLog::logFatal(string content){
	char *cacheContent = (char*)content.c_str();
	PLog::logWithType(cacheContent,Fatal);
}
