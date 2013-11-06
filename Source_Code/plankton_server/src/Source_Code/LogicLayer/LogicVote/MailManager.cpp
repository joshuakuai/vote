/*
 * MailManager.cpp
 *
 *  Created on: Nov 5, 2013
 *      Author: kuaijianghua
 */

#include "MailManager.h"
#include "../../Common/PLog.h"
#include <stdio.h>
#include <fstream>

MailManager::MailManager(string trustFileName, string contentFileName,
		string sender, string senderPassword) {
	this->trustFileName = trustFileName;
	this->contentFileName = contentFileName;
	this->from = sender;
	this->emailPassword = senderPassword;

	//初始化互斥锁
	if (pthread_mutex_init(&emailSendMutex, NULL) != 0) {
		string log = string(
				"======Failed to create the CodeManager's thread mutex======");
		PLog::logFatal(log);
	}
}

MailManager::~MailManager() {
	//销毁互斥锁
	pthread_mutex_destroy(&emailSendMutex);
}

void MailManager::sendMail(string mailContent, string destination,
		string subject) {
	pthread_mutex_lock(&emailSendMutex);
	//write the mail content to the file
	ofstream contentFile(this->contentFileName.c_str());
	if (!contentFile.is_open()) {
		PLog::logWarning("Fail to open the mail content file!");
		return;
	} else {
		contentFile
				<< "To: " + destination + "\nFrom: " + this->from
						+ "\nSubject: " + subject + "\n" + mailContent;
		contentFile.close();
	}

	//set up the command mail string
	string commandString =
			"cat " + contentFileName
					+ " | msmtp --host=smtp.gmail.com --port=587 --tls=on --tls-trust-file="
					+ this->trustFileName
					+ " --timeout=3 --protocol=smtp --auth=on --user=" + from
					+ " --from=" + from + " --passwordeval=\"echo "
					+ emailPassword + "\" -- " + destination;

	//send the mail
	FILE* file = popen(commandString.c_str(), "w");

	if (!file) {
		PLog::logWarning("Fail to send the mail!");
	}

	pclose(file);

	pthread_mutex_unlock(&emailSendMutex);
}
