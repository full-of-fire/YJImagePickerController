//
//  UIView+YJAdd.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/13.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YJAdd)
/** x */
@property (nonatomic,assign) CGFloat yj_x;
/** y */
@property (nonatomic,assign) CGFloat yj_y;
/** width */
@property (nonatomic,assign) CGFloat yj_width;
/** height */
@property (nonatomic,assign) CGFloat yj_height;
/** centerX */
@property (nonatomic,assign) CGFloat yj_centerX;
/** centerY */
@property (nonatomic,assign) CGFloat yj_centerY;
/** size */
@property (nonatomic,assign) CGSize yj_size;

+ (CGFloat)yj_screenWidth;
+ (CGFloat)yj_screenHeight;
- (void)addSpringAnimation;

@end
