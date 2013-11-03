/*
 * DLDatabase.h
 *
 *  Created on: 2013-3-16
 *      Author: Joshua
 */

#ifndef DLDATABASE_H_
#define DLDATABASE_H_

#include <mysql/mysql.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <string.h>
#include <string>
#include <vector>
#include <pthread.h>
#include "../Common/PLog.h"

using namespace std;

class DLDatabase {
public:
	DLDatabase()
    {
		row = NULL;
		res = NULL;
	    //初始化连接数据库变量
		connection = mysql_init(NULL);
	    if(connection == NULL)
	    {
	        perror("mysql_init");
	        exit(1);
	    }
		//初始化互斥锁
		if(pthread_mutex_init(&connectionMutex,NULL) != 0){
			string log = string("======数据库创建互斥锁失败!======");
			PLog::logFatal(log);
		}
    }

    virtual ~DLDatabase()
    {	//删除互斥锁
    	pthread_mutex_destroy(&connectionMutex);
        //关闭初始化连接数据库变量
    	if(connection != NULL)
        {
            mysql_close(connection);
        }
    }

	bool initDB(string server_host , string user, string password, string db_name);
	bool executeSQL(string sql_str);
	vector<vector<string> > querySQL(string sql_str);
	bool create_table(string table_str_sql);

protected:
    MYSQL *connection;
    MYSQL_RES *res;
    MYSQL_ROW row;

    pthread_mutex_t connectionMutex;
};

#endif /* DLDATABASE_H_ */
