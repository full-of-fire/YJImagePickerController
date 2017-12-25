//
//  YJUImageStillCamera.h
//  OpenCV-1
//
//  Created by  谭德林 on 2017/9/19.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJVideoCamera.h"

@interface YJUImageStillCamera : YJVideoCamera
@property (nonatomic,strong,readonly) AVCaptureStillImageOutput * photoOutput;
- (void)takePhotoImageWithComplete:(void(^)(UIImage*originImage,NSError*error))complete;
@end
