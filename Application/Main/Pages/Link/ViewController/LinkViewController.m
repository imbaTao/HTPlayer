//
//  HZYLinkViewController.m
//  HZYToolBox
//
//  Created by hong  on 2018/7/2.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "LinkViewController.h"
#import "LinkTableView.h"
#import "LinkTableViewCell.h"


@interface LinkViewController ()
/** LinkTableView */
@property(nonatomic,strong)LinkTableView *LinkTableView;
@end

@implementation LinkViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[HZYTabbarController share] showTabbar];
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    [self.navigationController setNavigationBarHidden:true];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.LinkTableView closeServer];
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenLeftBtn];
    [self.view addSubview:self.LinkTableView];
    self.LinkTableView.dataArray = [NSMutableArray arrayWithArray:@[@"连接方式一",@"连接方式二"]];
    [self.LinkTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    HZYTabbarController *soucreBarVC = (HZYTabbarController *)self.navigationController.tabBarController;
    [self.LinkTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.offset(10 + SAFE.top);
        } else {
            make.top.offset(10);
        }
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.mas_equalTo(soucreBarVC.customBar.mas_top);
    }];
}


#pragma mark - TaleViewCellSelectedDelegate
- (void)cellSelectedWithIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"选中了");
}

#pragma mark - Setter && Getter
- (LinkTableView *)LinkTableView{
    if (!_LinkTableView) {
        _LinkTableView = [[LinkTableView alloc] initWithCellClass:[LinkTableViewCell class] identifier:@"DiscoverCell" style:UITableViewStyleGrouped];
        
//        _LinkTableView.scrollEnabled = false;
        _LinkTableView.rowHeight = SCREEN_W * 0.72;
        if (KIsiPhoneX) {
            _LinkTableView.rowHeight = SCREEN_W * 0.8;
        }
        _LinkTableView.showsVerticalScrollIndicator = false;
        if (@available(iOS 11.0, *)) {
        _LinkTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        }
    }
    return _LinkTableView;
}

@end
