//
//  CBRouteViewController.h
//  Carbook
//
//  Created by etnc lab on 5/8/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CBRouteViewController : UIViewController
<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *routeMap;
@property (strong, nonatomic) MKMapItem *destination;
@end
