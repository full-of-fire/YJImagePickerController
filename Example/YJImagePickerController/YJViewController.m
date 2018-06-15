//
//  YJViewController.m
//  YJImagePickerController
//
//  Created by full-of-fire on 12/07/2017.
//  Copyright (c) 2017 full-of-fire. All rights reserved.
//

#import "YJViewController.h"
//#import "YJImagePickerController-Prefix.pch"
#import <YJImagePickerController/YJImagePickerController.h>
#import <YJImagePickerController/YJImagePickerController.h>
#import <YJImagePickerController/YJImagePrewViewController.h>
#import <YJImagePickerController/YJImageModel.h>
#import <YJImagePickerController/YJMulCameraViewController.h>
//#import <YJImagePickerController/YJImagePicker.h>



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
//    [self showImagePicker];
//    [self showPreViewImage];
//    [self showMulCamera];
}
- (IBAction)testAction:(UIButton *)sender {
//    [self showMulCamera];
    [self showImagePicker];
}

- (void)showPreViewImage {
    
    YJImagePrewViewController *preView = [YJImagePrewViewController new];
    
    YJImageModel *model = [YJImageModel new];
    model.imageURL = [NSURL URLWithString:@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=4115900726,1603453606&fm=173&s=38B75894034017490198B48F030070C8&w=218&h=146&img.JPEG"];    
    preView.photoList = @[model,model,model,model,model,model];
    [self presentViewController:preView animated:YES completion:nil];
    
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

- (void)showMulCamera {
    YJMulCameraViewController *camera = [YJMulCameraViewController new];
    camera.didFinishTakeImagesBlock = ^(NSArray *images) {
      
        NSLog(@"====images = %@",images);
    };
    camera.didCancelBlock = ^{
        NSLog(@"取消");
    };
    [self presentViewController:camera animated:YES completion:nil];
}

@end
