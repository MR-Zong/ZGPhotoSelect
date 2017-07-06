//
//  ZGPhotosSelectViewController.h
//  MianYangQuan
//
//  Created by Zong on 16/4/8.
//  Copyright © 2016年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZGPhotosSelectViewControllerTypeNormal,
    ZGPhotosSelectViewControllerTypeRedPacketPicture,
    ZGPhotosSelectViewControllerTypePrivatePhoto,
} ZGPhotosSelectViewControllerType;


@interface ZGPhotosSelectViewController : UIViewController

@property (copy, nonatomic) void(^photosSelectCompleteBlock)(NSMutableArray * selectedPhotos,ZGPhotosSelectViewControllerType photoType);

@property (assign, nonatomic) ZGPhotosSelectViewControllerType photoType;

@property (assign, nonatomic) NSInteger maxSelectedPhotoNumber;

- (void)relaodCollectionViewWithSelectedAssetArray:(NSMutableArray *)selecteAssetsArray;

@end
