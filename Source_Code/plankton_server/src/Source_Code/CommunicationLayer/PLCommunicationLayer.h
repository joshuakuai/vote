/*
 * PLCommunicationLayer.h
 *
 *  Created on: Jan 30, 2013
 *      Author: joshuakuai
 */

#ifndef PLCOMMUNICATIONLAYER_H_
#define PLCOMMUNICATIONLAYER_H_

#include <vector>
#include <sys/socket.h>
#include "../Common/PLog.h"
#include "CMLSessionPool.h"

using namespace std;
/*
 * This class will take care the communication layer of the server.
 * It will only receive the package and confirm it is valid or not and transfer it to
 * logic layer.
 */
class PLCommunicationLayer {
public:
	PLCommunicationLayer();
	virtual ~PLCommunicationLayer();

	//Start the communication layer
	void start();

	//Stop the communication layer
    void stop();

    //Send package to the session which contains in the vector
    void broadcast(vector<char*> sessionVector);
private:
    //SessionPool
    CMLSessionPool *sessionPool;
};

#endif /* PLCOMMUNICATIONLAYER_H_ */
