//
//  YJImageCollectionViewCell.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJImageCollectionViewCell.h"

#import "YJPhotoManager.h"
#import "PHAsset+YJAdd.h"
@interface YJImageCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageVIew;
/** asset */
@property (nonatomic,strong) PHAsset *asset;
@end

@implementation YJImageCollectionViewCell


- (void)setCellWithAsset:(PHAsset*)asset {
    _asset = asset;
    _selectButton.selected = [[YJPhotoManager sharedInstance] containsAsset:asset];
    __weak typeof(self) weakSelf = self;
    [_asset yj_requestImageForTargetSize:CGSizeMake(self.frame.size.width, self.frame.size.height) resultHandler:^(UIImage *result, NSDictionary *info) {
        weakSelf.thumbnailImageVIew.image = result;
    }];
}



- (IBAction)selectaAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[YJPhotoManager sharedInstance] addAsset:_asset];
    }
    else{
        [[YJPhotoManager sharedInstance] removeAsset:_asset];
    }
    if (self.cellSelectButtonClick) {
        self.cellSelectButtonClick();
    }
}
@end
