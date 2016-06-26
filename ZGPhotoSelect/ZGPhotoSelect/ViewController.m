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
    [exampleButton setTitle:@"照片-样例" forState:UIControlStateNormal];
    exampleButton.frame = CGRectMake(140, 200, 100,30);
    [exampleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exampleButton addTarget:self action:@selector(exampleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exampleButton];
}


#pragma mark - exampleButtonClick
- (void)exampleButtonClick:(UIButton *)btn
{
    self.photoPickupVC = [ZGPhotoPickupController photoPickupWithViewController:self completeBlock:^(NSArray *imageArray, NSArray *assetArray, NSInteger code) {
        NSLog(@"image pickup");
    }];
  
    [self.photoPickupVC show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
