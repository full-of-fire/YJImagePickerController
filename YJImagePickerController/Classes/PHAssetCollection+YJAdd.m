//
//  PHAssetCollection+YJAdd.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "PHAssetCollection+YJAdd.h"
#import "PHAsset+YJAdd.h"
@implementation PHAssetCollection (YJAdd)

- (void)yj_requestLastImageWithTargetSize:(CGSize)targetSize resultHandler:(void(^)(UIImage*result,NSDictionary*info))resultHandler{
    [self yj_requstImageWithTargetSize:targetSize index:([self yj_numerOfAsset] - 1) resultHandler:resultHandler];
}

- (void)yj_requstImageWithTargetSize:(CGSize)targetSize index:(NSUInteger)index resultHandler:(void(^)(UIImage*result,NSDictionary*info))resultHandler {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:self options:fetchOptions];
    if (!result.count) {
        resultHandler(nil,nil);
        return;
    }
    PHAsset *asset = nil;
    if (result.count== [self yj_numerOfAsset]) {
        asset = [result lastObject];
    }
    else{
        asset = [result objectAtIndex:index];
    }
    [asset yj_requestImageForTargetSize:targetSize resultHandler:resultHandler];
}

- (NSUInteger)yj_numerOfAsset {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:self options:fetchOptions];
    return result.count;
}

@end
