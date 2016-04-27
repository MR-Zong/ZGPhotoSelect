//
//  MYQPictureRedPacketSetMoneyViewController.m
//  MianYangQuan
//
//  Created by Zong on 16/4/11.
//  Copyright © 2016年 kk. All rights reserved.
//

#import "MYQPictureRedPacketSetMoneyViewController.h"

@interface MYQPictureRedPacketSetMoneyViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;


@property (weak, nonatomic) IBOutlet UITextField *wordsTextField;


@property (weak, nonatomic) IBOutlet UIView *moneyContainView;


@property (weak, nonatomic) IBOutlet UIView *wordsContainView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonTopContrain;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation MYQPictureRedPacketSetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"红包图";
    if (self.titleString) {
        self.navigationItem.title = self.titleString;
        if ([self.titleString isEqualToString:@"私密照"]) {
            self.wordsContainView.hidden = YES;
            self.sendButtonTopContrain.constant = 0;
        }else{
            self.wordsContainView.hidden = NO;
            self.sendButtonTopContrain.constant = 40;
        }
    }
    [self.moneyTextField becomeFirstResponder];
    self.moneyTextField.delegate = self;
    self.wordsContainView.backgroundColor = MYQ_Default_Cell_Background;
    self.wordsTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"快来看看我私藏的照片吧~" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:0xababab]}];
    self.moneyContainView.backgroundColor = MYQ_Default_Cell_Background;
    
    
    self.sendButton.layer.cornerRadius = 10;
    self.sendButton.layer.masksToBounds = YES;
    if (self.sendButtonTitleString) {
        
        [self.sendButton setTitle:self.sendButtonTitleString forState:UIControlStateNormal];
    }
    [self.sendButton setBackgroundImage:[UIImage imageFromColor:[UIColor redColor] size:self.sendButton.frame.size] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)sendButton:(id)sender {
    
    
    [self.view endEditing:YES];
    CGFloat money = self.moneyTextField.text.floatValue;
    if (money < 1.0 || money > 2000.0) {
          [self showAlertMessage:@"红包图金额支持范围为1-2000哦~" view:self.view];
        return;
    }else {
        NSString *leaveMessage = @"快来看看我私藏的照片吧~";
        if (self.wordsTextField.text.length > 0) {
            leaveMessage = self.wordsTextField.text;
        }
        if (self.redPacketPicSendBlock) {
            self.redPacketPicSendBlock(self.moneyTextField.text.floatValue,leaveMessage);
        }
    }
    
    
    
}


#pragma mark - didTextFieldChange
- (void)didTextFieldChange:(NSNotification *)note
{
    NSArray *arr = [self.moneyTextField.text componentsSeparatedByString:@"."];
    if (arr.count > 1) {
        NSString *doctString = arr.lastObject;
        if (doctString.length > 1) {
            self.moneyTextField.text = [NSString stringWithFormat:@"%@.%c",arr.firstObject,[doctString characterAtIndex:0]];
        }
    }
        
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showAlertMessage:(NSString *)message view:(UIView *)view
{
    
}



@end
