//
//  EncryptWrapper.h
//  TestDes
//
//  Created by kuaijianghua on 1/11/14.
//
//

//Cpp class
#ifdef __cplusplus
#ifndef ENCRYPT_H_
#define ENCRYPT_H_

#include <string>
#include <string.h>
#include <iostream>
#include <cstdlib>
#include "osrng.h"
#include "cryptlib.h"
#include "hex.h"
#include "filters.h"
#include "aes.h"
#include "modes.h"

using namespace std;
using namespace CryptoPP;

//加密器
class Encrypt {
public:
	//指定KEY
	Encrypt(string key);
    
    Encrypt(){};
	virtual ~Encrypt(){};
    
    void setKey(string key);
	string encrypt(string encryptContent);
	string decrypt(string decryptContent);
    
private:
	byte key[AES::DEFAULT_KEYLENGTH];
};

#endif /* ENCRYPT_H_ */
#endif

#import <Foundation/Foundation.h>

@interface EncryptWrapper : NSObject{
#ifdef __cplusplus
    Encrypt *encrypt;
#endif
}

- (id)initWithKey:(NSString*)keyString;
- (NSString*)encrypt:(NSString*)content;
- (NSString*)decrypt:(NSString*)content;
- (void)setKey:(NSString*)key;

@end
