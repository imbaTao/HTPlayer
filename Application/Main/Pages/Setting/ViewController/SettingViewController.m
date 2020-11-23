 //
//  SettingViewController.m
//  HZYToolBox
//
//  Created by hong  on 2018/7/2.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()


@end

@implementation SettingViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[HZYTabbarController share] showTabbar];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenLeftBtn];
    [self.view addSubview:self.SettingTableView];
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    HZYTabbarController *soucreBarVC = (HZYTabbarController *)self.navigationController.tabBarController;
    [_SettingTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.offset(SAFE.top);
        } else {
            make.top.offset(0);
        }
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.mas_equalTo(soucreBarVC.customBar.mas_top);
    }];
}

- (void)initData{
    self.SettingTableView.dataArray = [SettingTool takeTheSettingModel];
    [self.SettingTableView reloadData];
}

#pragma mark - TaleViewCellSelectedDelegate
- (void)cellSelectedWithIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            LockerVC *lockVC = [[LockerVC alloc]init];
            lockVC.completeBlock = ^(BOOL isOpen) {
                SettingStatusModel *statusModel = self.SettingTableView.dataArray[1];
                statusModel.canUse = isOpen;
                [self.SettingTableView reloadData];
            };
            lockVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:lockVC animated:true completion:nil];
        }break;
        case 1:{
            FeedBackVC *feedBackVC = [[FeedBackVC alloc] init];
            feedBackVC.modalPresentationStyle = UIModalPresentationFullScreen;
            // 设置邮件代理
            [feedBackVC setMailComposeDelegate:self];
            if (feedBackVC) {
                [self.navigationController presentViewController:feedBackVC animated:true completion:nil];
            }
        }break;
        default:break;
    }
}


#pragma mark - MFMailComposeViewControllerDelegate的代理方法：
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
           // NSLog(@"Mail send canceled: 用户取消编辑");
            break;
        case MFMailComposeResultSaved:
           // NSLog(@"Mail saved: 用户保存邮件");
            break;
        case MFMailComposeResultSent:
          //  NSLog(@"Mail sent: 用户点击发送");
            break;
        case MFMailComposeResultFailed:
         //   NSLog(@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGSize)sizeWithString:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (BOOL)shouldAutorotate {
    return false;
}

#pragma mark - Setter && Getter
- (SettingTableView *)SettingTableView{
    if (!_SettingTableView) {
        _SettingTableView = [[SettingTableView alloc] initWithCellClass:[SettingTableViewCell class] identifier:@"personalCell" style:UITableViewStyleGrouped];
        _SettingTableView.backgroundColor = [UIColor clearColor];
        _SettingTableView.cellDelegate = self;
        _SettingTableView.rowHeight = top(64);
        _SettingTableView.cellDelegate = self;
    }
    return _SettingTableView;
}


@end
