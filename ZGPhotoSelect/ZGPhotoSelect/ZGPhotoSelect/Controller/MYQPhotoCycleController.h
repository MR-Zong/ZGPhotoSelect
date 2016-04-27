//
//  MYQPhotoCycleController.h
//  MianYangQuan
//
//  Created by Zong on 16/4/8.
//  Copyright © 2016年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MYQPhotosSelectViewController.h"

//颜色
#define MYQ_Default_Cell_Background     RGBA(0x26, 0x26, 0x26, 1) //cell背景色
#define MYQ_Default_Navi_Bar_Background RGBA(0x30, 0x30, 0x30, 1) //导航条背景色
#define MYQ_Default_Tab_Bar_Background  RGBA(0x30, 0x30, 0x30, 1) //tabbar背景色
#define MYQ_Default_VC_Backgroud_Color  RGBA(0x11, 0x11, 0x11, 1) //vc 背景色
#define MYQ_Default_Tab_Bar_Tint_Color  RGBA(0x58, 0x9b, 0xda, 1) //tabbar tint color
#define MYQ_Default_Tint_Colot          RGBA(0x58, 0x9b, 0xda, 1) //全局 tint color



@class MYQPhotosSelectViewController;

@protocol MYQPhotoCycleCellDelegate  <NSObject>

@optional
- (void)photoCycleCellImageViewDidTap;

@end

@interface MYQPhotoCycleCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) id <MYQPhotoCycleCellDelegate> delegate;

@end



@protocol MYQPhotoCycleControllerDelegate  <NSObject>

@optional
- (void)photoCycleControllerDidClickSendButton;

@end
@interface MYQPhotoCycleController : UIViewController

@property (strong, nonatomic) NSMutableArray *mAssetsArray;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (strong, nonatomic) NSMutableArray *selecteAssetsArray;

@property (weak, nonatomic) MYQPhotosSelectViewController *photosSelectVC;

@property (assign, nonatomic) NSInteger maxSelectedPhotoNumber;

@property (weak, nonatomic) id <MYQPhotoCycleControllerDelegate> delegate;

@property (assign, nonatomic) MYQPhotosSelectViewControllerType photoType;



@end
