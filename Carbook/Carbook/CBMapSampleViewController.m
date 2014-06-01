//
//  CBMapSampleViewController.m
//  Carbook
//
//  Created by etnc lab on 5/8/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import "CBMapSampleViewController.h"
#import <MapKit/MapKit.h>
#import "CBCameraSharer.h"
#import "CBStepsTableViewController.h"

@interface CBMapSampleViewController ()
@property (nonatomic,assign) CLLocationCoordinate2D destination;
@end

@implementation CBMapSampleViewController
@synthesize locationManager,mapView, destination, stepsToDestination, stepItems;

- (void) initialize{
    self.lastLocation = nil;
    self.locationManager = [[CLLocationManager alloc] init];
    [locationManager setDistanceFilter:10];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager setDelegate:self];
    
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        [self initialize];
    }
    return self;
}

- (id) init{
    if (self = [super init]){
        [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        [self initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.showsUserLocation = YES;
    [locationManager startUpdatingLocation];
    [mapView setDelegate:self];
    CLLocationCoordinate2D userLocation = locationManager.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation, 20000, 20000);
    [mapView setRegion:region animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction) useCamera:(id)sender
{
    CBCameraSharer *camera = [[CBCameraSharer alloc] init];
    [self presentViewController:camera.imagePicker
                       animated:YES completion:nil];
}


- (IBAction)shareImage:(id)sender {
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
    [mapView removeAnnotations:[mapView annotations]];
    [self performSearch];
}

- (void) performSearch {
    MKLocalSearchRequest *request =
    [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = _searchText.text;
    request.region = mapView.region;
    
    _matchingItems = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search =
    [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse
                                         *response, NSError *error) {
        if (response.mapItems.count == 0) {
            stepsToDestination.enabled = NO;
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Nothing found" message:@"That place does not exists" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [view show];
        }
        else
            for (MKMapItem *item in response.mapItems)
            {
                [_matchingItems addObject:item];
                MKPointAnnotation *annotation =
                [[MKPointAnnotation alloc]init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                annotation.subtitle = item.phoneNumber;
                [mapView addAnnotation:annotation];
                [mapView setShowsUserLocation:YES];
            }
        
        
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - CLLocationManagerDelegate Methods
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
}

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    mapView.centerCoordinate =
    userLocation.location.coordinate;
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    double gpsSpeed = newLocation.speed;
    
    if(oldLocation != nil)
    {
        
        CLLocationDistance distanceChange = [newLocation getDistanceFrom:oldLocation];
        NSTimeInterval sinceLastUpdate = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
        double calculatedSpeed = distanceChange / sinceLastUpdate;
    }
    if(gpsSpeed > 0) {
        _speedLabel.text = [NSString stringWithFormat:@"%.02f m/s", gpsSpeed];
    }
}


#pragma mark -
#pragma mark MKMapView Delegate

- (IBAction)changeMapType:(id)sender {
    if (mapView.mapType == MKMapTypeStandard) {
        mapView.mapType = MKMapTypeSatellite;
    }
    else {
        mapView.mapType = MKMapTypeStandard;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    else
    {
        MKPinAnnotationView *dropPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"venues"];
        UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [disclosureButton addTarget:self action:@selector(getDirections) forControlEvents:UIControlEventTouchUpInside];
    
        dropPin.rightCalloutAccessoryView = disclosureButton;
        dropPin.animatesDrop = YES;
        dropPin.canShowCallout = YES;
    
        return dropPin;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    destination = [[view annotation] coordinate];
}

- (void)getDirections
{
    if(CLLocationCoordinate2DIsValid(destination)) {
        [mapView removeOverlays:mapView.overlays];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
        request.source = [MKMapItem mapItemForCurrentLocation];
        request.destination = [[MKMapItem alloc] initWithPlacemark:placemark];
        request.requestsAlternateRoutes = NO;
        
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:
         ^(MKDirectionsResponse *response, NSError *error) {
             if (error) {
                 stepsToDestination.enabled = NO;
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not reach that far" message:[error localizedFailureReason] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 [alert show];
             } else {
                 MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance ([[locationManager location] coordinate], 3000, 3000);
                 
                 [mapView setRegion:region animated:YES];
                 [self showRoute:response];
             }
         }];
    }
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    stepsToDestination.enabled = YES;
    for (MKRoute *route in response.routes)
    {
        [mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        stepItems = route.steps;
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    
    return renderer;
}

#pragma mark -
#pragma mark Segue to Instructions
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ShowSteps"]) {
        return YES;
    }
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowSteps"]) {
        CBStepsTableViewController *stvc = (CBStepsTableViewController *)segue.destinationViewController;
        stvc.stepItems = stepItems;
    }
}

@end
