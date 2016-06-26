//
//  ViewController.m
//  ZGPhotoSelect
//
//  Created by Zong on 16/4/26.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ViewController.h"
#import "ZGPhotoPickupController.h"

@interface ViewController ()

@property (nonatomic, strong) ZGPhotoPickupController *photoPickupVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *exampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exampleButton setTitle:@"照片样例(请点击)" forState:UIControlStateNormal];
    exampleButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 140) / 2.0, 200, 150,30);
    [exampleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exampleButton addTarget:self action:@selector(exampleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exampleButton];
}


#pragma mark - exampleButtonClick
- (void)exampleButtonClick:(UIButton *)btn
{
    self.photoPickupVC = [ZGPhotoPickupController photoPickupWithViewController:self completeBlock:^(NSArray *imageArray, NSArray *assetArray, NSInteger code) {
        NSLog(@"image pickup success");
    }];
  
    [self.photoPickupVC show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
