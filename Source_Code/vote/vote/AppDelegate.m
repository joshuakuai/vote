//
//  AppDelegate.m
//  vote
//
//  Created by kuaijianghua on 11/3/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "AppDelegate.h"
#import "PLServer.h"
#import "TestFlight.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    //Hide the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    //set the test flight
    [TestFlight takeOff:@"773a0aab-1730-4c9d-ae56-9b25276f6b94"];
    
    //set up the plankton server sdk
    [[PLServer shareInstance] setServerIP:RelServerAdd port:13145];
    [[PLServer shareInstance] setLogicType:CML_PACKAGE_VOTE logicVersion:1];
    [[PLServer shareInstance] setEncryptMode:YES];
    [[PLServer shareInstance] setKey:@"5AFCB1E615360483465E64EE44FD0F68"];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    
    
    return YES;
}


#pragma - mark Push Notification
//Push relate
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *hexString = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"DeviceToken:%@", hexString);
    
    /*
    //send the token to the server
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:UploadToken];
    [dic setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] forKey:@"userid"];
    [dic setObject:hexString forKey:@"tokenid"];
    
    [[PLServer shareInstance] sendDataWithDic:dic];
     */
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Received a push from server...");
}

#pragma - mark Program Lifecycle

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[PLServer shareInstance] closeConnection];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
