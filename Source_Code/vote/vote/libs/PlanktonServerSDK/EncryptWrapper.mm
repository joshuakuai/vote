//
//  EncryptWrapper.m
//  TestDes
//
//  Created by kuaijianghua on 1/11/14.
//
//

#import "EncryptWrapper.h"

#ifdef __cplusplus
/*
 * Encrypt.cpp
 *
 *  Created on: 2013-6-13
 *      Author: Joshua
 */

Encrypt::Encrypt(string key) {
    this->setKey(key);
}

void Encrypt::setKey(string key) {
    string keyDecoded;
	StringSource ss(key, true, new HexDecoder(new StringSink(keyDecoded)) // HexDecoder
                    );// StringSource
    
	for(unsigned int i = 0;i<keyDecoded.size();i++){
		this->key[i] = keyDecoded[i];
	}
}

string Encrypt::encrypt(string encryptContent) {
	string cipher;
	try
	{
		ECB_Mode< AES >::Encryption e;
		e.SetKey(key, sizeof(key));
        
		// The StreamTransformationFilter adds padding
		//  as required. ECB and CBC Mode must be padded
		//  to the block size of the cipher.
		StringSource(encryptContent, true,
                     new StreamTransformationFilter(e,
                                                    new StringSink(cipher)
                                                    ) // StreamTransformationFilter
                     ); // StringSource
	}
	catch(const CryptoPP::Exception& e)
	{
		cerr << e.what() << endl;
		exit(1);
	}
    
	string encoded;
    
	// Pretty print
	encoded.clear();
	StringSource(cipher, true,
                 new HexEncoder(
                                new StringSink(encoded)
                                ) // HexEncoder
                 ); // StringSource
    
	return encoded;
}

string Encrypt::decrypt(string decryptContent) {
	string result;
    
	string hexDecryptContent;
    
	StringSource ss(decryptContent, true, new HexDecoder(new StringSink(hexDecryptContent)) // HexDecoder
                    );// StringSource
    
	try
	{
		ECB_Mode< AES >::Decryption d;
		d.SetKey(key, sizeof(key));
        
		// The StreamTransformationFilter removes
		//  padding as required.
		StringSource s(hexDecryptContent, true,
                       new StreamTransformationFilter(d,
                                                      new StringSink(result)
                                                      ) // StreamTransformationFilter
                       ); // StringSource
	}
	catch(const CryptoPP::Exception& e)
	{
		cerr << e.what() << endl;
		exit(1);
	}
    
	return result;
}
#endif

@implementation EncryptWrapper

- (id)init
{
    self = [super init];
    
    if (self) {
        encrypt = new Encrypt();
    }
    
    return self;
}

- (id)initWithKey:(NSString*)keyString
{
    self = [super init];
    
    if (self) {
        encrypt = new Encrypt(string([keyString cStringUsingEncoding:NSUTF8StringEncoding]));
    }
    
    return self;
}

- (void)dealloc
{
    delete encrypt;
}

- (void)setKey:(NSString*)key
{
    encrypt->setKey(string([key cStringUsingEncoding:NSUTF8StringEncoding]));
}

- (NSString*)encrypt:(NSString*)content
{
    string contentString([content cStringUsingEncoding:NSUTF8StringEncoding]);
    string encryptedString = encrypt->encrypt(contentString);
    return [NSString stringWithUTF8String:encryptedString.c_str()];
}

- (NSString*)decrypt:(NSString*)content
{
    string contentString([content cStringUsingEncoding:NSUTF8StringEncoding]);
    string decryptedString = encrypt->decrypt(contentString);
    return [NSString stringWithUTF8String:decryptedString.c_str()];
}

@end
