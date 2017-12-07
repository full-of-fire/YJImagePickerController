//
//  YJImagePickerController.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJImagePickerController.h"
#import "YJAlbumsListViewController.h"
@interface YJImagePickerController ()

@end

@implementation YJImagePickerController

- (instancetype)init
{
    self = [super initWithRootViewController:[YJAlbumsListViewController new]];
    if (self) {
        self.navigationBar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
        self.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}

#pragma mark - actions




@end
