//
//  YJVideoCamera.h
//  OpenCV-1
//
//  Created by  谭德林 on 2017/9/18.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@class YJVideoCamera;
@protocol YJVideoCameraDataOutputSampleBufferDelegate <NSObject>
- (void)videoCamera:(YJVideoCamera*)videoCamera didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end
@interface YJVideoCamera : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic,strong,readonly) AVCaptureSession * captureSession;

/**
 eg.AVCaptureSessionPreset640x480
 */
@property(nonatomic,copy,readonly) NSString *sessionPreset;
@property (nonatomic,assign,readonly) AVCaptureDevicePosition cameraPosition;
@property (nonatomic,weak) id<YJVideoCameraDataOutputSampleBufferDelegate> delegate;

- (instancetype)initWithSessionPreset:(NSString*)sessionPreset cameraPositon:(AVCaptureDevicePosition)cameraPositon;
- (void)startCameraCaptureInView:(UIView*)preView;
- (void)stopCameraCapture;
- (void)rotateCamera;
- (void)setFlashModeOn:(BOOL)on;
@end
