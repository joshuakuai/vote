/*
 * Encrypt.h
 *
 *  Created on: 2013-6-13
 *      Author: Joshua
 */

#ifndef ENCRYPT_H_
#define ENCRYPT_H_

#include <string>
#include <string.h>
#include <iostream>
#include <cstdlib>
#include "cryptopp/osrng.h"
#include "cryptopp/cryptlib.h"
#include "cryptopp/hex.h"
#include "cryptopp/filters.h"
#include "cryptopp/aes.h"
#include "cryptopp/modes.h"

using namespace std;
using namespace CryptoPP;

//加密器
class Encrypt {
public:
	//指定KEY
	Encrypt(string key);

	virtual ~Encrypt(){};

	string encrypt(string encryptContent);
	string decrypt(string decryptContent);

private:
	byte key[AES::DEFAULT_KEYLENGTH];
};

#endif /* ENCRYPT_H_ */

