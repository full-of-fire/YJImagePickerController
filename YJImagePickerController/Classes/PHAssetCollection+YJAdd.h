//
//  PHAssetCollection+YJAdd.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAssetCollection (YJAdd)
- (void)yj_requstImageWithTargetSize:(CGSize)targetSize index:(NSUInteger)index resultHandler:(void(^)(UIImage*result,NSDictionary*info))resultHandler;
- (void)yj_requestLastImageWithTargetSize:(CGSize)targetSize resultHandler:(void(^)(UIImage*result,NSDictionary*info))resultHandler;
- (NSUInteger)yj_numerOfAsset;
@end
