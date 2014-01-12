/*
 * Encrypt.cpp
 *
 *  Created on: 2013-6-13
 *      Author: Joshua
 */

#include "Encrypt.h"

Encrypt::Encrypt(string key) {
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

