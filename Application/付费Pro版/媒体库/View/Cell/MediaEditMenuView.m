//
//  MediaEditMenuView.m
//  TinyPlayer_V1
//
//  Created by Mr.h on 2018/3/17.
//  Copyright © 2018年 Great. All rights reserved.
//

#import "MediaEditMenuView.h"

@implementation MediaEditMenuView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    // 找到searchbar的searchField属性
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        searchField.textColor = GlobalTextColor;
        searchField.font = [UIFont systemFontOfSize:14];
        
        // 根据@"_placeholderLabel.textColor" 找到placeholder的字体颜色
        [searchField setValue:GlobalTextColor forKeyPath:@"_placeholderLabel.textColor"];
        // 圆角
        searchField.layer.cornerRadius = 10.0f;
        searchField.layer.masksToBounds = YES;
        searchField.placeholder = NSLocalizedString(@"Search", nil);
    }
    
}



+ (MediaEditMenuView *)creat{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}


- (IBAction)seletedAllAction:(UIButton *)sender {
    [self btnAction:sender];
}

- (void)btnAction:(UIButton *)sender{
    
}



@end
