//
//  YJThumbnailCell.m
//  YJImagePickController
//
//  Created by 杨杰 on 2017/12/21.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJStillImageCell.h"
#import "PHAsset+YJAdd.h"
@interface YJStillImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;

@end

@implementation YJStillImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)deleteAction:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(stillImageCell:didClickDeleteButton:)]) {
        [self.delegate stillImageCell:self didClickDeleteButton:sender];
    }
}

- (void)setCellWithImage:(UIImage *)image {
    _thumbnailImageView.image = image;
}

- (void)setCellWithImageModel:(id<YJImageInputProtocol>)imageModel {
    [imageModel.imageAsset yj_requestImageForTargetSize:CGSizeMake(100, 100) resultHandler:^(UIImage *result, NSDictionary *info) {
        _thumbnailImageView.image = result;
    }];
}

@end
