//
//  MYQPhotosSelectViewController.m
//  MianYangQuan
//
//  Created by Zong on 16/4/8.
//  Copyright © 2016年 kk. All rights reserved.
//

#import "MYQPhotosSelectViewController.h"

#import "MYQPhotoCollectionViewCell.h"
#import "MYQPhotoCycleController.h"
#import "UIColor+DHUtil.h"
#import "UIImage+DHUtil.h"

@interface MYQPhotosSelectViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MYQPhotoCollectionViewCellDelegate,MYQPhotoCycleControllerDelegate>

@property (strong, nonatomic) NSMutableArray *mAssetsArray;

@property (strong, nonatomic) ALAssetsLibrary *assetLibrary;

@property (strong, nonatomic) NSMutableArray *selecteAssetsArray;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) UIButton *sendButton;

@property (weak, nonatomic) UIButton *previewButton;

@end


@implementation MYQPhotosSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mAssetsArray = [[NSMutableArray alloc] init];
    
    self.selecteAssetsArray = [[NSMutableArray alloc] init];
    
    self.assetLibrary = [MYQAlassetLibraryManager shareAlassetLibraryManager].assetLibrary;
    
    [self setupMaxSelectedPhotoNumber];
    [self setupViews];
    [self loadPhotos];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:MYQ_Default_Navi_Bar_Background] forBarMetrics:UIBarMetricsDefault];
}

- (void)setupViews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"相机胶卷";
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    [self setupRightBarButton];
    [self setupCollectionView];
    [self setupBottomBarView];
}

- (void)setupMaxSelectedPhotoNumber
{
    if (self.maxSelectedPhotoNumber == 0) {
        self.maxSelectedPhotoNumber = 9;
        if (self.photoType == MYQPhotosSelectViewControllerTypeRedPacketPicture || self.photoType == MYQPhotosSelectViewControllerTypePrivatePhoto ) {
            self.maxSelectedPhotoNumber = 1;
        }
    }

}

- (void)setupRightBarButton
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(didRightButton:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 40, 23);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44 - 64) collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[MYQPhotoCollectionViewCell class] forCellWithReuseIdentifier:kPhotoCollectionViewCellID];
    [self.view addSubview:collectionView];
}

- (void)setupBottomBarView
{
    CGFloat bottomBarViewHeight = 44;
    UIView *bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - bottomBarViewHeight - 64, self.view.bounds.size.width, bottomBarViewHeight)];
    bottomBarView.backgroundColor = [UIColor colorWithHex:0xe2e2e2];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton = sendButton;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    if (self.photoType == MYQPhotosSelectViewControllerTypeRedPacketPicture || self.photoType == MYQPhotosSelectViewControllerTypePrivatePhoto) {
        [sendButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    CGFloat sendButtonWidth = [[sendButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName :sendButton.titleLabel.font}].width + 20;
    sendButton.frame = CGRectMake(self.view.bounds.size.width - sendButtonWidth, 0, sendButtonWidth, bottomBarView.bounds.size.height);
    sendButton.enabled = NO;
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bottomBarView addSubview:sendButton];
    [sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomBarView];
    
    UIButton *preViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previewButton = preViewButton;
    CGFloat preViewButtonWidth = 60;
    preViewButton.enabled = NO;
    preViewButton.frame = CGRectMake(0, 0, preViewButtonWidth, bottomBarView.bounds.size.height);
    [preViewButton setTitle:@"预览" forState:UIControlStateNormal];
    [preViewButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [preViewButton addTarget:self action:@selector(clickPreViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarView addSubview:preViewButton];
    
    [self.view addSubview:bottomBarView];
    
}

- (void)loadPhotos
{
    // 权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//    NSLog(@"author %zd",author);
    
    NSMutableArray *groupArray = [NSMutableArray array];
    
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groupArray addObject:group];
        }else {
            
            
            NSInteger indexOfExampleGallery = NSNotFound;
            for (ALAssetsGroup *group in groupArray) {
                if ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == 16)
                    indexOfExampleGallery = [groupArray indexOfObject:group];
            }
            

            if (indexOfExampleGallery != NSNotFound) {
            
                ALAssetsGroup *group = groupArray[indexOfExampleGallery];
                
                ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                    if (asset != nil && [[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        [self.mAssetsArray addObject:asset];
                    }else {
                        if (self.mAssetsArray.count > 0 ) {
                            [self.collectionView reloadData];
                            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.mAssetsArray.count-1 inSection:0];
                            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                        }
                    }

                };
                
                [group enumerateAssetsUsingBlock:resultsBlock];
                
            
            }else {
                 NSLog(@"Gallery 'ExampleGallery' not found on device.");
            }
            
            
            
        }
        
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"Group not found!\n");
    }];

}

- (void)relaodCollectionViewWithSelectedAssetArray:(NSMutableArray *)selecteAssetsArray
{
    self.selecteAssetsArray = selecteAssetsArray;
    [self refreshButton];
    
    [self.collectionView reloadData];
}

