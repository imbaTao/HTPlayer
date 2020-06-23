//
//  MediaLibraryNavTitleView.m
//  WhatsPlayer
//
//  Created by Mr.h on 2018/9/9.
//  Copyright © 2018年 Great. All rights reserved.
//

#import "MediaLibraryNavTitleView.h"

@interface MediaLibraryNavTitleView()
@property (weak, nonatomic) IBOutlet UIButton *searchButton;


@end

@implementation MediaLibraryNavTitleView
- (void)awakeFromNib{
    [super awakeFromNib];
    _searchBar.alpha = 0;
    UITextField *searchTextField  = [_searchBar valueForKey:@"searchField"];
    searchTextField.leftView = nil;
//    UITextField *searchField=[_searchBar valueForKey:@"searchField"];
    searchTextField.subviews[0].backgroundColor = [UIColor whiteColor];
    searchTextField.subviews[0].layer.cornerRadius = 8;
    searchTextField.textColor = StyleColor;
    searchTextField.font = FONT_SIZE(14);

    _searchBar.tintColor = StyleColor;
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.placeholder = LOCALKEY(@"Search");
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchBar positionAdjustmentForSearchBarIcon:UISearchBarIconSearch];
}

- (IBAction)searchAction:(UIButton *)sender {
        [self.delegate naviButtonActionWithType:0];
}

- (IBAction)menuAction:(UIButton *)sender {
    [self.delegate naviButtonActionWithType:1];
}




@end
