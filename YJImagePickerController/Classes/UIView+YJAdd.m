//
//  UIView+YJAdd.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/13.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "UIView+YJAdd.h"

@implementation UIView (YJAdd)
- (CGFloat)yj_x {
    return self.frame.origin.x;
}

- (void)setYj_x:(CGFloat)yj_x {
    CGRect frame = self.frame;
    frame.origin.x = yj_x;
    self.frame = frame;
}

- (CGFloat)yj_y{
    return self.frame.origin.y;
}
- (void)setYj_y:(CGFloat)yj_y{

    CGRect frame = self.frame;
    frame.origin.y = yj_y;
    self.frame = frame;
}

- (CGFloat)yj_width{
    return self.frame.size.width;
}
- (void)setYj_width:(CGFloat)yj_width{
    CGRect frame =self.frame;
    frame.size.width = yj_width;
    self.frame  = frame;
}
- (CGFloat)yj_height {
    return self.frame.size.height;
}
- (void)setYj_height:(CGFloat)yj_height{
    CGRect frame = self.frame;
    frame.size.width = yj_height;
    self.frame = frame;
}

- (CGFloat)yj_centerX{
    return self.center.x;
}
- (void)setYj_centerX:(CGFloat)yj_centerX{
    CGPoint center = self.center;
    center.x = yj_centerX;
    self.center = center;
}
- (CGFloat)yj_centerY{
    return self.center.y;
}
- (void)setYj_centerY:(CGFloat)yj_centerY{
    CGPoint center = self.center;
    center.y  = yj_centerY;
    self.center = center;
}

- (CGSize)yj_size{
    return self.frame.size;
}
- (void)setYj_size:(CGSize)yj_size{
    CGRect frame = self.frame;
    frame.size  = yj_size;
    self.frame = frame;
}

+ (CGFloat)yj_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}
+ (CGFloat)yj_screenHeight{
    return [UIScreen mainScreen].bounds.size.height;
}

- (void)addSpringAnimation
{
    if (@available(iOS 9.0, *))
    {
        CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
        spring.toValue = @(2);
        spring.removedOnCompletion = NO;
        spring.duration = spring.settlingDuration;
        [self.layer addAnimation:spring forKey:nil];
        spring.toValue = @(1);
        spring.duration = spring.settlingDuration;
        [self.layer addAnimation:spring forKey:nil];
    }
}

@end
