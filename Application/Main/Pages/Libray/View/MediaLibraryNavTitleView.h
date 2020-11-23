//
//  MediaLibraryNavTitleView.h
//  敢聊播放器
//
//  Created by Mr.h on 2018/9/9.
//  Copyright © 2018年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MediaLibraryNavTitleDelegate <NSObject>
// 0是搜索，1是菜单
- (void)naviButtonActionWithType:(NSInteger)type;
@end
@interface MediaLibraryNavTitleView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchButtonLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuButtonRightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


/** 代理 */
@property(nonatomic,weak)id <MediaLibraryNavTitleDelegate> delegate;
@end
