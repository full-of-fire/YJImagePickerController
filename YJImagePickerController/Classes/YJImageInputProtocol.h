//
//  YJImageInput.h
//  Pods-YJImagePickerController_Example
//
//  Created by 杨杰 on 2017/12/26.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>
@protocol YJImageInputProtocol <NSObject>
@optional
@property(strong,nonatomic) UIImage *originImage;
@property(strong,nonatomic) PHAsset *imageAsset;
@property(strong,nonatomic) NSURL *imageURL;
@end
