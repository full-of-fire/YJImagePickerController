//
//  YJImagePreviewCell.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/13.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJImagePreviewCell.h"
#import "UIView+YJAdd.h"
#import "PHAsset+YJAdd.h"
@interface YJImagePreviewCell()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) CGPoint imageCenter;
@end

@implementation YJImagePreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}

#pragma mark - setter
- (void)setCellWithAsset:(PHAsset*)asset {
    [_scrollView setZoomScale:1.0 animated:NO];
    
    [asset yj_requestOriginImage:^(UIImage *result, NSDictionary *info) {
       
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGFloat imgWidth = result.size.width;
        CGFloat imgHeight = result.size.height;
        CGFloat w;
        CGFloat h;
    
        imgHeight = width / imgWidth * imgHeight;
        if (imgHeight > height) {
            w = height / result.size.height * imgWidth;
            h = height;
        }else {
            w = width;
            h = imgHeight;
        }
        _imageView.frame = CGRectMake(0, 0, w, h);
        _imageView.center = CGPointMake(width / 2, height / 2);
        _imageCenter = _imageView.center;
        _imageView.image = result;
        _scrollView.contentSize  =  CGSizeMake(width, h);
    }];
}



#pragma mark - actions

- (void)singleTapAction:(UITapGestureRecognizer*)singleTap{

    NSLog(@"我是单机手势");
    if ([self.delegate respondsToSelector:@selector(imagePreviewCell:singleTapAction:)]) {
        [self.delegate imagePreviewCell:self singleTapAction:singleTap];
    }
   
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGPoint touchPoint;
        touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = width / newZoomScale;
        CGFloat ysize = height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - 返回需要缩放的控件
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    
}

#pragma mark - getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.yj_width, self.yj_height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 2;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.contentSize = CGSizeMake(self.yj_width, self.yj_height);
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:tap2];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [singleTap requireGestureRecognizerToFail:tap2];
        [_scrollView addGestureRecognizer:singleTap];
        
        
    }
    return _scrollView;
}
- (UIImageView*)imageView
{
    
    if(_imageView==nil){
        _imageView  = [[UIImageView alloc] init];
    }
    return _imageView;
}





@end
