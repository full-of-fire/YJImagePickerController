//
//  YJUImageStillCamera.m
//  OpenCV-1
//
//  Created by  谭德林 on 2017/9/19.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJUImageStillCamera.h"

@implementation YJUImageStillCamera
- (instancetype)initWithSessionPreset:(NSString *)sessionPreset cameraPositon:(AVCaptureDevicePosition)cameraPositon {

    if (!(self = [super initWithSessionPreset:sessionPreset cameraPositon:cameraPositon])) {
        
        return nil;
    }
    [self.captureSession beginConfiguration];
    _photoOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([self.captureSession canAddOutput:_photoOutput]) {
        
        [self.captureSession addOutput:_photoOutput];
    }
//    [_photoOutput setOutputSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [_photoOutput setOutputSettings:outputSettings];//输出设置
    
    [self.captureSession commitConfiguration];
    
    return self;
}

- (void)takePhotoImageWithComplete:(void(^)(UIImage*originImage,NSError*error))complete {

    if (![self.captureSession isRunning]) {
        complete?complete(nil,[NSError errorWithDomain:@"init error" code:-1 userInfo:nil]):nil;
        return;
    }
    
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
    if(!captureConnection){
        complete?complete(nil,[NSError errorWithDomain:@"init error" code:-1 userInfo:nil]):nil;
        return;
    }
    [_photoOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
       
        
        if (error) {
            complete?complete(nil,error):nil;
            return ;
        }
        NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        if (!imageData) {
            complete?:complete(nil,[NSError errorWithDomain:@"image data error" code:-1 userInfo:nil]);
            return;
        }
        UIImage *image=[UIImage imageWithData:imageData];
        complete?complete(image,nil):nil;
        
    }];
}

@end
