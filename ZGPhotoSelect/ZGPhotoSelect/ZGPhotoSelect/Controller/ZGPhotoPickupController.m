//
//  ZGPhotoPickupController.m
//  ZGPhotoSelect
//
//  Created by 徐宗根 on 16/6/25.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGPhotoPickupController.h"
#import "ZGPhotosSelectViewController.h"
#import "ZGAlassetLibraryManager.h"

@interface ZGPhotoPickupController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, copy) void(^completeBlock)(NSArray *, NSArray *, NSInteger);

@end

@implementation ZGPhotoPickupController

+ (instancetype)photoPickupWithViewController:(UIViewController *)viewController completeBlock:(void (^)(NSArray *, NSArray *, NSInteger))completeBlock
{
    ZGPhotoPickupController *photoPickupVC = [[self alloc] init];
    photoPickupVC.viewController = viewController;
    photoPickupVC.completeBlock = completeBlock;
    return photoPickupVC;
}


- (void)show
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍一张照片",@"从相册选一张", nil];
    [actionSheet showInView:self.viewController.view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"拍一张照片"]) {
        UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] == YES) {
            
            pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickVC.delegate = self;
            [self.viewController presentViewController:pickVC animated:YES completion:nil];
        }
        
    }else if([title isEqualToString:@"从相册选一张"]){
        ZGPhotosSelectViewController *photoSelectVC = [[ZGPhotosSelectViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        [photoSelectVC setPhotosSelectCompleteBlock:^(NSMutableArray *selectAssetArray, ZGPhotosSelectViewControllerType type) {
            if (weakSelf.completeBlock) {
                NSMutableArray *mArray = [NSMutableArray array];
                for (ALAsset *asset in selectAssetArray) {
                    [mArray addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
                }
                weakSelf.completeBlock(mArray.copy,selectAssetArray,0);
            }

        }];

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoSelectVC];
        [self.viewController presentViewController:nav animated:YES completion:nil];

    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *resultImage = info[UIImagePickerControllerOriginalImage];
    if (resultImage) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        if (self.completeBlock) {
            self.completeBlock([[NSArray alloc] initWithObjects:resultImage, nil],nil,0);
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
