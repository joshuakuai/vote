/*
 * Pusher.cpp
 *
 *  Created on: 2013-3-17
 *      Author: Joshua
 */

#include <algorithm>
#include <stdexcept>
#include <arpa/inet.h>
#include <sstream>
#include <iostream>
#include <string.h>
#include <unistd.h>
#include "Pusher.h"

Pusher* Pusher::_instance = NULL;

Pusher::Pusher(string cerFileName) {
	_cerFileName = cerFileName;
	this->isSandbox = true;
}

Pusher::~Pusher() {
	tokenStringVector.clear();
}

int Pusher::charToHex(char value) {
	unsigned int x;
	stringstream ss;
	ss << std::hex << value;
	ss >> x;
	return x;
}

string Pusher::binaryToken(const std::string& input) {
	size_t len = input.length();

	//Convert string to the hex vector
	vector<char> inputCharVector;
	for (size_t i = 0; i < len; i++) {
		inputCharVector.push_back(this->charToHex(input[i]));
	}

	string output = "";
	char buffer[32];
	int location = 0;
	memset(buffer, 0, 32);

	unsigned value;
	unsigned data[4];
	for (size_t i = 0; i < len; i += 8) {
		memset(data, 0, 4);
		data[0] = (inputCharVector[i] << 4) | (inputCharVector[i + 1]);
		data[1] = (inputCharVector[i + 2] << 4) | (inputCharVector[i + 3]);
		data[2] = (inputCharVector[i + 4] << 4) | (inputCharVector[i + 5]);
		data[3] = (inputCharVector[i + 6] << 4) | (inputCharVector[i + 7]);

		value = (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];

		value = htonl(value);

		memcpy(&buffer[location], &value, sizeof(unsigned));

		location += sizeof(unsigned);
	}

	return output.append(buffer, 32);
}

void Pusher::pushNotification(string pushContent,
		vector<string> tokenStringVector) {
	if (tokenStringVector.size() == 0) {
		return;
	}

	tokenStringVector.clear();
	this->tokenStringVector = tokenStringVector;

	/*
	 //根据程序名称查找token列表
	 string queryString = "SELECT token_string FROM Token";
	 vector<vector<string> > result = database->querySQL(queryString);

	 if(result.size() != 0){
	 for(unsigned int i =0;i<result.size();i++){
	 //获得tokenString
	 string cacheTokenString = result[i][0];
	 tokenStringVector.push_back(cacheTokenString);
	 //cout<<cacheTokenString<<endl;
	 }
	 }else{
	 return;
	 }
	 */

	this->prepareConnect(pushContent);
}

