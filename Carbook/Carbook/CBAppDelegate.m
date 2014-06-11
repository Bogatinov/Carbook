//
//  CBAppDelegate.m
//  Carbook
//
//  Created by Vladimir Trajkovikj on 4/24/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import "CBAppDelegate.h"
#import "CBrssParser.h"
#import "CBAppDelegate.h"
#import "CBCar.h"
#import <FacebookSDK/FacebookSDK.h>

@interface CBAppDelegate()
@end

@implementation CBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}
-(void) pustiBaranje:(NSString *)make model:(NSString *)mod year:(int)god
{
    NSMutableString * str= [NSMutableString string];
    [str appendString:@"http://www.fueleconomy.gov/ws/rest/ympg/shared/vehicles?make="];
    make = [make stringByReplacingOccurrencesOfString:@" "
                                           withString:@"%20"];
    [str appendString:make];
    [str appendString:@"&model="];
    mod = [mod stringByReplacingOccurrencesOfString:@" "
                                         withString:@"%20"];
    [str appendString:mod];
    
    NSURL *url = [[NSURL alloc] initWithString:str];
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    CBrssParser *parser = [[CBrssParser alloc] init];
    parser.year=god;
    [xmlparser setDelegate:parser];
    
    BOOL success = [xmlparser parse];
    
    if(success){
        NSLog(@"No Errors");
    }
    else{
        NSLog(@"Error Error Error!!!");
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                  }];
    
    return urlWasHandled;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSDate *alertTime = [[NSDate date]
                         dateByAddingTimeInterval:600];
    UIApplication* app = [UIApplication sharedApplication];
    UILocalNotification* notifyAlarm = [[UILocalNotification alloc]
                                        init];
    if (notifyAlarm)
    {
        notifyAlarm.fireDate = alertTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.repeatInterval = 600;
        notifyAlarm.soundName = @"bell_tree.mp3";
        notifyAlarm.alertBody = @"Come back to check new places for traveling.";
        [app scheduleLocalNotification:notifyAlarm];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
