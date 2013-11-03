/*
 * Observer.h
 *
 *  Created on: 2013-3-17
 *      Author: Joshua
 */

#ifndef OBSERVER_H_
#define OBSERVER_H_
#include <string>
#include <vector>

using namespace std;

class Observer{
public:
    vector<string> notificationNameList;

	virtual ~Observer(){};
	virtual void notify(string notificationName,void *arg) = 0;
};


#endif /* OBSERVER_H_ */
