//
//  YJPhotoManager.m
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJPhotoManager.h"
#import <Photos/Photos.h>
#import "PHAssetCollection+YJAdd.h"
#import "YJImageModel.h"
const NSInteger KDefaultMaxSelectedCount = 10;
static YJPhotoManager *instacne = nil;
static dispatch_once_t onceToken;
@interface YJPhotoManager()
/** data */
@property (nonatomic,strong) NSMutableArray *dataArray;
/** 最大选中相册 */
@property (nonatomic,assign) NSInteger maxSelectCount;
@end

@implementation YJPhotoManager
+ (instancetype)sharedInstance{
    dispatch_once(&onceToken, ^{
        instacne = [[self alloc] init];
        instacne.dataArray = [NSMutableArray array];
        instacne.maxSelectCount = KDefaultMaxSelectedCount;
    });
    return instacne;
}

+ (void)deallocInstance{
    instacne = nil;
    onceToken = 0;
}

- (NSMutableArray*)selectedAsset{
    return self.dataArray;
}

- (void)addAsset:(id)asset{
    if (!asset) {
        return;
    }
    
    YJImageModel *imageModel = (YJImageModel*)asset;
    imageModel.selected = YES;
    imageModel.selectIndex = self.dataArray.count + 1;
    [self.dataArray addObject:imageModel];
}
- (void)removeAsset:(id)asset{
    if (!asset) {
        return;
    }
    if (![_dataArray containsObject:asset]) {
        return;
    }
    
    YJImageModel *imageModel = (YJImageModel*)asset;
    imageModel.selected = NO;
    [self.dataArray removeObject:asset];
    for (YJImageModel *model in self.dataArray) {
        if (model.selectIndex>imageModel.selectIndex) {
            model.selectIndex -=1;
        }
    }
    
   
}
- (void)removeAllAssets{
    [self.dataArray removeAllObjects];
}
- (BOOL)containsAsset:(id)asset{

    if (!asset) {
        return NO;
    }
//    if (![asset isKindOfClass:[PHAsset class]]) {
//        return NO;
//    }
    return [[self selectedAsset] containsObject:asset];
}


- (NSArray*)fetchAllAlbumsList{

    NSMutableArray *groups = [NSMutableArray array];
    // 获取系统相册
    PHFetchResult <PHAssetCollection *>*systemAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 获取用户自定义相册
    PHFetchResult <PHAssetCollection *>*userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    for (PHAssetCollection *collection in systemAlbums) {
        // 过滤照片数量为0的相册
        if ([collection yj_numerOfAsset]) {
            [groups addObject:collection];

        }
    }
    
    for (PHAssetCollection *collection in userAlbums) {
        // 过滤照片数量为0的相册
        if ([collection yj_numerOfAsset]) {
            [groups addObject:collection];
            
        }
    }
    return groups;

}

@end
