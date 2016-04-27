//
//  MYQPhotoCollectionViewCell.h
//  MianYangQuan
//
//  Created by Zong on 16/4/8.
//  Copyright © 2016年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYQAlassetLibraryManager.h"

@class MYQPhotoCollectionViewCell;

@protocol MYQPhotoCollectionViewCellDelegate <NSObject>

- (void)photoCollectionViewCell:(MYQPhotoCollectionViewCell *)photoCell didClickSelectButtonWithIndexPath:(NSIndexPath *)indexPath;

@end

static NSString * const kPhotoCollectionViewCellID = @"MYQPhotoCollectionViewCellID";


@interface MYQPhotoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) ALAsset *asset;

@property (weak, nonatomic) id <MYQPhotoCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) BOOL selectStatus;

@end
