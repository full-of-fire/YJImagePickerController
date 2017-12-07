//
//  YJTabBar.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/13.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJTabBar.h"
#import "NSBundle+YJAdd.h"
@interface YJTabBar()

@end
@implementation YJTabBar
- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectNumLabel.layer.cornerRadius = 9;
    self.selectNumLabel.clipsToBounds = YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSBundle *bundle = [NSBundle yj_frameworkBundleWithClass:self.class];
        self = [bundle loadNibNamed:@"YJTabBar" owner:nil options:nil].firstObject;
    }
    return self;
}

- (IBAction)preViewAction:(UIButton *)sender {
    if (self.previewButtonClick) {
        self.previewButtonClick();
    }
}
- (IBAction)finishAction:(UIButton *)sender {
    if (self.finishButtonClick) {
        self.finishButtonClick();
    }
}

@end
