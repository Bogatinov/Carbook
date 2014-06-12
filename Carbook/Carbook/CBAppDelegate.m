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
    
    [xmlparser parse];
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

@end
