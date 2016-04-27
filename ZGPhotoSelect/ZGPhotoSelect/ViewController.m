//
//  ViewController.m
//  ZGPhotoSelect
//
//  Created by Zong on 16/4/26.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ViewController.h"
#import "MYQPhotosSelectViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *exampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exampleButton setTitle:@"照片-样例" forState:UIControlStateNormal];
    exampleButton.frame = CGRectMake(100, 200, 100, 24);
    exampleButton.backgroundColor = [UIColor yellowColor];
    [exampleButton addTarget:self action:@selector(exampleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exampleButton];
}


#pragma mark - exampleButtonClick
- (void)exampleButtonClick:(UIButton *)btn
{
    MYQPhotosSelectViewController *photoSelectVC = [[MYQPhotosSelectViewController alloc] init];
    [self presentViewController:photoSelectVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
