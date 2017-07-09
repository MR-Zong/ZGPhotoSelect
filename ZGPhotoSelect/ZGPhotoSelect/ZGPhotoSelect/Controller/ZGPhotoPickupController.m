//
//  ZGPhotoPickupController.m
//  ZGPhotoSelect
//
//  Created by 徐宗根 on 16/6/25.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGPhotoPickupController.h"
#import "ZGAlassetLibraryManager.h"

@interface ZGPhotoPickupController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, copy) void(^completeBlock)(NSArray *, NSArray *, NSInteger);

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) ZGPhotosSelectViewController *photoSelectVC;

@end

@implementation ZGPhotoPickupController

+ (instancetype)photoPickupWithViewController:(UIViewController *)viewController completeBlock:(void (^)(NSArray *, NSArray *, NSInteger))completeBlock
{
    ZGPhotoPickupController *photoPickupVC = [[self alloc] init];
    photoPickupVC.viewController = viewController;
    photoPickupVC.completeBlock = completeBlock;
    
    photoPickupVC.photoGraphVC = [[UIImagePickerController alloc] init];
    if (!TARGET_IPHONE_SIMULATOR) {
        
        photoPickupVC.photoGraphVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    photoPickupVC.photoGraphVC.delegate = photoPickupVC;


    return photoPickupVC;
}



- (void)show
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍一张照片",@"从相册选一张", nil];
    [self.actionSheet showInView:self.viewController.view];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"拍一张照片"]) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] == YES) {
            [self.viewController presentViewController:self.photoGraphVC animated:YES completion:nil];
        }
        
    }else if([title isEqualToString:@"从相册选一张"]){

        self.photoSelectVC = [[ZGPhotosSelectViewController alloc] init];
        self.photoSelectVC.sendButtonTitle = self.sendButtonTitle;
        self.photoSelectVC.maxSelectedPhotoNumber = self.maxSelectedPhotoNumber;
        self.photoSelectVC.photoVCType = self.photoVCType;

        __weak typeof(self) weakSelf = self;
        [self.photoSelectVC setPhotosSelectCompleteBlock:^(NSMutableArray *selectAssetArray, ZGPhotosSelectViewControllerType type) {
            if (weakSelf.completeBlock) {
                NSMutableArray *mArray = [NSMutableArray array];
                for (ALAsset *asset in selectAssetArray) {
                    [mArray addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
                }
                weakSelf.completeBlock(mArray.copy,selectAssetArray,0);
            }

        }];

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.photoSelectVC];
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

#pragma mark - getter
- (UIActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"拍一张照片",@"从相册选一张", nil];
    }
    return _actionSheet;
}

@end
