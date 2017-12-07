//
//  NSBundle+YJAdd.h
//  YJImagePickController
//
//  Created by 杨杰 on 2017/12/7.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (YJAdd)
+ (NSBundle*)yj_frameworkBundleWithClass:(Class)bundleClass;
+ (NSBundle*)yj_frameworkBundleWithClass:(Class)bundleClass frameworkName:(NSString*)frameworkName;
@end
