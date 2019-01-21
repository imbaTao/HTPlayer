//
//  SettingViewController.h
//  HZYToolBox
//
//  Created by hong  on 2018/7/2.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "BaseViewController.h"
#import "SettingTableView.h"
#import "SettingStatusModel.h"
#import "UIBarButtonItem+SXCreate.h"
#import "SettingTool.h"
#import "LockerVC.h"
#import "FeedBackVC.h"

@interface SettingViewController : BaseViewController<BaseTableViewCellDelegate,MFMailComposeViewControllerDelegate>
/** SettingTableView */
@property(nonatomic,strong)SettingTableView *SettingTableView;



@end
