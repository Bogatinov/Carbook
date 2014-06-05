//
//  CBStepsTableViewController.m
//  Carbook
//
//  Created by etnc lab on 6/1/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import "CBStepsTableViewController.h"
#import <MapKit/MapKit.h>

@interface CBStepsTableViewController ()

@end

@implementation CBStepsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated {
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration: 0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _stepItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"stepCell";
    CBStepTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                    forIndexPath:indexPath];
    
    long row = [indexPath row];
    
    MKRouteStep *item = _stepItems[row];
    
    cell.instructionLabel.text = item.instructions;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.02f km", item.distance / 1000.0];
    
    return cell;
}


@end
