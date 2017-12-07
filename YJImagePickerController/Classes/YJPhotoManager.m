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
const NSInteger KDefaultMaxSelectedCount = 10;
static YJPhotoManager *instacne = nil;
static dispatch_once_t onceToken;
@interface YJPhotoManager()
/** data */
@property (nonatomic,strong) NSMutableArray<PHAsset*> *dataArray;
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

- (NSMutableArray<PHAsset*>*)selectedAsset{
    return self.dataArray;
}

- (void)addAsset:(PHAsset*)asset{
    if (!asset) {
        return;
    }
    [self.dataArray addObject:asset];
}
- (void)removeAsset:(PHAsset*)asset{
    if (!asset) {
        return;
    }
    if (![_dataArray containsObject:asset]) {
        return;
    }
    [self.dataArray removeObject:asset];
}
- (void)removeAllAssets{
    [self.dataArray removeAllObjects];
}
- (BOOL)containsAsset:(PHAsset*)asset{

    if (!asset) {
        return NO;
    }
    if (![asset isKindOfClass:[PHAsset class]]) {
        return NO;
    }
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
