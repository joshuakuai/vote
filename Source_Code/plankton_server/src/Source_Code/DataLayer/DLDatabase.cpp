/*
 * DLDatabase.cpp
 *
 *  Created on: 2013-3-16
 *      Author: Joshua
 */

#include "DLDatabase.h"
#include "../Common/PLog.h"

//初始化数据库 数据库连接
bool DLDatabase::initDB(string server_host , string user, string password , string db_name )
{
	//运用mysql_real_connect函数实现数据库的连接
	connection = mysql_real_connect(connection , server_host.c_str() , user.c_str() , password.c_str() , db_name.c_str() , 0 , NULL , 0);
	if(connection == NULL)
	{
		perror("mysql_real_connect");
		exit(1);
	}
	return true;
}

//执行SQL语句(无结果)
bool DLDatabase::executeSQL(string sql_str)
{
	pthread_mutex_lock(&connectionMutex);
	// 查询编码设定
	if(mysql_query(connection, "set names utf8"))
	{
        fprintf(stderr, "%d: %s\n",mysql_errno(connection), mysql_error(connection));
    }
	int t = mysql_query(connection,  sql_str.c_str());
	if(t)
	{
		printf("Error making query: %s\n" , mysql_error(connection));
		pthread_mutex_unlock(&connectionMutex);
		return false;
	}
	pthread_mutex_unlock(&connectionMutex);
	return true;
}

//执行SQL请求语句(带结果)
vector<vector<string> > DLDatabase::querySQL(string sql_str)
{
	pthread_mutex_lock(&connectionMutex);
	vector<vector<string> > result;
	// 查询编码设定
	if (mysql_query(connection, "set names utf8")) {
		fprintf(stderr, "%d: %s\n", mysql_errno(connection),
				mysql_error(connection));
	}
	int t = mysql_query(connection, sql_str.c_str());
	if (t) {
		printf("Error making query: %s\n", mysql_error(connection));
	}else{
		//初始化逐行的结果集检索
		res = mysql_use_result(connection);
		if(res)
		{
			//mysql_field_count(connection)   返回作用在连接上的最近查询的列数
			for(unsigned int i = 0 ; i < mysql_field_count(connection) ; i++)
			{
				//检索一个结果集合的下一行
				row = mysql_fetch_row(res);
				if(row <= 0)
				{
					break;
				}
				vector<string> rowVector;
				//mysql_num_fields(res)  函数返回结果集中字段的数
				for(unsigned int r = 0 ; r  < mysql_num_fields(res) ; r ++)
				{
					rowVector.push_back(string(row[r]));
					printf("%s\t" , row[r]);
				}
				result.push_back(rowVector);
				printf("\n");
			}
		}
		//释放结果集使用的内存
		mysql_free_result(res);
	}
	pthread_mutex_unlock(&connectionMutex);
	return result;
}

//表的创建
bool DLDatabase::create_table(string table_str_sql)
{
	int t = mysql_query(connection , table_str_sql.c_str());
	if(t)
	{
		printf("Error making query: %s\n" , mysql_error(connection));
		exit(1);
	}
	return true;
}


