//
//  MYQPhotosSelectViewController.h
//  MianYangQuan
//
//  Created by Zong on 16/4/8.
//  Copyright © 2016年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MYQPhotosSelectViewControllerTypeNormal,
    MYQPhotosSelectViewControllerTypeRedPacketPicture,
    MYQPhotosSelectViewControllerTypePrivatePhoto,
} MYQPhotosSelectViewControllerType;

typedef void(^MYQPhotosSelectCompleteBlock)(NSMutableArray * selectedPhotos,CGFloat price,NSString *message,MYQPhotosSelectViewControllerType photoType);

@interface MYQPhotosSelectViewController : UIViewController

@property (copy, nonatomic) MYQPhotosSelectCompleteBlock photosSelectCompleteBlock;

@property (assign, nonatomic) MYQPhotosSelectViewControllerType photoType;

- (void)relaodCollectionViewWithSelectedAssetArray:(NSMutableArray *)selecteAssetsArray;

@end
