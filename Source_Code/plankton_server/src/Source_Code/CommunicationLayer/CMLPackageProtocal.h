//This is the protocal of the communication

//Package indication
#define CML_PACKAGE_INDICATION 0xFFFF

typedef struct _CMLPackageHead{
	int indication;              //Indication of package,always 0xef
	short logicLayerType;
	short logicLayerVersion;
	bool isEncrypt;
	unsigned int  packageLength; //The package length,package head is not include
}CMLPackageHead;
