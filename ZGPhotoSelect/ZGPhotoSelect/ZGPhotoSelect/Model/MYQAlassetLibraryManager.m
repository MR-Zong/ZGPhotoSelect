//
//  MYQAlassetLibraryManager.m
//  MianYangQuan
//
//  Created by Zong on 16/4/12.
//  Copyright © 2016年 kk. All rights reserved.
//

#import "MYQAlassetLibraryManager.h"


@implementation MYQAlassetLibraryManager

static ALAssetsLibrary *_alassetLibrary_ = nil;

+ (instancetype)shareAlassetLibraryManager
{
    static MYQAlassetLibraryManager *_alassetLibraryM_ = nil;
    static dispatch_once_t onceToken;
    if (!_alassetLibraryM_) {
        
        dispatch_once(&onceToken, ^{
            
            _alassetLibraryM_ = [[MYQAlassetLibraryManager alloc] init];
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
