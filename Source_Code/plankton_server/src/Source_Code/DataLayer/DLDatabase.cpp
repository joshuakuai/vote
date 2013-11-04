/*
 * DLDatabase.cpp
 *
 *  Created on: 2013-3-16
 *      Author: Joshua
 */

#include "DLDatabase.h"
#include "../Common/PLog.h"

//初始化数据库 数据库连接
bool DLDatabase::initDB(string server_host, string user, string password,
		string db_name) {
	//运用mysql_real_connect函数实现数据库的连接
	connection = mysql_real_connect(connection, server_host.c_str(),
			user.c_str(), password.c_str(), db_name.c_str(), 0, NULL, 0);
	if (connection == NULL) {
		perror("mysql_real_connect");
		exit(1);
	}

	return true;
}

//执行SQL语句(无结果)
bool DLDatabase::executeSQL(string sql_str) {
	pthread_mutex_lock(&connectionMutex);
	// 查询编码设定
	if (mysql_query(connection, "set names utf8")) {
		fprintf(stderr, "%d: %s\n", mysql_errno(connection),
				mysql_error(connection));
	}
	int t = mysql_query(connection, sql_str.c_str());
	if (t) {
		printf("Error making query: %s\n", mysql_error(connection));
		pthread_mutex_unlock(&connectionMutex);
		return false;
	}
	pthread_mutex_unlock(&connectionMutex);
	return true;
}

//执行SQL请求语句(带结果)
vector<vector<string> > DLDatabase::querySQL(string sql_str) {
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
	} else {
		//初始化逐行的结果集检索
		res = mysql_use_result(connection);
		if (res) {
			//mysql_field_count(connection)   返回作用在连接上的最近查询的列数
			for (unsigned int i = 0; i < mysql_field_count(connection); i++) {
				//检索一个结果集合的下一行
				row = mysql_fetch_row(res);
				if (row <= 0) {
					break;
				}
				vector<string> rowVector;
				//mysql_num_fields(res)  函数返回结果集中字段的数
				for (unsigned int r = 0; r < mysql_num_fields(res); r++) {
					rowVector.push_back(string(row[r]));
					printf("%s\t", row[r]);
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

//only support get result by params
vector<char*> DLDatabase::excuteCall(string sql_str, MYSQL_BIND* params) {
	vector<char*> result;

	//check if mysql version is support his feature
	if (!this->isMySQLSupportCall()) {
		PLog::logFatal(
				"MySQL version does not support call statement, please upgrade your MySQL!");
		exit(1);
	}

	/* initialize and prepare CALL statement with parameter placeholders */
	MYSQL_STMT *stmt = mysql_stmt_init(connection);
	if (!stmt) {
		PLog::logFatal("Could not initialize statement for excuteCall.");
		exit(1);
	}

	int status = mysql_stmt_prepare(stmt, sql_str.c_str(), sql_str.length());
	this->test_stmt_error(stmt, status);

	/* bind parameters */
	status = mysql_stmt_bind_param(stmt, params);
	this->test_stmt_error(stmt, status);

	int i;
	int num_fields; /* number of columns in result */
	MYSQL_FIELD *fields; /* for result set metadata */
	MYSQL_BIND *rs_bind; /* for output buffers */

	/* the column count is > 0 if there is a result set */
	/* 0 if the result is only the final status packet */
	num_fields = mysql_stmt_field_count(stmt);

	if (num_fields > 0) {
		MYSQL_RES *rs_metadata = mysql_stmt_result_metadata(stmt);
		test_stmt_error(stmt, rs_metadata == NULL);

		fields = mysql_fetch_fields(rs_metadata);

		rs_bind = (MYSQL_BIND *) malloc(sizeof(MYSQL_BIND) * num_fields);
		if (!rs_bind) {
			PLog::logFatal("Cannot allocate call statement output buffers.");
			exit(1);
		}
		memset(rs_bind, 0, sizeof(MYSQL_BIND) * num_fields);

		/* set up and bind result set output buffers */
		for (i = 0; i < num_fields; ++i) {
			rs_bind[i].buffer_type = fields[i].type;
			rs_bind[i].is_null = params[i].is_null;
			rs_bind[i].buffer = params[i].buffer;
			rs_bind[i].buffer_length = params[i].buffer_length;
		}

		status = mysql_stmt_bind_result(stmt, rs_bind);
		test_stmt_error(stmt, status);

		//there should be only one line result
		/* fetch and store result set rows */
		status = mysql_stmt_fetch(stmt);



		for (i = 0; i < num_fields; ++i) {
			char *buff = (char*)malloc(rs_bind[i].buffer_length+1);
			memset(buff, 0, rs_bind[i].buffer_length+1);
			strcpy(buff,(char*)rs_bind[i].buffer);
		}

		mysql_free_result(rs_metadata); /* free metadata */
		free(rs_bind); /* free output buffers */
	}

	mysql_stmt_close(stmt);

	return result;
}

//表的创建
bool DLDatabase::create_table(string table_str_sql) {
	int t = mysql_query(connection, table_str_sql.c_str());
	if (t) {
		printf("Error making query: %s\n", mysql_error(connection));
		exit(1);
	}
	return true;
}

bool DLDatabase::isMySQLSupportCall() {
	if (mysql_get_server_version(connection) < 50503) {
		fprintf(stderr, "Server does not support required CALL capabilities\n");
		return false;
	}

	return true;
}

void DLDatabase::test_error(MYSQL *mysql, int status) {
	if (status) {
		fprintf(stderr, "Error: %s (errno: %d)\n", mysql_error(mysql),
				mysql_errno(mysql));
		exit(1);
	}
}

void DLDatabase::test_stmt_error(MYSQL_STMT *stmt, int status) {
	if (status) {
		fprintf(stderr, "Error: %s (errno: %d)\n", mysql_stmt_error(stmt),
				mysql_stmt_errno(stmt));
		exit(1);
	}
}

