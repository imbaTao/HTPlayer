//
//  HZYReNameView.m
//  HZYToolBox
//
//  Created by hong  on 2018/9/5.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "HZYReNameView.h"
@interface HZYReNameView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleNameLB;
@property (weak, nonatomic) IBOutlet UILabel *sourceTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *sourceContentLB;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstants;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@end

@implementation HZYReNameView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.alpha = 0;
    _titleNameLB.font = FONT_SIZE(17);
    _sourceTitleLB.font = FONT_SIZE(15);
    _changeTitleTF.font = FONT_SIZE(14);
    _sourceContentLB.font = FONT_SIZE(13);
    _titleNameLB.text = LOCALKEY(@"Rename");
    _sourceTitleLB.text = LOCALKEY(@"Original");
    _changeTitleTF.placeholder = LOCALKEY(@"NewfileName");
    [_cancleButton setTitle:LOCALKEY(@"cancel") forState:UIControlStateNormal];
    [_OKButton setTitle:LOCALKEY(@"Ok") forState:UIControlStateNormal];
    _sourceContentLB.lineBreakMode =  NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _centerView.layer.cornerRadius = 8;
    _centerView.layer.shadowOffset = CGSizeMake(1, 2);
    _centerView.layer.shadowOpacity = 0.1;
    _changeTitleTF.delegate = self;
    if (IS_IPHONE_5) {
        _bottomConstants.constant = 6;
    }
}

#pragma mark - UITextFieldAction
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Response
- (IBAction)cancleAction:(id)sender {
     [_changeTitleTF resignFirstResponder];
    [self hid];
}

- (IBAction)OKAction:(UIButton *)sender {
    if (_changeTitleTF.text.length) {
        [self.delegate finishChangeFileName:_changeTitleTF.text];
    }
}

#pragma mark - private
- (void)showWithSourceName:(NSString *)sourceName{
    _sourceContentLB.text = sourceName;
//    CGFloat width = _centerView.w - _titleNameLB.x - 8;
//    CGFloat height = _changeTitleTF.y  - _titleNameLB.y - 8 - _sourceTitleLB.intrinsicContentSize.height;
//    if ([UILabel getLabelHeightWithText:sourceName width:width font:13] >= height) {
//        [_sourceTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_sourceTitleLB).priorityHigh();
//            make.left.equalTo(_sourceTitleLB.mas_right).offset(8).priorityHigh();
//            make.right.offset(-8);
//            make.bottom.mas_equalTo(_changeTitleTF.mas_top).offset(-8);
//        }];
//    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}




- (void)hid{
    __weak typeof(self)weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
         weakself.changeTitleTF.text = @"";
    }];
}
@end
