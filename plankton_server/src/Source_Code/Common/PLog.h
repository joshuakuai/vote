/*
 * PLog.h
 *
 *  Created on: Feb 3, 2013
 *      Author: joshuakuai
 */

#ifndef PLOG_H_
#define PLOG_H_
#include <string>

using namespace std;
/*
 * There are three level of the log.
 *
 */
typedef enum _PlogLevel{None,Normal,Verbose}PlogLevel;
typedef enum _PlogType{Hint,Warning,Fatal}PlogType;

class PLog {
public:
	static PlogLevel logLevel;

	static void setLogLevel(PlogLevel level);
	static void logWithType(char *content,PlogType type);

	static void logWarning(string content);

	static void logHint(string content);

	static void logFatal(string content);
};

#endif /* PLOG_H_ */
