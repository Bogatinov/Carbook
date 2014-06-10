//
//  CBViewController.h
//  Carbook
//
//  Created by Vladimir Trajkovikj on 4/24/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAppDelegate.h"

@interface CBViewController : UIViewController<UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *Make_field;
@property (weak, nonatomic) IBOutlet UITextField *Model_field;
@property (weak, nonatomic) IBOutlet UITextField *Year_Field;
@property (nonatomic, retain) CBAppDelegate *appdelegate;
@property (strong  ,atomic) NSMutableArray * marki;
@property (weak, nonatomic) IBOutlet UIPickerView *marki_dropdown;
@property (weak, nonatomic) IBOutlet UIPickerView *godina_dropdown;
@property (weak, nonatomic) IBOutlet UIPickerView *modeli_dropdown;
@property (strong,atomic) NSMutableArray * modeli;
@property (strong,atomic) NSMutableArray * godini;
@property (strong,atomic) NSString * selektirana_marka;
@property (strong,atomic) NSString * selektirana_godina;
@property (strong,atomic) NSString * selektiran_model;
 @property (strong,atomic) NSString* string_potrosnja ;
@property(nonatomic,retain) NSFileManager *fileMgr;
@property(nonatomic,retain) NSString *homeDir;
@property(nonatomic,retain) NSString *filename;
@property(nonatomic,retain) NSString *filepath;
@end
