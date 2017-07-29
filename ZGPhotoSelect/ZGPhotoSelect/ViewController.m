//
//  ViewController.m
//  ZGPhotoSelect
//
//  Created by Zong on 16/4/26.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ViewController.h"
#import "ZGPhotoPickupController.h"
#import "UIImage+DHUtil.h"

@interface MYQPhotoGraphFillColorView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect clipRect;
@property (nonatomic, assign) CGFloat cornerRadius;

- (void)clipWithRect:(CGRect)rect;
- (void)setMaskLayerWithView:(UIView *)view maskRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
- (void)bezierMaskLayerWithView:(UIView *)view maskRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
@end

@implementation MYQPhotoGraphFillColorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        _imageView = [[UIImageView alloc] initWithFrame:frame];
//        _imageView.image = [UIImage imageFromColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] size:frame.size];
//        [self addSubview:_imageView];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPathRef totalPath = CGPathCreateWithRect(rect, NULL);
    CGContextAddPath(context, totalPath);
    
    //使用rgb颜色空间
//    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] colorWithAlphaComponent:0.3].CGColor);
//    CGContextFillPath(context);
    
    CGPathRef clipPath = CGPathCreateWithRoundedRect(self.clipRect, self.cornerRadius, self.cornerRadius, NULL);
    CGContextAddPath(context, clipPath);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor);
    CGContextEOFillPath(context);

    CGPathRelease(clipPath);
    CGContextRelease(context);
    
}

- (void)clipWithRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    // 把imageView的layer映射到上下文中
    [self.imageView.layer renderInContext:context];
    // 清除划过的区域
    CGContextClearRect(context, rect);
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图片的画板, (意味着图片在上下文中消失)
    UIGraphicsEndImageContext();
    self.imageView.image = image;
    
}


// 贝塞尔path
- (void)bezierMaskLayerWithView:(UIView *)view maskRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    //贝塞尔曲线 画一个带矩形
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:view.bounds];
    //贝塞尔曲线 画一个带有圆角的矩形
    [bpath appendPath: [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] bezierPathByReversingPath]];
    
    //创建一个CAShapeLayer 图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    view.layer.mask = shapeLayer;
}

//绘制裁剪区分图层
- (void)setMaskLayerWithView:(UIView *)view maskRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    if(cornerRadius == 0)
    {
        return;
    }
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    CGMutablePathRef mainPath = CGPathCreateMutable();
    CGPathAddRect(mainPath, NULL, rect);
    
    
    CGMutablePathRef subPath = CGPathCreateMutable();
    
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    
    
    CGPathMoveToPoint(subPath, NULL, minx, midy);
    
    CGPathAddArcToPoint(subPath, NULL,minx, miny, midx, miny, cornerRadius);
    
    CGPathAddArcToPoint(subPath, NULL,maxx, miny, maxx, midy, cornerRadius);
    
    CGPathAddArcToPoint(subPath, NULL, maxx, maxy, midx, maxy, cornerRadius);
    
    CGPathAddArcToPoint(subPath, NULL,minx, maxy, minx, midy, cornerRadius);
    
    
    CGPathAddPath(mainPath, NULL, subPath);
    
    
    maskLayer.path = mainPath;
    view.layer.mask = maskLayer;
    CGPathRelease(subPath);
    CGPathRelease(mainPath);
}


@end


#pragma mark -
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
    [self example2];
}

- (void)example1
{
    self.photoPickupVC = [ZGPhotoPickupController photoPickupWithViewController:self completeBlock:^(NSArray *imageArray, NSArray *assetArray, NSInteger code) {
        NSLog(@"image pickup success");
    }];
    
    [self.photoPickupVC show];

}

/**
 * 该样例: 必须真机运行
 */
- (void)example2
{
    UIView *overlayView;
    overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 40.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 40.0 - 100.0)];
    
    
    CGFloat idCardBorderImgViewWidth = 260.0;
    CGFloat idCardBorderImgViewHeight = idCardBorderImgViewWidth / (8.0 / 5.0);
    CGRect idCardBorderImgViewFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width - idCardBorderImgViewWidth) / 2.0, ([UIScreen mainScreen].bounds.size.height - idCardBorderImgViewHeight) / 2.0 - 64.0, idCardBorderImgViewWidth, idCardBorderImgViewHeight);
    
    MYQPhotoGraphFillColorView *bgColorView = [[MYQPhotoGraphFillColorView alloc] initWithFrame:overlayView.bounds];
    //        [bgColorView clipWithRect:idCardBorderImgViewFrame];
    //        [bgColorView setMaskLayerWithView:bgColorView maskRect:idCardBorderImgViewFrame cornerRadius:15.f];
//    [bgColorView bezierMaskLayerWithView:bgColorView maskRect:idCardBorderImgViewFrame cornerRadius:15.f];
    bgColorView.clipRect = idCardBorderImgViewFrame;
    bgColorView.cornerRadius = 15.f;
    [overlayView addSubview:bgColorView];
    
    
    UIImageView *idCardBorderImgView = [[UIImageView alloc] init];
    UIImage *img = [UIImage imageNamed:@"id_finder"];
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(20, 20, 20, 20);
    idCardBorderImgView.image = [img resizableImageWithCapInsets:edgeInset resizingMode:UIImageResizingModeStretch];
    idCardBorderImgView.frame = idCardBorderImgViewFrame;
    [overlayView addSubview:idCardBorderImgView];
    
    CGFloat tipLabelWidth = 200.0;
    CGFloat tipLabelHeight = 20.0;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - tipLabelWidth) / 2.0, CGRectGetMaxY(idCardBorderImgView.frame) + 5.0, tipLabelWidth, tipLabelHeight)];
    tipLabel.text = @"请将卡片边缘对齐方框以便拍照";
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [overlayView addSubview:tipLabel];


    
    self.photoPickupVC = [ZGPhotoPickupController photoPickupWithViewController:self completeBlock:^(NSArray *imageArray, NSArray *assetArray, NSInteger code) {
        NSLog(@"image pickup success");
    }];
    
    self.photoPickupVC.photoGraphVC.cameraOverlayView = overlayView;
    [self.photoPickupVC show];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
