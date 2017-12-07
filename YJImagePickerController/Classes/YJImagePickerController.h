//
//  YJImagePickerController.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJImagePickerController;
@protocol YJImagePickerControllerDelegate <NSObject>
@optional
- (void)imagePickerController:(YJImagePickerController *)picker didFinishPickingImages:(NSArray*)images;
- (void)imagePickerControllerDidCancel:(YJImagePickerController *)picker;
@end
@interface YJImagePickerController : UINavigationController
@property(nonatomic,weak) id<YJImagePickerControllerDelegate> pickDelegate;
//选择完图片后的回调
@property(nonatomic,copy) void(^didFinishPickingImages)(NSArray*images);
@property(nonatomic,copy) void(^didCancel)(void);

@end
