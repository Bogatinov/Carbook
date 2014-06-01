//
//  CBCameraSharer.m
//  Carbook
//
//  Created by etnc lab on 6/1/14.
//  Copyright (c) 2014 A2. All rights reserved.
//

#import "CBCameraSharer.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation CBCameraSharer
- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            _imagePicker =
            [[UIImagePickerController alloc] init];
            _imagePicker.sourceType =
            UIImagePickerControllerSourceTypeCamera;
            _imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            _imagePicker.allowsEditing = NO;
            _newMedia = YES;
        }
    }
    return self;
}
@end
