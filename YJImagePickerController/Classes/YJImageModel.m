//
//  YJImageModel.m
//  YJImagePickerController
//
//  Created by 杨杰 on 2017/12/26.
//

#import "YJImageModel.h"

@implementation YJImageModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageAsset = nil;
        _imageURL = nil;
        _originImage = nil;
    }
    return self;
}

- (instancetype)initWithAsset:(PHAsset*)asset {
    self = [super init];
    if (self) {
        _imageAsset = asset;
    }
    return self;
}
- (instancetype)initWithURL:(NSURL*)URL {
    self = [super init];
    if (self) {
        _imageURL = URL;
    }
    return self;
}
- (instancetype)initWithImage:(UIImage*)image {
    self = [super init];
    if (self) {
        _originImage = image;
    }
    return self;
}

@end
