//
//  ZGPhotoCollectionViewCell.h
//  MianYangQuan
//
//  Created by Zong on 16/4/8.
//  Copyright © 2016年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGAlassetLibraryManager.h"

@class ZGPhotoCollectionViewCell;

@protocol ZGPhotoCollectionViewCellDelegate <NSObject>

- (void)photoCollectionViewCell:(ZGPhotoCollectionViewCell *)photoCell didClickSelectButtonWithIndexPath:(NSIndexPath *)indexPath;

@end

static NSString * const kPhotoCollectionViewCellID = @"ZGPhotoCollectionViewCellID";


@interface ZGPhotoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) ALAsset *asset;

@property (weak, nonatomic) id <ZGPhotoCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) BOOL selectStatus;

@end
