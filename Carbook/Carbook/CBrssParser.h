//
//  CBrssParser.h
//  Carbook
//
//  Created by Aleksandar Stojmenski on 4/24/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

@class CBCar,CBAppDelegate;
#import <Foundation/Foundation.h>

@interface CBrssParser : NSObject <NSXMLParserDelegate>{
    
    CBCar *car;
    CBAppDelegate *appdelegate;
    
    NSMutableString *curElem;
    
}

@property (nonatomic, retain) CBCar *book;
@property (nonatomic, retain) CBAppDelegate *appdelegate;
@property (nonatomic, retain) NSMutableString *curElem;
@property (nonatomic, assign) int year;
//- (CBrssParser *) initXMLParser;

@end


