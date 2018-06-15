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
- (NSMutableArray*)selectedAsset;
- (void)addAsset:(id)asset;
- (void)removeAsset:(id)asset;
- (void)removeAllAssets;
- (BOOL)containsAsset:(id)asset;
@end
