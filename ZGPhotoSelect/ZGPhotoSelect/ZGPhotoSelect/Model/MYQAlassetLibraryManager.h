//
//  MYQAlassetLibraryManager.h
//  MianYangQuan
//
//  Created by Zong on 16/4/12.
//  Copyright © 2016年 kk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MYQAlassetLibraryManager : NSObject

+ (instancetype)shareAlassetLibraryManager;

- (ALAssetsLibrary *)assetLibrary;

@end
