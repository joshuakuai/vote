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
	MailManager(string trustFileName,string contentFileName,string sender,string senderPassword);
	virtual ~MailManager();

	void sendMail(string mailContent,string destination,string subject);
private:
	string mailContent;
	string destination;
	string from;
	string emailPassword;
	string trustFileName;
	string contentFileName;

	//mutex
	pthread_mutex_t emailSendMutex;
};

#endif /* MAILMANAGER_H_ */
