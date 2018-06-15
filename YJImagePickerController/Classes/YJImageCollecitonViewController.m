//
//  YJImageCollecitonViewController.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJImageCollecitonViewController.h"
#import <Photos/Photos.h>
#import "YJImageCollectionViewCell.h"
#import "YJPhotoManager.h"
#import "YJImagePrewViewController.h"
#import "YJImagePickerController.h"
#import "PHAsset+YJAdd.h"
#import "NSBundle+YJAdd.h"
#import "YJImageModel.h"
#define kPadding 3.0
#define kWidth (([UIScreen mainScreen].bounds.size.width - 5 * kPadding) / 4)
@interface YJImageCollecitonViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 包含图像Model的数组 */
@property (nonatomic,strong) NSArray *photoList;
/** 相册集合 */
@property (nonatomic,strong) PHAssetCollection*assetCollection;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UILabel *selectNumLabel;
/** in */
@property (nonatomic,assign) NSUInteger lasetSeletedIndex;
@end

@implementation YJImageCollecitonViewController
#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        @throw [NSException exceptionWithName:@"initError" reason:@"该方法不支持" userInfo:nil];
    }
    return self;
}

- (instancetype)initWithAssetCollection:(PHAssetCollection*)assetCollection
{
    NSBundle *bundle = [NSBundle yj_frameworkBundleWithClass:self.class];
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:bundle];
    if (self) {
        _assetCollection = assetCollection;
        _photoList = [NSArray array];
    }
    return self;
}

+ (instancetype)imageCollecitonViewController:(PHAssetCollection*)assetCollection{
    return [[self alloc] initWithAssetCollection:assetCollection];
}
- (void)dealloc{
    [YJPhotoManager deallocInstance];
}

#pragma mark - viewlife
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.assetCollection.localizedTitle;
    [self loadData];
    [self setNavi];
    [self setUpBottomView];
    [self setUpCollectionView];
    self.lasetSeletedIndex = 0;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [self setUpBottomView];
    
}

- (void)loadData {
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
    NSMutableArray *arr = [NSMutableArray array];
    for (PHAsset *asset in result) {
        YJImageModel *imageModel = [YJImageModel imageModelWithAsset:asset];
        [arr addObject:imageModel];
    }
    self.photoList = [arr copy];
}

- (void)setUpBottomView {
    self.selectNumLabel.layer.cornerRadius = 10;
    self.selectNumLabel.clipsToBounds = YES;
    if (![[YJPhotoManager sharedInstance] selectedAsset].count) {
        self.previewButton.enabled = NO;
        self.finishButton.enabled = NO;
        self.selectNumLabel.hidden = YES;
    }else{
        self.previewButton.enabled = YES;
        self.finishButton.enabled = YES;
        self.selectNumLabel.hidden = NO;
        self.selectNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[YJPhotoManager sharedInstance] selectedAsset].count];
    }
}

- (void)setNavi {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)setUpCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kWidth, kWidth);
    layout.sectionInset = UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding);
    layout.minimumInteritemSpacing = kPadding;
    layout.minimumLineSpacing = kPadding;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
    NSBundle *bundle = [NSBundle yj_frameworkBundleWithClass:self.class];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YJImageCollectionViewCell" bundle:bundle] forCellWithReuseIdentifier:@"YJImageCollectionViewCell"];
}

#pragma mark - actions
- (IBAction)previewAction:(UIButton *)sender {
    YJImagePrewViewController *preViewVC = [[YJImagePrewViewController alloc] init];
    preViewVC.index = self.lasetSeletedIndex;
    //
    preViewVC.photoList = self.photoList;
    [self.navigationController pushViewController:preViewVC animated:YES];
    
}

- (IBAction)finishAction:(UIButton *)sender {
    //点击完成
    YJImagePickerController *picker = (YJImagePickerController*)self.navigationController;
    NSMutableArray *pickedImages = [[YJPhotoManager sharedInstance] selectedAsset];
//    NSMutableArray *selectdAssets = [[YJPhotoManager sharedInstance] selectedAsset];
//    for (int i = 0; i<selectdAssets.count; i++) {
//        id<YJImageInputProtocol> imageModel = [[YJImageModel alloc] initWithAsset:selectdAssets[i]];
//        [pickedImages addObject:imageModel];
//    }
   
    
    if (picker.pickDelegate&&[picker.pickDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingImages:)]) {
        [picker.pickDelegate imagePickerController:picker didFinishPickingImages:[pickedImages copy]];
    }
    // block回调
    if (picker.didFinishPickingImages) {
        picker.didFinishPickingImages([pickedImages copy]);
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancleAction{
    YJImagePickerController *picker = (YJImagePickerController*)self.navigationController;
    if (picker.pickDelegate &&[picker.pickDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [picker.pickDelegate imagePickerControllerDidCancel:picker];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YJImageCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"YJImageCollectionViewCell" forIndexPath:indexPath];
    [cell setCellWithImageModel:self.photoList[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    [cell setCellSelectButtonClick:^{
        //更新底部状态栏
        [weakSelf setUpBottomView];
        
        [weakSelf.collectionView reloadData];
       
        weakSelf.lasetSeletedIndex = indexPath.row;
    }];
    return cell;
}

#pragma mark - 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YJImagePrewViewController *preViewVC = [[YJImagePrewViewController alloc] init];
    preViewVC.index = indexPath.row;
    preViewVC.photoList =  self.photoList;
    [self.navigationController pushViewController:preViewVC animated:YES];
}

//#pragma mark - private
//- (NSArray*)p_covertAssetsToImageModels{
//    NSMutableArray *imageModels = [NSMutableArray array];
//    
//    for (int i = 0; i<self.photoList.count; i++) {
//        YJImageModel *model = [[YJImageModel alloc] init];
//        model.imageAsset = self.photoList[i];
//        [imageModels addObject:model];
//    }
//
//    return imageModels.copy;
//}


@end
