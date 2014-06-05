//
//  CBCar.h
//  Carbook
//
//  Created by Aleksandar Stojmenski on 4/24/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBCar : NSObject {
    NSInteger year;
 double comb08;
    NSString *make;
    NSString *model;

}

@property (nonatomic, readwrite) NSInteger year;
@property (nonatomic, readwrite) double comb08;
@property (nonatomic, retain) NSString *make;
@property (nonatomic, retain) NSString *model;



@end
