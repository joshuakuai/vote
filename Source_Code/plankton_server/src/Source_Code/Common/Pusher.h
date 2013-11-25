/*
 * Pusher.h
 *
 *  Created on: 2013-3-17
 *      Author: Joshua
 */

#ifndef PUSHER_H_
#define PUSHER_H_

#include <string>
#include <vector>
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>

#include <openssl/ssl.h>
#include <openssl/crypto.h>
#include <openssl/err.h>
#include "ConfigureManager.h"

#define APNS_SANDBOX_HOST "gateway.sandbox.push.apple.com"
#define APNS_SANDBOX_PORT 2195

#define APNS_HOST "gateway.sandbox.push.apple.com"
#define APNS_PORT 2195

#define DEVICE_BINARY_SIZE 32
#define MAXPAYLOAD_SIZE 256

using namespace std;

class Pusher {
public:
	static Pusher * Instance() {
		if (0 == _instance) {
			//get the certificate file name
			string fileName = ConfigureManager::Instance()->value["PushCertificateFileName"].asString();
			_instance = new Pusher(fileName);
			_instance->isSandbox = ConfigureManager::Instance()->value["isPushSandbox"].asBool();
		}
		return _instance;
	}

	static void Release() {
		if (NULL != _instance) {
			delete _instance;
			_instance = NULL;
		}
	}

	string _cerFileName;
	bool isSandbox;

	void pushNotification(string pushContent,vector<string> tokenStringVector);

private:
	static Pusher* _instance;
	pthread_mutex_t vectormutex;

	Pusher(string cerFileName);
	virtual ~Pusher();

	vector<string> tokenStringVector;

	string binaryToken(const std::string& input);
	int charToHex(char value);
	void prepareConnect(string pushContent);
	bool sendPayload(SSL *sslPtr, char *deviceTokenBinary, char *payloadBuff, size_t payloadLength);
};

#endif /* PUSHER_H_ */
