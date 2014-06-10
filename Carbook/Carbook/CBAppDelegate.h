//
//  CBAppDelegate.h
//  Carbook
//
//  Created by Vladimir Trajkovikj on 4/24/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong,nonatomic) NSMutableArray * cars;
- (void)pustiBaranje:(NSString *)make model:(NSString *)mod year:(int  )god;
@end
