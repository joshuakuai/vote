/*
 * Converter.h
 *
 *  Created on: 2013-6-26
 *      Author: Joshua
 */

#ifndef CONVERTER_H_
#define CONVERTER_H_

#include <algorithm>
#include <iostream>
#include <sstream>
#include <stdexcept>

using namespace std;

class Converter {
public:
	Converter(){}
	virtual ~Converter(){};

	static string string_to_hex(const string& input) {
		static const char* const lut = "0123456789ABCDEF";
		size_t len = input.length();

		string output;
		output.reserve(2 * len);
		for (size_t i = 0; i < len; ++i) {
			const unsigned char c = input[i];
			output.push_back(lut[c >> 4]);
			output.push_back(lut[c & 15]);
		}
		return output;
	}

	static string hex_to_string(const string& input)
	{
	    static const char* const lut = "0123456789ABCDEF";
	    size_t len = input.length();
	    if (len & 1) throw std::invalid_argument("odd length");

	    string output;
	    output.reserve(len / 2);
	    for (size_t i = 0; i < len; i += 2)
	    {
	        char a = input[i];
	        const char* p = std::lower_bound(lut, lut + 16, a);
	        if (*p != a) throw std::invalid_argument("not a hex digit");

	        char b = input[i + 1];
	        const char* q = std::lower_bound(lut, lut + 16, b);
	        if (*q != b) throw std::invalid_argument("not a hex digit");

	        output.push_back(((p - lut) << 4) | (q - lut));
	    }
	    return output;
	}

	static int string_to_int(const string& input)
	{
		return atoi(input.c_str());
	}

	static string int_to_string(const int& input)
	{
		ostringstream convert;

		convert<<input;

		return convert.str();
	}
};

#endif /* CONVERTER_H_ */
