//
//  YJAlbumsViewController.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJAlbumsListViewController.h"
#import <Photos/Photos.h>
#import "YJAlbumsCell.h"
#import "YJPhotoManager.h"
#import "YJImageCollecitonViewController.h"
#import "YJImagePickerController.h"

#import "NSBundle+YJAdd.h"
@interface YJAlbumsListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 相册数组 */
@property (nonatomic,strong) NSArray<PHAssetCollection*> *albumsList;
@end

@implementation YJAlbumsListViewController
#pragma mark - init
- (instancetype)init
{
    NSBundle *bundle = [NSBundle yj_frameworkBundleWithClass:self.class];
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:bundle];
    if (self) {
        NSArray *arr = [[YJPhotoManager sharedInstance] fetchAllAlbumsList];
        self.albumsList = arr;
    }
    return self;
}

- (void)dealloc{
    [YJPhotoManager deallocInstance];
}

#pragma mark - viewLife
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSBundle *bundle = [NSBundle yj_frameworkBundleWithClass:self.class];
    [self.tableView registerNib:[UINib nibWithNibName:@"YJAlbumsCell" bundle:bundle] forCellReuseIdentifier:@"YJAlbumsCell"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.title = @"相册";
    
}
- (void)cancleAction{
    
    YJImagePickerController *picker = (YJImagePickerController*)self.navigationController;
    if (picker.pickDelegate &&[picker.pickDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [picker.pickDelegate imagePickerControllerDidCancel:picker];
    }
    //block回调
    if (picker.didCancel) {
        picker.didCancel();
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJAlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJAlbumsCell" forIndexPath:indexPath];
    [cell setCellWithAblums:self.albumsList[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *collection = self.albumsList[indexPath.row];
    YJImageCollecitonViewController *imageCollectionVC = [YJImageCollecitonViewController imageCollecitonViewController:collection];
    [self.navigationController pushViewController:imageCollectionVC animated:YES];
}




@end
