//
//  CBResultsTableViewController.h
//  Carbook
//
//  Created by etnc lab on 5/8/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CBResultsTableViewCell.h"
#import "CBRouteViewController.h"

@interface CBResultsTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *mapItems;
@end
