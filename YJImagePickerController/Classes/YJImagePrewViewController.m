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
const CGFloat kNaviBarHeight = 64;
const CGFloat kTabBarHeight = 49;
@interface YJImagePrewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/** tabbar */
@property (nonatomic,strong) YJTabBar *tabBar;
/** 选中按钮 */
@property (nonatomic,strong) UIButton *selectButton;
/** collection */
@property (nonatomic,strong) UICollectionView *collectionView;

@end
@implementation YJImagePrewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigaitionItems];
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


- (void)updateTitle{
    self.title = [NSString stringWithFormat:@"%d/%d",(self.index+1),self.photoList.count];
}

- (void)setTabNums{
    _tabBar.selectNumLabel.hidden = ![[YJPhotoManager sharedInstance] selectedAsset].count;
    _tabBar.selectNumLabel.text = [NSString stringWithFormat:@"%d",[[YJPhotoManager sharedInstance] selectedAsset].count];
    _tabBar.finishButton.enabled = [[YJPhotoManager sharedInstance] selectedAsset].count;
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
            UIImage *originImage = [asset yj_originImage];
            if (originImage) {
                [pickedImages addObject:originImage];
            }
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
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YJImagePreviewCell" forIndexPath:indexPath];
    [cell setCellWithAsset:self.photoList[indexPath.row]];
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
    if (btn.selected) {
        [[YJPhotoManager sharedInstance] addAsset:self.photoList[self.index]];
    }
    else{
        [[YJPhotoManager sharedInstance] removeAsset:self.photoList[self.index]];
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
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIView yj_screenWidth], [UIView yj_screenHeight]) collectionViewLayout:flowLayout];
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
