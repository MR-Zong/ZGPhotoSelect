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


@interface MYQPhotosSelectViewController : UIViewController

@property (copy, nonatomic) void(^photosSelectCompleteBlock)(NSMutableArray * selectedPhotos,MYQPhotosSelectViewControllerType photoType);

@property (assign, nonatomic) MYQPhotosSelectViewControllerType photoType;

@property (assign, nonatomic) NSInteger maxSelectedPhotoNumber;

- (void)relaodCollectionViewWithSelectedAssetArray:(NSMutableArray *)selecteAssetsArray;

@end
