//
//  TcpStream.h
//  test
//
//  Created by wupeng on 12-12-22.
//  Copyright (c) 2012年 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TcpStreamDelegate;

@interface TcpStream : NSObject<NSStreamDelegate>
{
    NSString         *_host;
    NSInteger        _port;

    CFReadStreamRef  _readStream;
    CFWriteStreamRef _writeStream;
    NSInputStream    *_inputStream;
    NSOutputStream   *_outputStream;
        
    char _buffer[128*1024];
    int _offset;
}

@property(nonatomic, assign) NSInteger tag;
@property(nonatomic, weak) id<TcpStreamDelegate> delegate;
@property(nonatomic, assign) BOOL connected;

- (id)initWithHost:(NSString *)host port:(NSInteger)port;
- (void)connect;
- (void)reconnect;
- (void)close;
- (NSInteger)sendData:(NSData *)data;

@end

@protocol TcpStreamDelegate <NSObject>

@required
- (void)tcpStreamDidConnected:(TcpStream *)tcpStream;
- (BOOL)tcpStream:(TcpStream *)tcpStream didReceivedData:(NSData *)data;
- (void)tcpStreamDidRemoteClosedConnection:(TcpStream *)tcpStream;
- (void)tcpStream:(TcpStream *)tcpStream didFailWithError:(NSError *)error;

@end