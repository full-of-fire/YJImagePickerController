//
//  YJThumbnailCell.h
//  YJImagePickController
//
//  Created by 杨杰 on 2017/12/21.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJStillImageCell;
@protocol YJStillImageCellDelegate <NSObject>
@optional
- (void)stillImageCell:(YJStillImageCell*)cell didClickDeleteButton:(UIButton*)deleteButton;
@end
@interface YJStillImageCell : UICollectionViewCell
@property(weak,nonatomic) id<YJStillImageCellDelegate> delegate;
- (void)setCellWithImage:(UIImage*)image;
@end
