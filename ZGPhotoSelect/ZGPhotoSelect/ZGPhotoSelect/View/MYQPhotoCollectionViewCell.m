//
//  MYQPhotoCollectionViewCell.m
//  MianYangQuan
//
//  Created by Zong on 16/4/8.
//  Copyright © 2016年 kk. All rights reserved.
//

#import "MYQPhotoCollectionViewCell.h"

@interface MYQPhotoCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *selectedButton;

@end


@implementation MYQPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    // 图片
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
    imageView.backgroundColor = [UIColor redColor];
    
    // 选择按钮
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectedButton = selectedButton;
    [self.selectedButton addTarget:self action:@selector(clickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectedButton];
//    selectedButton.backgroundColor = [UIColor greenColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    CGFloat selectedButtonWidth = 30;
    CGFloat selectedButtonHeight = selectedButtonWidth;
    self.selectedButton.frame = CGRectMake(self.bounds.size.width - selectedButtonWidth, 0, selectedButtonWidth, selectedButtonHeight);
}

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    self.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    if (self.selectStatus == YES) {
        [self.selectedButton setImage:[UIImage imageNamed:@"photos_pic_selected"] forState:UIControlStateNormal];
    }else {
        [self.selectedButton setImage:[UIImage imageNamed:@"photos_pic_select"] forState:UIControlStateNormal];
    }
    
    
}

#pragma mark - button click
- (void)clickSelectedButton:(UIButton *)selectedButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCollectionViewCell:didClickSelectButtonWithIndexPath:)]) {
        [self.delegate photoCollectionViewCell:self didClickSelectButtonWithIndexPath:self.indexPath];
    }
}

@end
