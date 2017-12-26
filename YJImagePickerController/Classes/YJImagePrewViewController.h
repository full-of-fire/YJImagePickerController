//
//  YJImagePrewViewController.h
//  YJImagePickController
//
//  Created by yangjie on 17/11/13.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJImageInputProtocol.h"
@interface YJImagePrewViewController : UIViewController
/** list */
@property (nonatomic,strong) NSArray<id<YJImageInputProtocol>> *photoList;
/** index */
@property (nonatomic,assign) NSUInteger index;
@end
