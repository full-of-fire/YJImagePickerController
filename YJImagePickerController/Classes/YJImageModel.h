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
@property(assign,nonatomic,getter=isSelected) BOOL selected;
@property(assign,nonatomic) NSUInteger selectIndex;
- (instancetype)initWithAsset:(PHAsset*)asset;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithImage:(UIImage*)image;

+ (instancetype)imageModelWithAsset:(PHAsset*)asset;
+ (instancetype)imageModelWithURL:(NSURL*)URL;
+ (instancetype)imageModelWithImage:(UIImage*)image;



@end
