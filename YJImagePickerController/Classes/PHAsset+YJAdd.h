//
//  PHAsset+YJAdd.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (YJAdd)
// 同步方法
- (UIImage*)yj_originImage;
- (UIImage*)yj_thumbnailImageTargetSize:(CGSize)size;

// 异步方法
- (void)yj_requestImageForTargetSize:(CGSize)targetSize resultHandler:(void(^)(UIImage* result,NSDictionary *info))resultHandler;
- (void)yj_requestOriginImage:(void(^)(UIImage* result,NSDictionary *info))resultHandler;
- (void)yj_getOriginImageSize:(void(^)(NSString*resultString))resultHandler;
@end
