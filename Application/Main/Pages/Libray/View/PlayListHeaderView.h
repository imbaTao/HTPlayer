//
//  PlayListHeaderView.h
//  TinyPlayer_V1
//
//  Created by hong on 2017/6/4.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol playListHeaderViewDelegate <NSObject>

/** headerViewBtnAction */
- (void)headBtnClick:(UIButton *)btn;

@end





@interface PlayListHeaderView : UIView

/** delegate */
@property(nonatomic,weak) id<playListHeaderViewDelegate
> delegate;




/** playListName */
@property(nonatomic,strong) UILabel *playListNameLB;


/** editBtn */
@property(nonatomic,strong) UIButton *editBtn;

/** deleteListBtn */
@property(nonatomic,strong) UIButton *deleteListBtn;





@end
