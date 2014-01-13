//
//  PLServer.m
//  PlanktonServerSDK
//
//  Created by 蒯 江華 on 13-2-13.
//  Copyright (c) 2013年 蒯 江華. All rights reserved.
//

#import "PLServer.h"
#import "EncryptWrapper.h"

static PLServer *instance = NULL;

@interface PLServer (){
    AsyncSocket *_socket;
    NSString *_sendString;
    EncryptWrapper *_encrypt;
    NSString *ipString;
    NSInteger portNumber;
    short logicType;
    short logicVersion;
    BOOL _isEncrypt;
}

@end

@implementation PLServer

-(void)setLogicType:(short)type logicVersion:(short)version
{
    logicType = type;
    logicVersion = version;
}

-(void)setServerIP:(NSString*)ip port:(NSInteger)port
{
    ipString = [ip copy];
    portNumber = port;
}

- (void)setKey:(NSString*)key
{
    [_encrypt setKey:key];
}

- (void)setEncryptMode:(BOOL)isEncrypt
{
    _isEncrypt = isEncrypt;
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
        _sendString = nil;
        _encrypt = [[EncryptWrapper alloc] init];
        _socket = [[AsyncSocket alloc] initWithDelegate:self];
        ipString = nil;
        _isEncrypt = NO;
    }
    return self;
}

- (void)dealloc
{
    _socket.delegate = nil;
    [_socket disconnect];
}

-(void)openLongConnection
{
    //TODO:IMPLEMENT THIS!!
}

-(void)closeConnection
{
    if ([_socket isConnected]) {
        [_socket disconnect];
    }
}

-(void)sendDataWithString:(NSString*)jsonString
{
    _sendString = [jsonString copy];

    //temporal request
    if ([_socket isConnected]) {
        [self sendData];
    }else{
        NSError *error = nil;
        if (![_socket connectToHost:ipString onPort:portNumber withTimeout:5 error:&error]) {
            [_delegate plServer:self failedWithError:error];
        }
    }
    
    //Long connection
}

-(void)sendDataWithDic:(NSDictionary*)josonDic
{
    NSString *jsonString = [josonDic JSONString];
    [self sendDataWithString:jsonString];
}

- (void)sendData
{
    CMLPackageHead *head;
    char data[sizeof(CMLPackageHead)];
    int len = 0;
    head = (CMLPackageHead *)&data[len];
    head->indication = CML_PACKAGE_INDICATION;
    head->isEncrypt = _isEncrypt;
    head->logicLayerType = logicType;
    head->logicLayerVersion = logicVersion;
    
    //check if this need encrypt
    if (_isEncrypt) {
        _sendString = [_encrypt encrypt:_sendString];
        NSLog(@"SendString %@",_sendString);
    }
    
    head->packageLength = (unsigned int)_sendString.length;
    len += sizeof(CMLPackageHead);
    NSMutableData *sendData = [[NSMutableData alloc] initWithBytes:head length:len];
    [sendData appendData:[_sendString dataUsingEncoding:NSUTF8StringEncoding]];
    [_socket readDataWithTimeout:10 buffer:nil bufferOffset:0 maxLength:1024*4 tag:1];
    [_socket writeData:sendData withTimeout:6 tag:1];
}

#pragma mark - AsyncSocket delegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [self sendData];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"The data of the package is :%@ Length is :%lu" ,data,(unsigned long)data.length);
    if (data == nil || data.length == 0) {
        return;
    }
    
    //Get the json string
    char *buffer = (char *)[data bytes];
    CMLPackageHead *head = (CMLPackageHead*)&buffer[0];
    
    if (head->indication != CML_PACKAGE_INDICATION) {
        //Check indication failed,just ignore this data
        return;
    }
    
    //We did not consider the situation of mutil package
    if (head->packageLength + sizeof(CMLPackageHead) == data.length) {
        NSString *jsonString = [[NSString alloc] initWithCString:&buffer[sizeof(CMLPackageHead)] encoding:NSUTF8StringEncoding];
        
        //check if the data is encrypted
        if (head->isEncrypt) {
            jsonString = [_encrypt decrypt:jsonString];
        }
        
        [_delegate plServer:self didReceivedJSONString:[jsonString objectFromJSONString]];
    }else{
        //does not finish,continue receive
        [_socket readDataWithTimeout:10 buffer:[NSMutableData dataWithData:data] bufferOffset:[data length] maxLength:1024*4 tag:1];
    }
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"PLServer:Successful write data to server");
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    [_delegate plServer:self failedWithError:err];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    if (_delegate && [_delegate respondsToSelector:@selector(connectionClosed:)]) {
        [_delegate connectionClosed:self];
    }
}

@end
