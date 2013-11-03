//
//  TcpStream.m
//  test
//
//  Created by wupeng on 12-12-22.
//  Copyright (c) 2012年 wupeng. All rights reserved.
//

#import "TcpStream.h"
#import "Protocal.h"

NSString *NSStreamEventString[17] = {
    @"NSStreamEventNone",               // [0]
    @"NSStreamEventOpenCompleted",      // [1]
    @"NSStreamEventHasBytesAvailable",  // [2]
    @"",                                // [3]
    @"NSStreamEventHasSpaceAvailable",  // [4]
    @"",                                // [5]
    @"",                                // [6]
    @"",                                // [7]
    @"NSStreamEventErrorOccurred",      // [8]
    @"",                                // [9]
    @"",                                // [10]
    @"",                                // [11]
    @"",                                // [12]
    @"",                                // [13]
    @"",                                // [14]
    @"",                                // [15]
    @"NSStreamEventEndEncountered",     // [16]
};

@implementation TcpStream
@synthesize delegate;

- (id)initWithHost:(NSString *)host port:(NSInteger)port
{
    self = [super init];
    if (self) {
        _host = [host copy];
        _port = port;
    }
    return self;
}

- (void)dealloc
{
    [_inputStream close];
    [_outputStream close];
    if (_readStream) {
        CFRelease(_readStream);
        _readStream = nil;
    }
    if (_writeStream) {
        CFRelease(_writeStream);
        _writeStream = nil;
    }
}

- (void)connect
{
    [self close];
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)_host, (UInt32)_port, &_readStream, &_writeStream);
    
    _inputStream = (__bridge NSInputStream *)_readStream;
    _outputStream = (__bridge NSOutputStream *)_writeStream;
    
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
    [_outputStream open];    
}

- (void)reconnect
{
    [self connect];
}

- (void)close
{
    if (_inputStream) {
        [_inputStream close];
        _inputStream = nil;
    }
    if (_outputStream) {
        [_outputStream close];
        _outputStream = nil;
    }
    if (_readStream) {
        CFRelease(_readStream);
        _readStream = nil;
    }
    if (_writeStream) {
        CFRelease(_writeStream);
        _writeStream = nil;
    }
}

- (NSInteger)sendData:(NSData *)data
{
    return [_outputStream write:(uint8_t *)data.bytes maxLength:data.length];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    NSLog(@"%@", NSStreamEventString[eventCode]);
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
        {
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            if (aStream == _inputStream) {
                if (_offset == 0) {
                    _offset = [_inputStream read:(uint8_t *)_buffer maxLength:sizeof(_buffer)];
                } else {
                    _offset += [_inputStream read:(uint8_t *)&_buffer[_offset] maxLength:sizeof(_buffer) - _offset];
                }
                
                NSData *data = [NSData dataWithBytes:_buffer length:_offset];
                if ([delegate tcpStream:self didReceivedData:data]) {
                    _offset = 0;
                }
            }
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            if (aStream == _outputStream) {
                if (_connected == NO) {
                    _connected = YES;
                    [delegate tcpStreamDidConnected:self];
                }
            }
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            if (aStream == _outputStream) {
                [delegate tcpStream:self didFailWithError:[_inputStream streamError]];
            }
        }
        case NSStreamEventEndEncountered:
        {
            if (aStream == _inputStream) {
                _connected = NO;
                [delegate tcpStreamDidRemoteClosedConnection:self];
            }
        }
        default:
            break;
    }
}

@end
