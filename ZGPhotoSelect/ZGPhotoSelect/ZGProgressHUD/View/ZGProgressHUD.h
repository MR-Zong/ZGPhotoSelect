//
//  ZGProgressHUD.h
//  ZGProgressHUD
//
//  Created by 徐宗根 on 16/12/3.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZGProgressHUDMode){
    ZGProgressHUDModeIndeterminate,
    ZGProgressHUDModeText,
    ZGProgressHUDModeToast,
};

@interface ZGProgressHUD : UIView

+ (void)showInView:(UIView *)view message:(NSString *)message mode:(ZGProgressHUDMode)mode;
+ (void)dismiss;


@end
