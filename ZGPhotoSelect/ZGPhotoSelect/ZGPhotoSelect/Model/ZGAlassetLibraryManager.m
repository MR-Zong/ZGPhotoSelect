//
//  ZGAlassetLibraryManager.m
//  MianYangQuan
//
//  Created by Zong on 16/4/12.
//  Copyright © 2016年 kk. All rights reserved.
//

#import "ZGAlassetLibraryManager.h"


@implementation ZGAlassetLibraryManager

static ALAssetsLibrary *_alassetLibrary_ = nil;

+ (instancetype)shareAlassetLibraryManager
{
    static ZGAlassetLibraryManager *_alassetLibraryM_ = nil;
    static dispatch_once_t onceToken;
    if (!_alassetLibraryM_) {
        
        dispatch_once(&onceToken, ^{
            
            _alassetLibraryM_ = [[ZGAlassetLibraryManager alloc] init];
            _alassetLibrary_ = [[ALAssetsLibrary alloc] init];
        });
    }
    return _alassetLibraryM_;
}


- (ALAssetsLibrary *)assetLibrary
{
    return _alassetLibrary_;
}

@end
