//
//  YJViewController.m
//  YJImagePickerController
//
//  Created by full-of-fire on 12/07/2017.
//  Copyright (c) 2017 full-of-fire. All rights reserved.
//

#import "YJViewController.h"
#import "YJImagePickerController-Prefix.pch"
#import <YJImagePickerController/YJImagePickerController.h>
#import <YJImagePickerController/YJImagePickerController.h>
#import <AVFoundation/AVFoundation.h>
@interface YJViewController ()

@end

@implementation YJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self showImagePicker];
}


- (void)showImagePicker{
    YJImagePickerController *albumsList = [YJImagePickerController new];
    
    albumsList.didFinishPickingImages = ^(NSArray *images) {
        
        NSLog(@"====images = %@",images);
    };
    albumsList.didCancel = ^{
        
        NSLog(@"取消选择");
    };
    
    
    
    [self presentViewController:albumsList animated:YES completion:nil];
}

@end
