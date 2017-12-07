//
//  YJPhotoManager.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/12.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHAsset;
@interface YJPhotoManager : NSObject
+ (instancetype)sharedInstance;
+ (void)deallocInstance;

- (NSArray*)fetchAllAlbumsList;
- (NSMutableArray<PHAsset*>*)selectedAsset;
- (void)addAsset:(PHAsset*)asset;
- (void)removeAsset:(PHAsset*)asset;
- (void)removeAllAssets;
- (BOOL)containsAsset:(PHAsset*)asset;
@end
