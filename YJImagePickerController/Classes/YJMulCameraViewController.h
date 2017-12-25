//
//  YJMulCameraViewController.h
//  YJImagePickController
//
//  Created by 杨杰 on 2017/12/19.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJMulCameraViewController;
@protocol YJMulCameraViewController <NSObject>
@optional
- (void)mulCameraViewController:(YJMulCameraViewController *)mulCamera didFinishTakeImages:(NSArray*)images;
- (void)mulCameraViewControllerDidCancel:(YJMulCameraViewController*)mulCamera;
@end
@interface YJMulCameraViewController : UIViewController
@property(weak,nonatomic) id<YJMulCameraViewController> delegate;
@property(copy,nonatomic) void(^didFinishTakeImagesBlock)(NSArray*images);
@property(copy,nonatomic) void(^didCancelBlock)();
@end