void Pusher::prepareConnect(string pushContent) {
	SSL_CTX *ctx;
	SSL *ssl;
	int sockfd;
	struct hostent *he;
	struct sockaddr_in sa;
	//char data[2048];
	//unsigned short payload_len;

	SSLeay_add_ssl_algorithms();
	SSL_load_error_strings();
	ctx = SSL_CTX_new(SSLv3_method());
	if (!ctx) {
		printf("SSL_CTX_new()...failed\n");
		exit(1);
	}

	if (SSL_CTX_load_verify_locations(ctx, NULL, ".") <= 0) {
		ERR_print_errors_fp(stderr);
		exit(1);
	}

	if (SSL_CTX_use_certificate_file(ctx, _cerFileName.c_str(),
	SSL_FILETYPE_PEM) <= 0) {
		ERR_print_errors_fp(stderr);
		exit(1);
	}

	if (SSL_CTX_use_PrivateKey_file(ctx, _cerFileName.c_str(), SSL_FILETYPE_PEM)
			<= 0) {
		ERR_print_errors_fp(stderr);
		exit(1);
	}

	if (SSL_CTX_check_private_key(ctx) <= 0) {
		ERR_print_errors_fp(stderr);
		exit(1);
	}

	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd == -1) {
		printf("socket()...-1\n");
		exit(1);
	}

	sa.sin_family = AF_INET;
	if(this->isSandbox){
		he = gethostbyname(APNS_SANDBOX_HOST);
	}else{
		he = gethostbyname(APNS_HOST);
	}

	if (!he) {
		close(sockfd);
		exit(1);
	}
	sa.sin_addr.s_addr = inet_addr(
			inet_ntoa(*((struct in_addr *) he->h_addr_list[0])));

	if(this->isSandbox){
		sa.sin_port = htons(APNS_SANDBOX_PORT);
	}else{
		sa.sin_port = htons(APNS_PORT);
	}


	if (connect(sockfd, (struct sockaddr *) &sa, sizeof(sa)) == -1) {
		close(sockfd);
		exit(1);
	}

	ssl = SSL_new(ctx);
	SSL_set_fd(ssl, sockfd);
	if (SSL_connect(ssl) == -1) {
		shutdown(sockfd, 2);
		close(sockfd);
		exit(1);
	}
	/*
	 printf("Device Token: 4c54d328 96765538 822d44c4 cad111a7 e21006e6 51eb5a0b 7af87379 3c7eba78\n");
	 memcpy(data, "\x0\xff\xff"
	 "\x4c\x54\xd3\x28\x96\x76\x55\x38"
	 "\x82\x2d\x44\xc4\xca\xd1\x11\xa7"
	 "\xe2\x10\x06\xe6\x51\xeb\x5a\x0b"
	 "\x7a\xf8\x73\x79\x3c\x7e\xba\x78"
	 "\xff\xff"
	 "{"
	 "\"aps\":{"
	 "\"alert\":\"abcdefg\","
	 "\"badge\":1,"
	 "\"sound\":\"default\""
	 "},"
	 "\"time\":12345678,"
	 "\"seller\":\"abcdefg\""
	 "}", sizeof(data));
	 *(unsigned short *)(&data[1]) = htons(32);
	 payload_len = strlen(&data[1+2+32+2]);
	 *(unsigned short *)(&data[1+2+32]) = htons(payload_len);
	 printf("%s\n", &data[1+2+32+2]);
	 if (SSL_write(ssl, data, 1 + 2 + 32 + 2 + payload_len) == -1) {
	 ERR_print_errors_fp(stderr);
	 exit(2);
	 }
	 */

	/*char token[32] = {0x2d,0x23,0xab,0xed,0x70,0x07,0x9a,0xb3,
	 0xcf,0x48,0x0c,0xf5,0xa2,0x07,0x08,0x1a,
	 0x90,0xa0,0xbd,0x21,0xe7,0x9d,0x90,0x94,
	 0x6e,0xb3,0xcc,0x00,0xaf,0x8c,0xa0,0xe2};*/

	/*char token[32] = { 0x4c, 0x54, 0xd3, 0x28, 0x96, 0x76, 0x55, 0x38, 0x82,
	 0x2d, 0x44, 0xc4, 0xca, 0xd1, 0x11, 0xa7, 0xe2, 0x10, 0x06, 0xe6,
	 0x51, 0xeb, 0x5a, 0x0b, 0x7a, 0xf8, 0x73, 0x79, 0x3c, 0x7e, 0xba,
	 0x78 };
	 cout<<string(token)<<endl;
	 */

	int successNumber = 0;
	int failedNumber = 0;
	unsigned int i = 0;
	for (; i < tokenStringVector.size(); i++) {
		if (!this->sendPayload(ssl,
				(char*) this->binaryToken(tokenStringVector[i]).c_str(),
				(char*) pushContent.c_str(), pushContent.length())) {
			failedNumber++;
		} else {
			successNumber++;
		}
	}

	cout << "Finish push notification, total" << i << ", Successful"
			<< successNumber << ", Failed" << failedNumber << "." << endl;

	SSL_shutdown(ssl);
	SSL_free(ssl);
	close(sockfd);
	SSL_CTX_free(ctx);
}

bool Pusher::sendPayload(SSL *sslPtr, char *deviceTokenBinary,
		char *payloadBuff, size_t payloadLength) {
	bool rtn = false;
	if (sslPtr && deviceTokenBinary && payloadBuff && payloadLength) {
		uint8_t command = 0; /* command number */
		char binaryMessageBuff[sizeof(uint8_t) + sizeof(uint16_t)
				+ DEVICE_BINARY_SIZE + sizeof(uint16_t) + MAXPAYLOAD_SIZE];

		/* message format is, |COMMAND|TOKENLEN|TOKEN|PAYLOADLEN|PAYLOAD| */
		char *binaryMessagePt = binaryMessageBuff;
		uint16_t networkOrderTokenLength = htons(DEVICE_BINARY_SIZE);
		uint16_t networkOrderPayloadLength = htons(payloadLength);

		/* command */
		*binaryMessagePt++ = command;

		/* token length network order */
		memcpy(binaryMessagePt, &networkOrderTokenLength, sizeof(uint16_t));
		binaryMessagePt += sizeof(uint16_t);

		/* device token */
		memcpy(binaryMessagePt, deviceTokenBinary, DEVICE_BINARY_SIZE);
		binaryMessagePt += DEVICE_BINARY_SIZE;

		/* payload length network order */
		memcpy(binaryMessagePt, &networkOrderPayloadLength, sizeof(uint16_t));
		binaryMessagePt += sizeof(uint16_t);

		/* payload */
		memcpy(binaryMessagePt, payloadBuff, payloadLength);
		binaryMessagePt += payloadLength;
		if (SSL_write(sslPtr, binaryMessageBuff,
				(binaryMessagePt - binaryMessageBuff)) > 0) {
			rtn = true;
		}
	}
	return rtn;
}
