//
//  YJAlbumsCell.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJAlbumsCell.h"
#import <Photos/Photos.h>
#import "PHAsset+YJAdd.h"
#import "PHAssetCollection+YJAdd.h"
const CGFloat KYJAlbumsThumnailWidth = 60;
const CGFloat KYJAlbumsThumnailHeight = 44;
@interface YJAlbumsCell()
@property (weak, nonatomic) IBOutlet UIImageView *albumsImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumsName;
@property (weak, nonatomic) IBOutlet UILabel *ablumsCount;

@end

@implementation YJAlbumsCell
- (void)setCellWithAblums:(PHAssetCollection *)assetCollection{
    self.albumsName.text = assetCollection.localizedTitle;
    self.ablumsCount.text = [self numberOfAssets:assetCollection];
    __weak typeof(self) weakSelf = self;
    [assetCollection yj_requestLastImageWithTargetSize:CGSizeMake(KYJAlbumsThumnailWidth, KYJAlbumsThumnailHeight) resultHandler:^(UIImage *result, NSDictionary *info) {
        weakSelf.albumsImageView.image = result;
    }];
}

- (NSString*)numberOfAssets:(PHAssetCollection*)assetCollection {
    NSUInteger count = [assetCollection yj_numerOfAsset];
    return [NSString stringWithFormat:@"(%lu)",(unsigned long)count];
}
@end
