//
//  PLServer.h
//  PlanktonServerSDK
//
//  Created by 蒯 江華 on 13-2-13.
//  Copyright (c) 2013年 蒯 江華. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TcpStream.h"
#import "NSMutableDictionary+PLPackage.h"
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

@end

@interface PLServer : NSObject<TcpStreamDelegate>

@property(nonatomic,weak)id<PLServerDelegate>delegate;

//Setting
+(void)setLogicType:(short)type logicVersion:(short)version;
+(void)setServerIP:(NSString*)ip port:(NSInteger)port;

+(id)shareInstance;
-(void)openLongConnection;
-(void)closeConnection;
-(void)sendDataWithString:(NSString*)jsonString;
-(void)sendDataWithDic:(NSDictionary*)jsonDic;

@end
