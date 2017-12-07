//
//  YJImagePreviewCell.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/13.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;
@class YJImagePreviewCell;
@protocol YJImagePreviewCellDelegate <NSObject>
@optional
- (void)imagePreviewCell:(YJImagePreviewCell*)previewCell singleTapAction:(UITapGestureRecognizer*)singleTap;
@end
@interface YJImagePreviewCell : UICollectionViewCell

/** delegate */
@property (nonatomic,weak) id<YJImagePreviewCellDelegate> delegate;
- (void)setCellWithAsset:(PHAsset*)asset;
@end
