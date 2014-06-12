//
//  CBMapSampleViewController.h
//  Carbook
//
//  Created by etnc lab on 5/8/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CBMapSampleViewController : UIViewController
<CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *stepsToDestination;
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *matchingItems;
@property (strong, nonatomic) NSArray *stepItems;
@property (strong, nonatomic) NSString *potrosnja;
- (IBAction)changeMapType:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)useCamera:(id)sender;
- (IBAction)shareImage:(id)sender;
@end
