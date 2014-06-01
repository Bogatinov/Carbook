//
//  CBCameraSharer.h
//  Carbook
//
//  Created by etnc lab on 6/1/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBCameraSharer : NSObject
@property BOOL newMedia;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end
