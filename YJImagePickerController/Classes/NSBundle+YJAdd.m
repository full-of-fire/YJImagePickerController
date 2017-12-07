//
//  NSBundle+YJAdd.m
//  YJImagePickController
//
//  Created by 杨杰 on 2017/12/7.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "NSBundle+YJAdd.h"
#import <objc/runtime.h>
@implementation NSBundle (YJAdd)
+ (NSBundle*)yj_frameworkBundleWithClass:(Class)bundleClass{
    return [self yj_frameworkBundleWithClass:bundleClass frameworkName:@"YJImagePickerController"];
}

+ (NSBundle*)yj_frameworkBundleWithClass:(Class)bundleClass frameworkName:(NSString*)frameworkName{
    NSBundle *podBundle = [NSBundle bundleForClass:bundleClass];
    NSURL *bundelURL = [podBundle URLForResource:frameworkName withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundelURL];
    return bundle;
}


+ (void)load {
    Method originMethod = class_getInstanceMethod(self, @selector(pathForResource:ofType:));
    Method newMethod = class_getInstanceMethod(self, @selector(tempPathForResource:ofType:));
    method_exchangeImplementations(originMethod, newMethod);
}

- (NSString *)tempPathForResource:(NSString *)name ofType:(NSString *)ext {
    NSString *path = [self tempPathForResource:name ofType:ext];
    if (path) {
        return path;
    }
    CGFloat scale = [UIScreen mainScreen].scale;
    if (ABS(scale-3) <= 0.001) {
        path = [self tempPathForResource_3x:name ofType:ext];
        if (!path) {
            path = [self tempPathForResource_2x:name ofType:ext];
            if (!path) {
                path = [self tempPathForResource_x:name ofType:ext];
            }
        }
        
    }
    else if (ABS(scale-2) <= 0.001){
        path = [self tempPathForResource_2x:name ofType:ext];
        if (!path) {
            path = [self tempPathForResource_3x:name ofType:ext];
            if (!path) {
                path = [self tempPathForResource_x:name ofType:ext];
            }
        }
    }
    else {
        path = [self tempPathForResource_x:name ofType:ext];
        if (!path) {
            path = [self tempPathForResource_2x:name ofType:ext];
            if (!path) {
                path = [self tempPathForResource_3x:name ofType:ext];
            }
        }
    }
    
    return path;
}

- (NSString *)tempPathForResource_x:(NSString *)name ofType:(NSString *)ext {
    NSString *path = nil;
    NSString *teampName = nil;
    
    if ([name hasSuffix:@"@3x"]) {
        teampName = [name stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
    }
    else if ([name hasSuffix:@"@2x"]) {
        teampName = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    }
    else {
        teampName = name;
    }
    path = [self tempPathForResource:teampName ofType:ext];
    
    return path;
}

- (NSString *)tempPathForResource_2x:(NSString *)name ofType:(NSString *)ext {
    NSString *path = nil;
    NSString *teampName = nil;
    
    if ([name hasSuffix:@"@3x"]) {
        teampName = [name stringByReplacingOccurrencesOfString:@"@3x" withString:@"@2x"];
    }
    else if ([name hasSuffix:@"@2x"]) {
        teampName = name;
    }
    else {
        teampName = [NSString stringWithFormat:@"%@@2x", name];
    }
    path = [self tempPathForResource:teampName ofType:ext];
    
    return path;
}

- (NSString *)tempPathForResource_3x:(NSString *)name ofType:(NSString *)ext {
    NSString *path = nil;
    NSString *teampName = nil;
    
    if ([name hasSuffix:@"@3x"]) {
        teampName = name;
    }
    else if ([name hasSuffix:@"@2x"]) {
        teampName = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@"@3x"];
    }
    else {
        teampName = [NSString stringWithFormat:@"%@@3x", name];
    }
    path = [self tempPathForResource:teampName ofType:ext];
    
    return path;
}
@end
