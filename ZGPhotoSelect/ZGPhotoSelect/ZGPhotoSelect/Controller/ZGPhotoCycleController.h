//
//  ZGPhotoCycleController.h
//  MianYangQuan
//
//  Created by Zong on 16/4/8.
//  Copyright © 2016年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZGPhotosSelectViewController.h"

//颜色
#define ZG_Default_Cell_Background     RGBA(0x26, 0x26, 0x26, 1) //cell背景色
#define ZG_Default_Navi_Bar_Background RGBA(0x30, 0x30, 0x30, 1) //导航条背景色
#define ZG_Default_Tab_Bar_Background  RGBA(0x30, 0x30, 0x30, 1) //tabbar背景色
#define ZG_Default_VC_Backgroud_Color  RGBA(0x11, 0x11, 0x11, 1) //vc 背景色
#define ZG_Default_Tab_Bar_Tint_Color  RGBA(0x58, 0x9b, 0xda, 1) //tabbar tint color
#define ZG_Default_Tint_Colot          RGBA(0x58, 0x9b, 0xda, 1) //全局 tint color



@class ZGPhotosSelectViewController;

@protocol ZGPhotoCycleCellDelegate  <NSObject>

@optional
- (void)photoCycleCellImageViewDidTap;

@end

@interface ZGPhotoCycleCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) id <ZGPhotoCycleCellDelegate> delegate;

@end



@protocol ZGPhotoCycleControllerDelegate  <NSObject>

@optional
- (void)photoCycleControllerDidClickSendButton;

@end
@interface ZGPhotoCycleController : UIViewController

@property (strong, nonatomic) NSMutableArray *mAssetsArray;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (strong, nonatomic) NSMutableArray *selecteAssetsArray;

@property (weak, nonatomic) ZGPhotosSelectViewController *photosSelectVC;

@property (assign, nonatomic) NSInteger maxSelectedPhotoNumber;

@property (weak, nonatomic) id <ZGPhotoCycleControllerDelegate> delegate;

@property (assign, nonatomic) ZGPhotosSelectViewControllerType photoVCType;

/**
 * sendButtonTitle 发送按钮的文案
 */
@property (strong, nonatomic) NSString *sendButtonTitle;




@end
