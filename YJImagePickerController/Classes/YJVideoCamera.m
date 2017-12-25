//
//  YJVideoCamera.m
//  OpenCV-1
//
//  Created by  谭德林 on 2017/9/18.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJVideoCamera.h"

@interface YJVideoCamera ()
{
    AVCaptureDevice *_inputDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoDataOutput *_videoOutput;
}

@property (nonatomic,weak) UIView * prewView;
@property (nonatomic,strong) UIImageView * focusImageView;
@end

@implementation YJVideoCamera

- (id)init;
{
    if (!(self = [self initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPositon:AVCaptureDevicePositionBack]))
    {
        return nil;
    }
    
    return self;
}
- (instancetype)initWithSessionPreset:(NSString*)sessionPreset cameraPositon:(AVCaptureDevicePosition)cameraPositon{

    if (self = [super init]) {
        
        //1.获取输入设备
        _cameraPosition = cameraPositon;
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            
            if ([device position] == cameraPositon) {
                _inputDevice = device;
            }
        }
        
        if (!_inputDevice) {
            return nil;
        }
        
        //2.创建session
        _captureSession = [[AVCaptureSession alloc] init];
        
        //3.添加viedeo input
        [_captureSession beginConfiguration];
        NSError *error = nil;
        _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_inputDevice error:&error];
        if(error){
            return nil;
        }
        if ([_captureSession canAddInput:_videoInput]) {
            [_captureSession addInput:_videoInput];
        }
        
        // 添加 video output
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
        
        [_videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        
        
        [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(0, 0)];
        if ([_captureSession canAddOutput:_videoOutput]) {

            [_captureSession addOutput:_videoOutput];
        }
        
        _sessionPreset = sessionPreset;
        [_captureSession setSessionPreset:_sessionPreset];
        
        [_captureSession commitConfiguration];
        
        
    }
    return self;
}
- (void)dealloc {
    [self stopCameraCapture];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

    if (self.delegate&&[self.delegate respondsToSelector:@selector(videoCamera:didOutputSampleBuffer:)]) {
        [self.delegate videoCamera:self didOutputSampleBuffer:sampleBuffer];
    }
}


#pragma mark - public
- (void)startCameraCaptureInView:(UIView*)preView {
    NSAssert(preView!=nil, @"preView不能为空");
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [preView addGestureRecognizer:singleTap];
    [preView addSubview:self.focusImageView];
    _prewView = preView;
    if (![_captureSession isRunning]) {
        AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        layer.frame = preView.bounds;
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [preView.layer insertSublayer:layer atIndex:0];
        [_captureSession startRunning];
    }
}
- (void)stopCameraCapture {

    if ([_captureSession isRunning]) {
        
        [_captureSession stopRunning];
    }
}


- (void)rotateCamera
{
 
    NSError *error;
    AVCaptureDeviceInput *newVideoInput;
    AVCaptureDevicePosition currentCameraPosition = [[_videoInput device] position];
    
    if (_cameraPosition == AVCaptureDevicePositionBack)
    {
        _cameraPosition = AVCaptureDevicePositionFront;
    }
    else
    {
        _cameraPosition = AVCaptureDevicePositionBack;
    }
    
    AVCaptureDevice *backFacingCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == _cameraPosition)
        {
            backFacingCamera = device;
        }
    }
    newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:backFacingCamera error:&error];
    
    if (newVideoInput != nil)
    {
        [_captureSession beginConfiguration];
        
        [_captureSession removeInput:_videoInput];
        if ([_captureSession canAddInput:newVideoInput])
        {
            [_captureSession addInput:newVideoInput];
            _videoInput = newVideoInput;
        }
        else
        {
            [_captureSession addInput:_videoInput];
        }
        //captureSession.sessionPreset = oriPreset;
        [_captureSession commitConfiguration];
    }
    
    _inputDevice = backFacingCamera;

}

#pragma mark - actions
- (void)singleTapAction:(UITapGestureRecognizer*)tap{
    CGPoint point = [tap locationInView:self.prewView];
    CGSize size = self.prewView.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([_inputDevice lockForConfiguration:&error]) {
        //对焦模式和对焦点
        if ([_inputDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [_inputDevice setFocusPointOfInterest:focusPoint];
            [_inputDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        //曝光模式和曝光点
        if ([_inputDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [_inputDevice setExposurePointOfInterest:focusPoint];
            [_inputDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [_inputDevice unlockForConfiguration];
        //设置对焦动画
        self.focusImageView.center = point;
        self.focusImageView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.focusImageView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.focusImageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.focusImageView.hidden = YES;
            }];
        }];
        
    }
}
#pragma mark - setter
- (void)setFlashModeOn:(BOOL)on {
    AVCaptureFlashMode flashMode;
    if (on) {
        flashMode = AVCaptureFlashModeOn;
    }
    else{
        flashMode = AVCaptureFlashModeOff;
    }
    [_inputDevice lockForConfiguration:nil];
    if ([_inputDevice isFlashModeSupported:flashMode]) {
        [_inputDevice setFlashMode:flashMode];
    }
    [_inputDevice unlockForConfiguration];
}

#pragma mark - getter
- (UIImageView*)focusImageView {
    if (_focusImageView == nil) {
        _focusImageView = [[UIImageView alloc] init];
        _focusImageView.image = [UIImage imageNamed:@"camera_ Focusing"];
        _focusImageView.frame = CGRectMake(0, 0, _focusImageView.image.size.width, _focusImageView.image.size.height);
        _focusImageView.hidden = YES;
    }
    return _focusImageView;
}



@end
