//
//  PHAsset+YJAdd.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "PHAsset+YJAdd.h"
#import "UIImage+YJAdd.h"
@implementation PHAsset (YJAdd)

- (void)yj_requestOriginImage:(void(^)(UIImage* result,NSDictionary *info))resultHandler{
    [self yj_requestImageForTargetSize:PHImageManagerMaximumSize resultHandler:resultHandler];
}

- (void)yj_requestImageForTargetSize:(CGSize)targetSize resultHandler:(void(^)(UIImage* result,NSDictionary *info))resultHandler{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = NO;
    [[PHImageManager defaultManager] requestImageForAsset:self targetSize:targetSize contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultHandler) {
                resultHandler(result,info);
            }
        });
    }];
}

- (UIImage*)yj_originImage{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    __block UIImage *originImage;
    [[PHImageManager defaultManager] requestImageForAsset:self targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        //修复iphon5图片不能加载的问题
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            originImage = result;
        }
        // Download image from iCloud / 从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
            PHImageRequestOptions *downOption = [[PHImageRequestOptions alloc]init];
            downOption.networkAccessAllowed = YES;
            downOption.synchronous = YES;
            downOption.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:self options:downOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                originImage = resultImage;
                
            }];
        }
        
    }];
    return originImage;
}

- (UIImage*)yj_thumbnailImageTargetSize:(CGSize)size{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    __block UIImage *originImage;
    [[PHImageManager defaultManager] requestImageForAsset:self targetSize:size contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        //修复iphon5图片不能加载的问题
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            originImage = result;
        }
        // Download image from iCloud / 从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
            PHImageRequestOptions *downOption = [[PHImageRequestOptions alloc]init];
            downOption.networkAccessAllowed = YES;
            downOption.synchronous = YES;
            downOption.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:self options:downOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                resultImage = [resultImage yj_thumbnailImageTargetSize:size];
                originImage = resultImage;
                
            }];
        }
        
    }];
    return originImage;
}





- (void)yj_getOriginImageSize:(void(^)(NSString*resultString))resultHandler{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.version = PHImageRequestOptionsVersionOriginal;
    option.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:self options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        unsigned long size = imageData.length / 1024;
        NSString *sizeString = [NSString stringWithFormat:@"%liK", size];
        if (size > 1024) {
            NSInteger integral = size / 1024.0;
            NSInteger decimal = size % 1024;
            NSString *decimalString = [NSString stringWithFormat:@"%li",decimal];
            if(decimal > 100){ //取两位
                decimalString = [decimalString substringToIndex:2];
            }
            sizeString = [NSString stringWithFormat:@"%li.%@M", integral, decimalString];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultHandler) {
                resultHandler(sizeString);
            }
        });
    }];

}
@end
