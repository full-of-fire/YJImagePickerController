//
//  YJImagePrewViewController.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/13.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJImagePrewViewController.h"
#import "UIView+YJAdd.h"
#import "YJTabBar.h"
#import "YJImagePreviewCell.h"
#import "YJPhotoManager.h"
#import "YJImagePickerController.h"
#import "PHAsset+YJAdd.h"
#import "NSBundle+YJAdd.h"
#import "YJImageModel.h"
const CGFloat kNaviBarHeight = 64;
const CGFloat kTabBarHeight = 49;
@interface YJImagePrewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/** tabbar */
@property (nonatomic,strong) YJTabBar *tabBar;
/** 选中按钮 */
@property (nonatomic,strong) UIButton *selectButton;
/** collection */
@property (nonatomic,strong) UICollectionView *collectionView;
@property(strong,nonatomic) UILabel *titleLabel;
@end
@implementation YJImagePrewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController) {
        [self setNavigaitionItems];
    }
    else{
        [self addNavigationBar];
    }
    
    [self addSubViews];
    [self setTabNums];
}

#pragma mark - setup

- (void)setNavigaitionItems{

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self updateTitle];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *unSelectPath = [[NSBundle yj_frameworkBundleWithClass:self.class] pathForResource:@"unSelect" ofType:@"png"];
    NSString *selectPath = [[NSBundle yj_frameworkBundleWithClass:self.class] pathForResource:@"select" ofType:@"png"];
    [selectButton setImage:[[UIImage alloc] initWithContentsOfFile:unSelectPath] forState:UIControlStateNormal];
    [selectButton setImage:[[UIImage alloc] initWithContentsOfFile:selectPath] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.frame = CGRectMake(0, 0, 44, 44);
    _selectButton = selectButton;
    [self updateSelectButtonState];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:selectButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

- (void)addNavigationBar{
    UIView *naviContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIView yj_screenWidth], 64)];
    naviContentView.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    [self.view addSubview:naviContentView];
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 20, 44, 44);
    [naviContentView addSubview:backButton];
    //中间标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(([UIView yj_screenWidth] - 100)/2 , 20, 100, 44);
    _titleLabel = titleLabel;
    [naviContentView addSubview:titleLabel];
    [self updateTitle];
}

- (void)updateTitle{
    if (self.navigationController) {
        self.title = [NSString stringWithFormat:@"%d/%d",(self.index+1),self.photoList.count];
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"%d/%d",(self.index+1),self.photoList.count];
    }
}

- (void)setTabNums{
    id<YJImageInputProtocol> inputImage = self.photoList.firstObject;
    if (inputImage.imageAsset) {
        _tabBar.selectNumLabel.hidden = ![[YJPhotoManager sharedInstance] selectedAsset].count;
        _tabBar.selectNumLabel.text = [NSString stringWithFormat:@"%d",[[YJPhotoManager sharedInstance] selectedAsset].count];
        _tabBar.finishButton.enabled = [[YJPhotoManager sharedInstance] selectedAsset].count;
    }else{
        _selectButton.hidden = YES;
        _tabBar.finishButton.hidden = YES;
        _tabBar.selectNumLabel.hidden = YES;
        _tabBar.hidden = YES;
    }
  
}

- (void)updateSelectButtonState{
     _selectButton.selected = [[YJPhotoManager sharedInstance] containsAsset:self.photoList[self.index]];
}

- (void)addSubViews{

    CGFloat screenW = [UIView yj_screenWidth];
    CGFloat screenH = [UIView yj_screenHeight];
    
    //collection
    [self.view addSubview:self.collectionView];

    [self.collectionView setContentOffset:CGPointMake(self.index * screenW, 0) animated:NO];
    //tarbar
    _tabBar = [[YJTabBar alloc] init];
    _tabBar.frame = CGRectMake(0, screenH - kTabBarHeight, screenW,  kTabBarHeight);
      __weak typeof(self) weakSelf = self;
    [_tabBar setFinishButtonClick:^{
        NSLog(@"结束");
        YJImagePickerController *picker = (YJImagePickerController*)weakSelf.navigationController;
        NSMutableArray *pickedImages = [NSMutableArray array];
        for (PHAsset *asset in [[YJPhotoManager sharedInstance] selectedAsset]) {
            id<YJImageInputProtocol> imageModel = [[YJImageModel alloc] initWithAsset:asset];
            [pickedImages addObject:imageModel];
        }
        if (picker.pickDelegate&&[picker.pickDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingImages:)]) {
            [picker.pickDelegate imagePickerController:picker didFinishPickingImages:[pickedImages copy]];
        }
        // block回调
        if (picker.didFinishPickingImages) {
            picker.didFinishPickingImages([pickedImages copy]);
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
        [YJPhotoManager deallocInstance];
    }];
    
    [self.view addSubview:_tabBar];
    
}
#pragma mark - action
- (void)backAction:(UIButton*)backButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YJImagePreviewCell" forIndexPath:indexPath];
    [cell setCellImageModel:self.photoList[indexPath.row]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = scrollView.contentOffset.x / [UIView yj_screenWidth] + 0.5;
    self.index = (int)page;
    [self updateTitle];
    [self updateSelectButtonState];
}

#pragma mark - actions
- (void)selectAction:(UIButton*)btn{
    btn.selected = !btn.selected;
    YJImageModel *imageModel = self.photoList[self.index];
    if (btn.selected) {
        if (imageModel.imageAsset) {
            [[YJPhotoManager sharedInstance] addAsset:imageModel.imageAsset];
        }
    }
    else{
        if (imageModel.imageAsset) {
            [[YJPhotoManager sharedInstance] removeAsset:imageModel.imageAsset];
        }
    }
    [self setTabNums];
}

#pragma mark - getters

- (UICollectionView*)collectionView
{
    if(_collectionView==nil){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake([UIView yj_screenWidth], [UIView yj_screenHeight]-kNaviBarHeight);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat top = 0;
        CGFloat tabHeight = 0;
        if (self.navigationController) {
            top = 0;
            tabHeight = kTabBarHeight;
        }else{
            top = 64;
            tabHeight = 0;
        }
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, [UIView yj_screenWidth], [UIView yj_screenHeight] - top - tabHeight) collectionViewLayout:flowLayout];
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[YJImagePreviewCell class] forCellWithReuseIdentifier:@"YJImagePreviewCell"];
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end
