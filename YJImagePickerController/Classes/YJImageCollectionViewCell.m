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
#import "UIView+YJAdd.h"
@interface YJImageCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageVIew;
/** asset */
@property (nonatomic,strong) PHAsset *asset;

@property(strong,nonatomic) YJImageModel *currentImageModel;
@end

@implementation YJImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

- (void)setCellWithAsset:(PHAsset*)asset {
    _asset = asset;
    _selectButton.selected = [[YJPhotoManager sharedInstance] containsAsset:asset];
    __weak typeof(self) weakSelf = self;
    
    [_asset yj_requestImageForTargetSize:CGSizeMake(self.frame.size.width, self.frame.size.height) resultHandler:^(UIImage *result, NSDictionary *info) {
        weakSelf.thumbnailImageVIew.image = result;
    }];
    
}

- (void)setCellWithImageModel:(YJImageModel*)model {
    
    
    _currentImageModel = model;
    _selectButton.selected = model.selected;
    
    NSString *buttonTitle = [NSString stringWithFormat:@"%ld", model.selectIndex];
    if (model.selectIndex == 0)
    {
        buttonTitle = nil;
    }
    // 给button 加数据
    [_selectButton setTitle:model.selected ? buttonTitle : nil forState:0];
    
    self.thumbnailImageVIew.image = [model.imageAsset yj_thumbnailImageTargetSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];

    
    
}



- (IBAction)selectaAction:(UIButton *)sender {
    [sender addSpringAnimation];
    sender.selected = !sender.selected;
    _currentImageModel.selected = sender.selected;
    if (sender.selected) {
        [[YJPhotoManager sharedInstance] addAsset:_currentImageModel];
        NSUInteger count = [[YJPhotoManager sharedInstance] selectedAsset].count;
        NSString *numStr =  [NSString stringWithFormat:@"%ld",count];
//        _currentImageModel.selectIndex = count;
        [sender setTitle:numStr forState:0];
    }
    else{
        [[YJPhotoManager sharedInstance] removeAsset:_currentImageModel];
        [sender setTitle:nil forState:0];
       
    }
    
    if (self.cellSelectButtonClick) {
        self.cellSelectButtonClick();
    }
}
@end
