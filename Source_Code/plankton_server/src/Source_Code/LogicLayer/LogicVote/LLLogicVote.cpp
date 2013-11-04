/*
 * LLLogicVote.cpp
 *
 *  Created on: Nov 3, 2013
 *      Author: kuaijianghua
 */

#include "LLLogicVote.h"

string LLLogicVote::excuteRequest(string requestString,short version,unsigned int sessionID){
	//获得请求类型
	Json::Reader reader;
	Json::Value receivedValue;
	Json::Value sendValue;
	Json::FastWriter writer;

	if(reader.parse(requestString,receivedValue)){
		//根据请求版本进行执行

		//根据请求类型进行执行
		int requestType = receivedValue["requestType"].asInt();

		switch(requestType){
			case Register:{
				string firstName = receivedValue["firstName"].asString();
				string lastName = receivedValue["lastName"].asString();
				string email = receivedValue["email"].asString();

				sendValue["success"] = this->signUp(firstName,lastName,email);
				sendValue["msg"] = this->errorString;

				return writer.write(sendValue);
				break;
			}

			default:{
				return "{\"msg\":\"Invalid request type\",\"success\":false}";
				break;
			}
		}
	}

	return "{\"msg\":\"Invalid jsonString\",\"success\":false}";
}

//注册
bool LLLogicVote::signUp(string firstName,string lastName,string email)
{

}
