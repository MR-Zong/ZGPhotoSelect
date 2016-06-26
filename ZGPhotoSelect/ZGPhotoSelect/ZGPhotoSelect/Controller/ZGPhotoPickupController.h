//
//  ZGPhotoPickupController.h
//  ZGPhotoSelect
//
//  Created by 徐宗根 on 16/6/25.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGPhotoPickupController : UIViewController

/**
 * 显示照片选择器
 */
- (void)show;

/**
 * viewController 弹出照片选择控制器的父控制器
 * completeBlock：imageArray 获取的照片数组
 * completeBlock：assetArray 获取的照片asset数组 (拍照模式，这个为nil)
 * completeBlock：code 0 成功 -1 失败
 */
+ (instancetype)photoPickupWithViewController:(UIViewController *)viewController completeBlock:(void(^)(NSArray *imageArray,NSArray *assetArray,NSInteger code))completeBlock;

@end
