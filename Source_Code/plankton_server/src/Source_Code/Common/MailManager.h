/*
 * MailManager.h
 *
 *  Created on: Nov 5, 2013
 *      Author: kuaijianghua
 */

#ifndef MAILMANAGER_H_
#define MAILMANAGER_H_

#include <string>
#include <pthread.h>

using namespace std;

//Now we only support GMail
class MailManager {
public:
	//单例方法
	static MailManager * Instance() {
		if (0 == _instance) {
			_instance = new MailManager;
		}
		return _instance;
	}

	//释放方法
	static void Release() {
		if (NULL != _instance) {
			delete _instance;
			_instance = NULL;
		}
	}

	void setMailInfoFromConfigureManager();
	void sendMail(string mailContent,string destination,string subject);
private:
	MailManager();
	virtual ~MailManager();

	string mailContent;
	string destination;
	string from;
	string emailPassword;
	string trustFileName;
	string contentFileName;

	static MailManager* _instance;

	//mutex
	pthread_mutex_t emailSendMutex;
};

#endif /* MAILMANAGER_H_ */
