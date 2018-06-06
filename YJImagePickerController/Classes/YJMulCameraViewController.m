//
//  YJMulCameraViewController.m
//  YJImagePickController
//
//  Created by 杨杰 on 2017/12/19.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJMulCameraViewController.h"
#import "YJUImageStillCamera.h"
#import "YJStillImageCell.h"
#import "NSBundle+YJAdd.h"
#import "YJImagePrewViewController.h"
#import "YJImageModel.h"
#import "YJPermissionPhotos.h"
#import "YJPermissionCamera.h"
@interface YJMulCameraViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YJStillImageCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *cameraPreView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong,nonatomic) YJUImageStillCamera *camera;
@property(strong,nonatomic) NSMutableArray *takeImages;//拍摄的照片
@end

@implementation YJMulCameraViewController

- (instancetype)init
{
    NSBundle *bundle = [NSBundle yj_frameworkBundleWithClass:self.class];
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:bundle];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YJPermissionCamera authorizeWithCompletion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [YJPermissionPhotos authorizeWithCompletion:^(BOOL granted, BOOL firstTime) {
                if (granted) {
                    [self setUpCamera];
                }
                else{
                    //需要获取相册权限
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请开启相册权限" delegate:nil  cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
                    [alertView show];
                    
                }
            }];
            
        }else{
            // 需要获取相机权限
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请开启相机权限" delegate:nil  cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }];
    
   
    [self setUpCollectionView];
}
#pragma mark - setup
- (void)setUpCamera{
    _camera = [[YJUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPositon:AVCaptureDevicePositionBack];
    [_camera startCameraCaptureInView:_cameraPreView];
}
- (void)setUpCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 10;
    CGFloat itemWH  = 100;
    flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [_collectionView setCollectionViewLayout:flowLayout];
    [_collectionView registerNib:[UINib nibWithNibName:@"YJStillImageCell" bundle:[NSBundle yj_frameworkBundleWithClass:self.class]] forCellWithReuseIdentifier:NSStringFromClass([YJStillImageCell class])];
}

#pragma mark - actions
- (IBAction)finishAction:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mulCameraViewController:didFinishTakeImages:)]) {
        [self.delegate mulCameraViewController:self didFinishTakeImages:self.takeImages];
    }
    if (self.didFinishTakeImagesBlock) {
        self.didFinishTakeImagesBlock(self.takeImages);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)takePictureAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [_camera takePhotoImageWithComplete:^(UIImage *originImage, NSError *error) {
        if(originImage){
            
            
            //保存图片到相册
            [weakSelf saveImageToPhotoLibrary:originImage complete:^(PHAsset *asset) {
                
                id<YJImageInputProtocol> model = [[YJImageModel alloc] initWithAsset:asset];
                [weakSelf.takeImages addObject:model];
                [weakSelf.collectionView reloadData];
                [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.takeImages.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
            }];
            
            
          
        }
    }];
}


#pragma mark - private
- (void)saveImageToPhotoLibrary:(UIImage*)image complete:(void(^)(PHAsset*asset))complete
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
        
        if (success)
        {
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                imageAsset = obj;
                *stop = YES;
                
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(imageAsset);
            });
        }
        
    }];
}





- (IBAction)cancleAction:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mulCameraViewControllerDidCancel:)]) {
        [self.delegate mulCameraViewControllerDidCancel:self];
    }
    if (self.didCancelBlock) {
        self.didCancelBlock();
    }
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(mulCameraViewController:didFinishTakeImages:)]) {
//        [self.delegate mulCameraViewController:self didFinishTakeImages:self.takeImages];
//    }
//    if (self.didFinishTakeImagesBlock) {
//        self.didFinishTakeImagesBlock(self.takeImages);
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)switchFlashModeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_camera setFlashModeOn:sender.selected];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.takeImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJStillImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YJStillImageCell" forIndexPath:indexPath];
    id<YJImageInputProtocol> imageModel =  self.takeImages[indexPath.row];
    [cell setCellWithImageModel:imageModel];
    
    cell.delegate = self;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YJImagePrewViewController *imagePireViewVC = [YJImagePrewViewController new];
    imagePireViewVC.index = indexPath.row;
    imagePireViewVC.photoList = self.takeImages;
    [self presentViewController:imagePireViewVC animated:YES completion:nil];
}


#pragma mark - YJStillImageCellDelegate
- (void)stillImageCell:(YJStillImageCell *)cell  didClickDeleteButton:(UIButton *)deleteButton {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.takeImages removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
}

#pragma mark - setters
- (void)setImages:(NSArray *)images {
    self.takeImages = images.mutableCopy;
    [self.collectionView reloadData];
}


#pragma mark - getters
- (NSMutableArray*)takeImages{
    if (_takeImages == nil) {
        _takeImages = [NSMutableArray array];
    }
    return _takeImages;
}

@end
