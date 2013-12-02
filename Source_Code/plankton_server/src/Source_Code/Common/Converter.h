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
#include <ctime>

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
		return Converter::double_to_string(input);
	}

	static string double_to_string(const double& input)
	{
		ostringstream convert;

		convert<<input;

		return convert.str();
	}

	static double string_to_double(const string& input)
	{
		return atof(input.c_str());
	}

	static string time_t_to_mysql_datetime_string(const time_t time)
	{
		tm * ptm = localtime(&time);

		char buffer[32];
		strftime(buffer,32,"%Y-%m-%d %H:%M:%S",ptm);

		return string(buffer);
	}

	static time_t mysql_datetime_string_to_time_t(const string& input)
	{
		struct tm tmlol;
		strptime(input.c_str(), "%Y-%m-%d %H:%M:%S", &tmlol);
		time_t t = mktime(&tmlol);
		//cout << "T time int " << t << endl;
		return t;
	}
};

#endif /* CONVERTER_H_ */
