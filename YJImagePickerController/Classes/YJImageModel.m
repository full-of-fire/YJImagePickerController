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
@end
