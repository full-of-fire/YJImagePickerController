//
//  YJImageCollecitonViewController.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAssetCollection;
@interface YJImageCollecitonViewController : UIViewController
- (instancetype)initWithAssetCollection:(PHAssetCollection*)assetCollection;
+ (instancetype)imageCollecitonViewController:(PHAssetCollection*)assetCollection;
@end
