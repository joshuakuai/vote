//
//  PLServer.m
//  PlanktonServerSDK
//
//  Created by 蒯 江華 on 13-2-13.
//  Copyright (c) 2013年 蒯 江華. All rights reserved.
//

#import "PLServer.h"


static PLServer *instance;
static NSString *ipString;
static NSInteger portNumber;
static short logicType;
static short logicVersion;

@interface PLServer (){
    TcpStream *_tcpStream;
    NSString *_sendString;
}

@end

@implementation PLServer

+(void)setLogicType:(short)type logicVersion:(short)version
{
    logicType = type;
    logicVersion = version;
}

+(void)setServerIP:(NSString*)ip port:(NSInteger)port
{
    ipString = [ip copy];
    portNumber = port;
}

+(id)shareInstance
{
    if(!instance){
        instance = [[PLServer alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _tcpStream = [[TcpStream alloc] initWithHost:ipString port:portNumber];
        _tcpStream.delegate = self;
        _sendString = nil;
    }
    return self;
}

- (void)dealloc
{
    [_tcpStream close];
}

-(void)openLongConnection
{
    //TODO:IMPLEMENT THIS!!
}

-(void)closeConnection
{
    [_tcpStream close];
}

-(void)sendDataWithString:(NSString*)jsonString
{
    _sendString = [jsonString copy];

    //temporal request
    if ([_tcpStream connected]) {
        [self sendData];
    }else{
        //ini the tcpstream again
        _tcpStream = [[TcpStream alloc] initWithHost:ipString port:portNumber];
        _tcpStream.delegate = self;
        
        [_tcpStream connect];
    }
    
    //Long connection
}

-(void)sendDataWithDic:(NSDictionary*)josonDic
{
    NSString *jsonString = [josonDic JSONString];
    [self sendDataWithString:jsonString];
}

#pragma mark - TcpStream delegate
- (void)tcpStreamDidConnected:(TcpStream *)tcpStream
{
    [self sendData];
}

- (void)sendData
{
    CMLPackageHead *head;
    char data[sizeof(CMLPackageHead)];
    int len = 0;
    head = (CMLPackageHead *)&data[len];
    head->indication = CML_PACKAGE_INDICATION;
    head->isEncrypt = false;
    head->logicLayerType = CML_PACKAGE_PLANKTION_LOGIC_LAYER_DEFAULT_TYPE;
    head->logicLayerVersion = 1;
    head->packageLength = (unsigned int)_sendString.length;
    len += sizeof(CMLPackageHead);
    NSMutableData *sendData = [[NSMutableData alloc] initWithBytes:head length:len];
    [sendData appendData:[_sendString dataUsingEncoding:NSUTF8StringEncoding]];
    [_tcpStream sendData:sendData];
}

- (BOOL)tcpStream:(TcpStream *)tcpStream didReceivedData:(NSData *)data
{
    //NSLog(@"The data of the package is :%@ Length is :%d" ,data,data.length);
    if (data == nil || data.length == 0) {
        return YES;
    }
    
    //Get the json string
    char *buffer = (char *)[data bytes];
    CMLPackageHead *head = (CMLPackageHead*)&buffer[0];
    
    if (head->indication != CML_PACKAGE_INDICATION) {
        //Check indication failed,just ignore this data
        return YES;
    }

    //We did not consider the situation of mutil package
    if (head->packageLength + sizeof(CMLPackageHead) == data.length) {
        NSString *jsonString = [[NSString alloc] initWithCString:&buffer[sizeof(CMLPackageHead)] encoding:NSUTF8StringEncoding];
        [_delegate plServer:self didReceivedJSONString:[jsonString objectFromJSONString]];
        return YES;
    }else{
        //Still did not received complete 
        return NO;
    }    
}

- (void)tcpStream:(TcpStream *)tcpStream didFailWithError:(NSError *)error
{
    [_delegate plServer:self failedWithError:error];
}

- (void)tcpStreamDidRemoteClosedConnection:(TcpStream *)tcpStream
{
    NSLog(@"PLServer:Connection Closed");
}


@end
