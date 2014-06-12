//
//  CBViewController.m
//  Carbook
//
//  Created by Vladimir Trajkovikj on 4/24/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import "CBViewController.h"
#import "CbAppDelegate.h"
#import "CBCar.h"
#import "CBMapSampleViewController.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface CBViewController ()
@property (nonatomic, strong) Reachability* internetReachable;
@property (nonatomic, strong) Reachability* hostReachable;
@property(nonatomic, assign) BOOL internetActive;
@property(nonatomic, assign) BOOL hostActive;
@end

@implementation CBViewController
@synthesize Make_field;
@synthesize Model_field;
@synthesize Year_Field;
@synthesize appdelegate;
@synthesize marki;
@synthesize marki_dropdown;
@synthesize modeli_dropdown;
@synthesize godina_dropdown;
@synthesize godini;
@synthesize modeli;
@synthesize selektiran_model;
@synthesize selektirana_marka;
@synthesize selektirana_godina;
@synthesize hostActive;
@synthesize internetActive;

-(void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    _internetReachable = [Reachability reachabilityForInternetConnection];
    [_internetReachable startNotifier];
    _hostReachable = [Reachability reachabilityWithHostName:@"www.fueleconomy.gov"];
    [_hostReachable startNotifier];
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    NetworkStatus internetStatus = [_internetReachable currentReachabilityStatus];
    if (internetStatus == NotReachable) {
        self.internetActive = NO;
    } else {
        self.internetActive = YES;
    }
    
    NetworkStatus hostStatus = [_hostReachable currentReachabilityStatus];
    if (hostStatus == NotReachable) {
        self.hostActive = NO;
    } else {
        self.hostActive = YES;
    }
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
-(void)viewDidAppear:(BOOL)animated {
    if (animated) {
        if([self internetActive] == NO) {
            UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc] initWithTitle:@"No internet connection" message:@"You forgot to turn on the Internet. Go to Settings, we will be waiting" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [noInternetConnectionAlert show];
        }
        else if([self hostActive] == NO) {
            UIAlertView *hostIsDownAlert = [[UIAlertView alloc] initWithTitle:@"Our magic broke" message:@"You discovered our magic tricks. Our magician is taking a break. Check back later " delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [hostIsDownAlert show];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *temp=[self readFromFile];
    if([temp isEqual: @"error"])
    {
        
    }
    else{
        selektirana_godina=@"2014";
        [self performSegueWithIdentifier:@"Carbook" sender:self];
    }
    marki_dropdown.delegate=self;
    godina_dropdown.delegate=self;
    modeli_dropdown.delegate=self;
    godini= [[NSMutableArray alloc] init];
    modeli= [[NSMutableArray alloc] init];
    for( int i=2014;i>=1984;i--)
    {
        [godini addObject:[NSString stringWithFormat:@"%u",i]];
    }
    [godina_dropdown reloadAllComponents];
    [self refresh];
}

-(NSString *) readFromFile
{
    NSError *error;
    NSString *filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"carbook.data"];
    NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUnicodeStringEncoding error:&error];
    
    if(!txtInFile)
    {
       return @"error";
    }
    return txtInFile;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {

    @try{
        if(pickerView==marki_dropdown)
        {
            selektirana_marka=[self.marki objectAtIndex:row];
            [self refresh_modeli];
        }
        else if(pickerView==godina_dropdown)
        {
            selektirana_godina=[self.godini objectAtIndex:row];
            NSString *temp_selektirana_marka=selektirana_marka;
            
            [self refresh];
            int selected_index=-1;
            
            for(int i=0;i<[marki count]-2;i++)
            {
               
            if([temp_selektirana_marka isEqualToString:[self.marki objectAtIndex:i]])
                selected_index=i;
            }
            if(selected_index!=-1){
                [marki_dropdown selectRow:selected_index inComponent:0 animated:NO];
            }
        }
        else
        {
            selektiran_model=[self.modeli objectAtIndex:row];
    
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:%@",exception);
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView==marki_dropdown)
        return [self.marki count];
    else if(pickerView==godina_dropdown)
        return [self.godini count];
    else return [self.modeli count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView==marki_dropdown)
        return [self.marki objectAtIndex:row];
    else if(pickerView==godina_dropdown)
        return [self.godini objectAtIndex:row];
    else if(pickerView==modeli_dropdown)return [self.modeli objectAtIndex:row];
    else return @"@@@";

}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//xml parsing
-(NSString *)nodeName:(NSString *)node XMLData:(NSString *)full
{
    NSString *between;
    NSRange startRange = [full rangeOfString:[NSString stringWithFormat:@"<%@>", node]];
    int start = (int)(startRange.location + startRange.length);
    int end = (int)[full rangeOfString:[NSString stringWithFormat:@"</%@>", node]].location;
    between = [full substringWithRange:NSMakeRange(start, (end-start))];
    return between;
}
- (IBAction)yearEndEdit:(id)sender {
    [self refresh];
    
}
-(NSString *)GetDocumentDirectory{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if(selektirana_godina==nil||selektirana_marka==nil||selektiran_model==nil) {
        return NO;
    }
    [((CBAppDelegate *)[[UIApplication sharedApplication] delegate]) pustiBaranje:selektirana_marka model:selektiran_model year: [selektirana_godina intValue]];
    appdelegate = (CBAppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appdelegate.cars count]==0)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Couldn't find your consumtion data!"
                                                          message:@"Check the starting year of the model you selected, and try again"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        return NO;
    }

    return YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    CBCar *car= [appdelegate.cars objectAtIndex:0];
    NSString* consumption = [NSString stringWithFormat:@"%.2fl/100km", 235.214/car.comb08];
    NSError *err;
    NSString *filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"carbook.data"];
    BOOL ok = [consumption writeToFile:filepath atomically:YES encoding:NSUnicodeStringEncoding error:&err];
    if (!ok) {
        NSLog(@"Error writing file at %@\n%@",filepath, [err localizedFailureReason]);
    }
    CBMapSampleViewController *secView = [segue destinationViewController];
    secView.potrosnja = consumption;
}



