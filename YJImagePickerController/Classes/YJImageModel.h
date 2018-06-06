//
//  YJImageModel.h
//  YJImagePickerController
//
//  Created by 杨杰 on 2017/12/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YJImageInputProtocol.h"
@interface YJImageModel : NSObject<YJImageInputProtocol>
@property(strong,nonatomic) UIImage *originImage;
@property(strong,nonatomic) PHAsset *imageAsset;
@property(strong,nonatomic) NSURL *imageURL;

- (instancetype)initWithAsset:(PHAsset*)asset;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithImage:(UIImage*)image;



@end
