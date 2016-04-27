//
//  MYQPictureRedPacketSetMoneyViewController.h
//  MianYangQuan
//
//  Created by Zong on 16/4/11.
//  Copyright © 2016年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+DHUtil.h"
#import "UIImage+DHUtil.h"

//#define RGBA(r,g,b,a) ([UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)])
//颜色
#define MYQ_Default_Cell_Background     RGBA(0x26, 0x26, 0x26, 1) //cell背景色
#define MYQ_Default_Navi_Bar_Background RGBA(0x30, 0x30, 0x30, 1) //导航条背景色
#define MYQ_Default_Tab_Bar_Background  RGBA(0x30, 0x30, 0x30, 1) //tabbar背景色
#define MYQ_Default_VC_Backgroud_Color  RGBA(0x11, 0x11, 0x11, 1) //vc 背景色
#define MYQ_Default_Tab_Bar_Tint_Color  RGBA(0x58, 0x9b, 0xda, 1) //tabbar tint color
#define MYQ_Default_Tint_Colot          RGBA(0x58, 0x9b, 0xda, 1) //全局 tint color

typedef void(^MYQPictureRedPacketSendButtonBlock)(CGFloat price,NSString *message);

@interface MYQPictureRedPacketSetMoneyViewController : UIViewController

@property (copy, nonatomic) MYQPictureRedPacketSendButtonBlock redPacketPicSendBlock;

@property (copy, nonatomic) NSString *titleString;

@property (copy, nonatomic) NSString *sendButtonTitleString;

@end
