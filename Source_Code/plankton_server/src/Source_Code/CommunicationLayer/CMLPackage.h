/*
 * CMLPackage.h
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */
#ifndef CMLPACKAGE_H_
#define CMLPACKAGE_H_

#include <string>
#include "CMLPackageProtocal.h"

using namespace std;
/*
 * This is a static class
 */
class CMLPackage {
public:
	static string formPackage(string packageContent,short type,short version);

	//超过长度的，将会被直接丢弃
	static string getPackageContent(string packageString);
};

#endif /* CMLPACKAGE_H_ */
