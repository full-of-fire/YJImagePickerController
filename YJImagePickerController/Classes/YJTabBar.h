//
//  YJTabBar.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/13.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJTabBar : UIView
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UILabel *selectNumLabel;
/** prevewClick */
@property (nonatomic,copy) void(^previewButtonClick)(void);
/** finishClick */
@property (nonatomic,copy) void(^finishButtonClick)(void);

@end