- (void) refresh{
    if([self internetActive] && [self hostActive]) {
        NSMutableString * str= [NSMutableString string];
        if(selektirana_godina!=nil){
            [str appendString:@"http://www.fueleconomy.gov/ws/rest/vehicle/menu/make?year="];
            [str appendString:selektirana_godina];}
        else{
            [str appendString:@"http://www.fueleconomy.gov/ws/rest/vehicle/menu/make?year=2013"];

        }
        NSURL *URL = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
        //  Request the url and store the response into NSData
        NSData *data = [NSData dataWithContentsOfURL:URL];
    
        NSString *response = [self nodeName:@"menuItems" XMLData:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
        NSMutableArray *tempHeadlines = [[NSMutableArray alloc] init];
        NSMutableArray *tempMakes = [[NSMutableArray alloc] init];
        while ([response rangeOfString:@"menuItem"].location != NSNotFound){
            NSString *tempWhole = [self nodeName:@"menuItem" XMLData:response];
            [tempHeadlines addObject:[self nodeName:@"text" XMLData:tempWhole]];
            [tempMakes addObject:[NSString stringWithFormat:@"%@",[self nodeName:@"text" XMLData:tempWhole]]];
            NSString *fullContents = [NSString stringWithFormat:@"<menuItem>%@</menuItem>", tempWhole];
            response = [response stringByReplacingOccurrencesOfString:fullContents withString:@""];
        }
        self.marki = tempHeadlines;
        [marki_dropdown reloadAllComponents];
    }
}

- (void) refresh_modeli{
    NSMutableString * str= [NSMutableString string];
    if(selektirana_marka!=nil&&selektirana_godina!=nil){
        [str appendString:@"http://www.fueleconomy.gov/ws/rest/vehicle/menu/model?year="];
        [str appendString:selektirana_godina];
        [str appendString:@"&make="];
        [str appendString:selektirana_marka];
    }
    else{
        return;
        
    }
    
    NSURL *URL = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    //  Request the url and store the response into NSData
    NSData *data = [NSData dataWithContentsOfURL:URL];
    
    NSString *response = [self nodeName:@"menuItems" XMLData:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
    NSMutableArray *tempHeadlines = [[NSMutableArray alloc] init];
    NSMutableArray *tempMakes = [[NSMutableArray alloc] init];
    while ([response rangeOfString:@"menuItem"].location != NSNotFound){
        NSString *tempWhole = [self nodeName:@"menuItem" XMLData:response];
        [tempHeadlines addObject:[self nodeName:@"text" XMLData:tempWhole]];
        [tempMakes addObject:[NSString stringWithFormat:@"%@",[self nodeName:@"text" XMLData:tempWhole]]];
        NSString *fullContents = [NSString stringWithFormat:@"<menuItem>%@</menuItem>", tempWhole];
        response = [response stringByReplacingOccurrencesOfString:fullContents withString:@""];
    }
    self.modeli = tempHeadlines;
    [modeli_dropdown reloadAllComponents];
}

@end
