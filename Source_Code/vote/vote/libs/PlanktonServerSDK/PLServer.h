//
//  PLServer.h
//  PlanktonServerSDK
//
//  Created by 蒯 江華 on 13-2-13.
//  Copyright (c) 2013年 蒯 江華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "NSMutableDictionary+PLPackage.h"
#import "NSDictionary+PLPackage.h"
#import "JSONKit.h"

/*The main class to use to communicate with the Plankton server
 *There are two way to communicate with server.
 *1.long conection
 *2.short connection
 */

@class PLServer;

@protocol PLServerDelegate <NSObject>

@required
- (void)plServer:(PLServer*)plServer didReceivedJSONString:(id)jsonObejct;
- (void)plServer:(PLServer *)plServer failedWithError:(NSError *)error;

@optional
- (void)connectionClosed:(PLServer *)plServer;

@end

@interface PLServer : NSObject<AsyncSocketDelegate>

@property(nonatomic,weak)id<PLServerDelegate>delegate;

//Setting
- (void)setLogicType:(short)type logicVersion:(short)version;
- (void)setServerIP:(NSString*)ip port:(NSInteger)port;
- (void)setKey:(NSString*)key;
- (void)setEncryptMode:(BOOL)isEncrypt;

+ (id)shareInstance;
- (void)openLongConnection;
- (void)closeConnection;
- (void)sendDataWithString:(NSString*)jsonString;
- (void)sendDataWithDic:(NSDictionary*)jsonDic;

@end
