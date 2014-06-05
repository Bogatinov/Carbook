//
//  CBrssParser.m
//  Carbook
//
//  Created by Aleksandar Stojmenski on 4/24/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import "CBrssParser.h"
#import "CBAppDelegate.h"
#import "CBCar.h"
@implementation CBrssParser
@synthesize appdelegate,curElem,year;
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
 if([elementName isEqualToString:@"vehicles"]) {
        //Initialize the array.
     if(appdelegate.cars==nil){
         appdelegate = (CBAppDelegate *)[[UIApplication sharedApplication] delegate];
         appdelegate.cars = [[NSMutableArray alloc] init];}
    }
    else if([elementName isEqualToString:@"vehicle"]) {
        
        //Initialize the book.
        car = [[CBCar alloc] init];
        
        //Extract the attribute here.
        
        
       // NSLog(@"Reading id value :%i", car.year);
    }
    
   // NSLog(@"Processing Element: %@", elementName);
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!curElem)
        curElem = [[NSMutableString alloc] initWithString:string];
    else
        [curElem appendString:string];
    
  //  NSLog(@"Processing Value: %@", curElem);
    
}
//- (CBrssParser *) initXMLParser;
//{
// //self=[super init];
//
//    appdelegate = (CBAppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    return self;
//}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"vehicles"])
        return;
    
    if([elementName isEqualToString:@"vehicle"]) {
        if(car.year==year){
            [appdelegate.cars addObject:car];
        }
        
        car = nil;
    }
    else
    {
       if([car respondsToSelector:NSSelectorFromString(elementName)])
        [car setValue:curElem forKey:elementName];
        
        
    }
    
    curElem = nil;
}

@end
