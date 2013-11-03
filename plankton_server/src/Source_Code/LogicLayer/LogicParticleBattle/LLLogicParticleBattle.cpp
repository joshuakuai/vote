/*
 * LLLogicParticleBattle.cpp
 *
 *  Created on: 2013-3-29
 *      Author: Joshua
 */

#include "LLLogicParticleBattle.h"
#include "../../Lib/json.h"

string LLLogicParticleBattle::excuteRequest(string requestString,short version,unsigned int sessionID){
	//获得请求类型
	Json::Reader reader;
	Json::Value receivedValue;
	Json::Value sendValue;
	Json::FastWriter writer;

	if(reader.parse(requestString,receivedValue)){
		//根据请求版本进行执行
		int requestType = receivedValue["requestType"].asInt();

		switch(requestType){
			case UploadToken:{
				string tokenString = receivedValue["tokenString"].asString();

				sendValue["success"] = this->uploadToken(tokenString);

				return writer.write(sendValue);
				break;
			}

			default:{
				return "{\"msg\":\"Invalid request type\"}";
				break;
			}
		}
	}

	return "{\"msg\":\"Invalid jsonString\"}";
}

bool LLLogicParticleBattle::uploadToken(string tokenString)
{
	//对数据层中的Token进行插入操作
	//先查找是否有相同的token

	string queryString = "SELECT * FROM Token WHERE tokenString='" + tokenString +"'";

	vector<vector<string> > result = database->querySQL(queryString);
	if(result.size() == 0){
		queryString.clear();
		queryString = "INSERT INTO Token(tokenString) VALUES('" + tokenString + "')";
		return database->executeSQL(queryString);
	}
	return true;
}

