//
//  YJImageCollectionViewCell.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJImageModel.h"
@class PHAsset;
@interface YJImageCollectionViewCell : UICollectionViewCell
/** 选中点击回调 */
@property (nonatomic,copy) void(^cellSelectButtonClick)(void);
- (void)setCellWithAsset:(PHAsset*)asset;

- (void)setCellWithImageModel:(YJImageModel*)model;
@end