#pragma mark - click button
- (void)didRightButton:(UIButton *)rightButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSendButton:(UIButton *)sendButton
{
    if (self.selecteAssetsArray.count <= 0) {
        return;
    }
    
    if (self.photosSelectCompleteBlock) {
        self.photosSelectCompleteBlock(self.selecteAssetsArray,self.photoType);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)clickPreViewButton:(UIButton *)preViewButton
{
    if (self.selecteAssetsArray.count <= 0) {
        return;
    }
    MYQPhotoCycleController *photoCycleVC = [[MYQPhotoCycleController alloc] init];
    photoCycleVC.mAssetsArray = [self.selecteAssetsArray mutableCopy];
    photoCycleVC.selecteAssetsArray = [self.selecteAssetsArray mutableCopy];
    photoCycleVC.indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    photoCycleVC.maxSelectedPhotoNumber = self.maxSelectedPhotoNumber;
    photoCycleVC.photosSelectVC = self;
    photoCycleVC.delegate = self;
    photoCycleVC.photoType = self.photoType;
    [self.navigationController pushViewController:photoCycleVC animated:YES];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mAssetsArray.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYQPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCollectionViewCellID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    ALAsset *asset = self.mAssetsArray[indexPath.item];
    cell.selectStatus = [self.selecteAssetsArray containsObject:asset];
    cell.asset = asset;
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemSizeWidth = (collectionView.bounds.size.width -5*5)/ 4.0;
    CGFloat itemSizeHeight =  itemSizeWidth;
    
    return CGSizeMake(itemSizeWidth, itemSizeHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    return edgeInset;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYQPhotoCycleController *photoCycleVC = [[MYQPhotoCycleController alloc] init];
    photoCycleVC.mAssetsArray = self.mAssetsArray;
    photoCycleVC.selecteAssetsArray = self.selecteAssetsArray;
    photoCycleVC.indexPath = indexPath;
     photoCycleVC.maxSelectedPhotoNumber = self.maxSelectedPhotoNumber;
    photoCycleVC.photosSelectVC = self;
    photoCycleVC.delegate = self;
    photoCycleVC.photoType = self.photoType;
    [self.navigationController pushViewController:photoCycleVC animated:YES];
}


#pragma mark - MYQPhotoCollectionViewCellDelegate
- (void)photoCollectionViewCell:(MYQPhotoCollectionViewCell *)photoCell didClickSelectButtonWithIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = self.mAssetsArray[indexPath.item];
    if ([self.selecteAssetsArray containsObject:asset]) {
        [self.selecteAssetsArray removeObject:asset];
    }else {
        if (self.selecteAssetsArray.count >= self.maxSelectedPhotoNumber) {
             [self showAlertMessage:[NSString stringWithFormat:@"最多选择%zd张图片",self.maxSelectedPhotoNumber] view:self.view];
        }else{
            [self.selecteAssetsArray addObject:asset];
        }
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [self refreshButton];

}



- (void)refreshButton
{
    if (self.selecteAssetsArray.count > 0) {
        self.sendButton.enabled = YES;
        self.previewButton.enabled = YES;
        
        NSString *title = [NSString stringWithFormat:@"发送（%zd/%zd）",self.selecteAssetsArray.count,self.maxSelectedPhotoNumber];
        if (self.photoType == MYQPhotosSelectViewControllerTypeRedPacketPicture || self.photoType == MYQPhotosSelectViewControllerTypePrivatePhoto) {
            title = [NSString stringWithFormat:@"下一步(%zd/%zd)",self.selecteAssetsArray.count,self.maxSelectedPhotoNumber];
        }
        [self.sendButton setTitle:title forState:UIControlStateNormal];
        
        [self.sendButton setTitleColor:MYQ_Default_Tint_Colot forState:UIControlStateNormal];
        [self.previewButton setTitleColor:MYQ_Default_Tint_Colot forState:UIControlStateNormal];
    }else {
        self.sendButton.enabled = NO;
        self.previewButton.enabled = NO;
        NSString *title = @"发送";
        if (self.photoType == MYQPhotosSelectViewControllerTypeRedPacketPicture || self.photoType == MYQPhotosSelectViewControllerTypePrivatePhoto) {
            title = @"下一步";
        }
        [self.sendButton setTitle:title forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.previewButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    CGFloat sendButtonWidth = [[self.sendButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName :self.sendButton.titleLabel.font}].width + 20;
    self.sendButton.frame = CGRectMake(self.view.bounds.size.width - sendButtonWidth, 0, sendButtonWidth, self.sendButton.bounds.size.height);
}


#pragma mark - MYQPhotoCycleControllerDelegate
- (void)photoCycleControllerDidClickSendButton
{
    [self clickSendButton:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertMessage:(NSString *)message view:(UIView *)view
{
    
}

@end
