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
#import "MYQPhotoCycleController.h"


typedef void(^MYQPictureRedPacketSendButtonBlock)(CGFloat price,NSString *message);

@interface MYQPictureRedPacketSetMoneyViewController : UIViewController

@property (copy, nonatomic) MYQPictureRedPacketSendButtonBlock redPacketPicSendBlock;

@property (copy, nonatomic) NSString *titleString;

@property (copy, nonatomic) NSString *sendButtonTitleString;

@end
