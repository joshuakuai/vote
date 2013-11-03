//
//  Protocal.h
//  PlanktonServerSDK
//
//  Created by 蒯 江華 on 13-2-9.
//  Copyright (c) 2013年 蒯 江華. All rights reserved.
//

#ifndef PlanktonServerSDK_Protocal_h
#define PlanktonServerSDK_Protocal_h

//Package indication
#define CML_PACKAGE_INDICATION 0xFFFF
#define CML_PACKAGE_PLANKTION_LOGIC_LAYER_DEFAULT_TYPE 0x01

typedef struct _CMLPackageHead{
	int indication;              //Indication of package,always 0xFFFF
	short logicLayerType;
	short logicLayerVersion;
	bool isEncrypt;
	unsigned int  packageLength; //The package length,expect head length
}CMLPackageHead;

#endif
