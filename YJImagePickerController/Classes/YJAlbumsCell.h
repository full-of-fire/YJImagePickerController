//
//  YJAlbumsCell.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAssetCollection;
@interface YJAlbumsCell : UITableViewCell
- (void)setCellWithAblums:(PHAssetCollection*)assetCollection;
@end
