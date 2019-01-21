//
//  MediaEditMenuView.h
//  TinyPlayer_V1
//
//  Created by Mr.h on 2018/3/17.
//  Copyright © 2018年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaEditMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *seletedAllBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarLeftConstraint;

+ (MediaEditMenuView *)creat;



@end
