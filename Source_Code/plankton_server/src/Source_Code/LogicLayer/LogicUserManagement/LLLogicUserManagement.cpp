/*
 * LLLogicDefault.cpp
 *
 *  Created on: Feb 7, 2013
 *      Author: joshuakuai
 */

#include "LLLogicUserManagement.h"
#include "../../Common/PLog.h"
#include "../../Common/md5.h"
#include "../../Lib/json.h"
#include "UserList.h"

string LLLogicUserManagement::excuteRequest(string requestString,short version,unsigned int sessionID){
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
				string tokenString = receivedValue["tokenString"].asString();
				string name = receivedValue["name"].asString();
				string password = receivedValue["password"].asString();
				string appName = receivedValue["appName"].asString();

				sendValue["success"] = this->registerUser(name,password,tokenString,appName);
				sendValue["msg"] = this->errorString;

				return writer.write(sendValue);
				break;
			}

			case Login:{
				string tokenString = receivedValue["tokenString"].asString();
				string name = receivedValue["name"].asString();
				string password = receivedValue["password"].asString();
				string appName = receivedValue["appName"].asString();

				sendValue["success"] = this->login(name,password,tokenString,appName,sessionID);
				sendValue["msg"] = this->errorString;

				return writer.write(sendValue);
				break;
			}

			default:{
				return "{\"msg\":\"Invalid request type\",\"success\":0}";
				break;
			}
		}
	}

	return "{\"msg\":\"Invalid jsonString\",\"success\":0}";
}

bool LLLogicUserManagement::registerUser(string name,string password,string tokenString,string appName)
{
	//TODO:检查帐号密码格式

	//查找是否有重复
	string queryString = "SELECT * FROM User WHERE user_name='" + name + "'";

	vector<vector<string> > result = database->querySQL(queryString);
	if(result.size() == 0){
		queryString.clear();
		//密码MD5加密
		MD5 md5(password);
		password = md5.md5();

		//插入用户信息
		queryString = "INSERT INTO User(user_name,user_password) VALUES('" + name + "','" + password + "')";
		if(database->executeSQL(queryString)){
			//插入用户成功，查询用户ID
			queryString.clear();
			queryString = "SELECT user_id FROM User WHERE name='" + name + "'";
			result = database->querySQL(queryString);
			string userID = result[0][0];

			if(!tokenString.empty()){
				//查询用户ID成功，插入Token
				queryString.clear();
				queryString = "INSERT INTO Token(token_string,app_name,user_id) VALUES('" + tokenString + "','" + appName + "','" + userID + "')";
				this->errorString = "";
				return database->executeSQL(queryString);
			}
		}else{
			PLog::logWarning(name + "注册用户失败：插入用户信息失败");
			this->errorString = "用户信息格式错误";
			return false;
		}
	}else{
		PLog::logWarning(name + "注册用户失败:有重复名字用户");
		this->errorString = "用户名重复";
		return false;
	}

	return true;
}

bool LLLogicUserManagement::login(string name,string password,string tokenString,string appName,unsigned int sessionID)
{
	MD5 md5(password);
	string queryString = "SELECT user_id FROM User WHERE user_name='" + name + "' AND user_password='" + md5.md5() + "'";
	vector<vector<string> > result = database->querySQL(queryString);

	if(result.size() != 0){
		//登录验证成功,向用户列表注册
		User *loginUser = new User();
		loginUser->userName = name;
		loginUser->sessionID = sessionID;
		loginUser->userID = atoi(result[0][0].c_str());
		UserList::Instance()->userLogin(loginUser);
		this->errorString = "";
		return true;
	}

	this->errorString = "帐号密码验证错误";
	return false;
}
