//
//  MYQPhotoCycleController.m
//  MianYangQuan
//
//  Created by Zong on 16/4/8.
//  Copyright © 2016年 kk. All rights reserved.
//

#import "MYQPhotoCycleController.h"
#import "MYQPhotosSelectViewController.h"
#import "MYQAlassetLibraryManager.h"
#import "UIImage+DHUtil.h"
#import "UIColor+DHUtil.h"

@interface MYQPhotoCycleCell () <UIScrollViewDelegate>

@end

@implementation MYQPhotoCycleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        self.scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2.0;
        scrollView.minimumZoomScale = 1.0;
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.contentView  addSubview:scrollView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap:)];
        [imageView addGestureRecognizer:tapGesture];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.imageView.frame = self.scrollView.bounds;
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [self.imageView setCenter:CGPointMake(xcenter, ycenter)];
}

#pragma mark - imageViewDidTap
- (void)imageViewDidTap:(UITapGestureRecognizer *)tapGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCycleCellImageViewDidTap)]) {
        [self.delegate photoCycleCellImageViewDidTap];
    }
    
}

@end



@interface MYQPhotoCycleController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MYQPhotoCycleCellDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) UIButton *selectButton;

@property (weak, nonatomic) UIView *bottomBarView;

@property (weak, nonatomic) UIButton *sendButton;

@end

@implementation MYQPhotoCycleController

static NSString * const kPhotoCycleCellID = @"kPhotoCycleCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupViews];
}


- (void)setupViews
{
    [self initialize];
    [self setupRightBarButton];
    [self setupCollectionView];
    [self setupBackBarButton];
    [self setupBottomBarView];
}

- (void)initialize
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:[MYQ_Default_Navi_Bar_Background colorWithAlphaComponent:0.8]] forBarMetrics:UIBarMetricsDefault];
}

- (void)setupBackBarButton
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)back
{
    [self.photosSelectVC relaodCollectionViewWithSelectedAssetArray:self.selecteAssetsArray];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setupRightBarButton
{
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton = selectButton;
    [selectButton setTitle:nil forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.frame = CGRectMake(0, 0, 40, 40);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectButton];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -44, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[MYQPhotoCycleCell class] forCellWithReuseIdentifier:kPhotoCycleCellID];
    [self.view addSubview:collectionView];
    [collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

    ALAsset *asset = self.mAssetsArray[self.indexPath.item];
    if ([self.selecteAssetsArray containsObject:asset]) {
        [self.selectButton setImage:[UIImage imageNamed:@"photos_pic_selected"] forState:UIControlStateNormal];
    }else {
        [self.selectButton setImage:[UIImage imageNamed:@"photos_pic_select"] forState:UIControlStateNormal];
    }
}


- (void)setupBottomBarView
{
    UIView *bottomBarView = [[UIView alloc] init];
    self.bottomBarView = bottomBarView;
    bottomBarView.backgroundColor = [MYQ_Default_Navi_Bar_Background colorWithAlphaComponent:0.8];
    // 这里的 44*2 是跟上面collectionView的frame.y = -44有关的，不要随便模仿
    bottomBarView.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
    [self.view addSubview:bottomBarView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton = sendButton;
    CGFloat sendButtonWidth = 60;
    CGFloat sendButtonHeight = 22;
    sendButton.frame = CGRectMake(self.bottomBarView.bounds.size.width - sendButtonWidth - 10, (self.bottomBarView.bounds.size.height - sendButtonHeight) / 2.0, sendButtonWidth, sendButtonHeight);
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshBottomBarView];
    [bottomBarView addSubview:sendButton];
    
}

#pragma mark - sendButtonClick
- (void)sendButtonClick:(UIButton *)sendButton
{
     [self.photosSelectVC relaodCollectionViewWithSelectedAssetArray:self.selecteAssetsArray];
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCycleControllerDidClickSendButton)]) {
        [self.delegate photoCycleControllerDidClickSendButton];
    }
}

- (void)didSelectButton:(UIButton *)selectBarButton
{
    NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].firstObject;
    ALAsset *asset = self.mAssetsArray[indexPath.item];
    if ([self.selecteAssetsArray containsObject:asset]) {
        [self.selecteAssetsArray removeObject:asset];
    }else {
        
        if (self.selecteAssetsArray.count >= self.maxSelectedPhotoNumber) {
            [self showAlertMessage:[NSString stringWithFormat:@"最多选择%zd张图片",self.maxSelectedPhotoNumber] view:self.view];
        }else {
            [self.selecteAssetsArray addObject:asset];
        }
        
    }
    
    if ([self.selecteAssetsArray containsObject:asset]) {
        [self.selectButton setImage:[UIImage imageNamed:@"photos_pic_selected"] forState:UIControlStateNormal];
    }else {
        [self.selectButton setImage:[UIImage imageNamed:@"photos_pic_select"] forState:UIControlStateNormal];
    }
    
    
    [self refreshBottomBarView];
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
    MYQPhotoCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCycleCellID forIndexPath:indexPath];

    ALAsset *asset = self.mAssetsArray[indexPath.item];
    cell.imageView.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    cell.scrollView.zoomScale = 1.0;
    cell.delegate = self;
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger item = scrollView.contentOffset.x / scrollView.bounds.size.width;

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    ALAsset *asset = self.mAssetsArray[indexPath.item];
    
    if ([self.selecteAssetsArray containsObject:asset]) {
        [self.selectButton setImage:[UIImage imageNamed:@"photos_pic_selected"] forState:UIControlStateNormal];
    }else {
        [self.selectButton setImage:[UIImage imageNamed:@"photos_pic_select"] forState:UIControlStateNormal];
    }
}

#pragma mark - MYQPhotoCycleCellDelegate
- (void)photoCycleCellImageViewDidTap
{
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
    self.bottomBarView.hidden = !self.bottomBarView.hidden;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - refreshBottomBarView
- (void)refreshBottomBarView
{
    if (self.selecteAssetsArray.count > 0) {
        self.sendButton.enabled = YES;
        
        NSString *title = [NSString stringWithFormat:@"发送（%zd/%zd）",self.selecteAssetsArray.count,self.maxSelectedPhotoNumber];
        if (self.photoType == MYQPhotosSelectViewControllerTypeRedPacketPicture || self.photoType == MYQPhotosSelectViewControllerTypePrivatePhoto) {
            title = [NSString stringWithFormat:@"下一步(%zd/%zd)",self.selecteAssetsArray.count,self.maxSelectedPhotoNumber];
        }
        [self.sendButton setTitle:title forState:UIControlStateNormal];
        [self.sendButton setTitleColor:MYQ_Default_Tint_Colot forState:UIControlStateNormal];

    }else {
        self.sendButton.enabled = NO;

        NSString *title = @"发送";
        if (self.photoType == MYQPhotosSelectViewControllerTypeRedPacketPicture || self.photoType == MYQPhotosSelectViewControllerTypePrivatePhoto) {
            title = @"下一步";
        }
        [self.sendButton setTitle:title forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    CGFloat sendButtonWidth = [[self.sendButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName :self.sendButton.titleLabel.font}].width + 20;
    self.sendButton.frame = CGRectMake(self.view.bounds.size.width - sendButtonWidth, (self.bottomBarView.bounds.size.height - 22) / 2.0, sendButtonWidth, self.sendButton.bounds.size.height);
    
}

- (void)showAlertMessage:(NSString *)message view:(UIView *)view
{
    
}

@end
