//
//  SettingViewController_Free.m
//  WhatsPlayer
//
//  Created by Mr.h on 12/9/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import "SettingViewController_Free.h"
#import "PaymentManager.h"
#import "Tabbar_Free.h"
@interface SettingViewController_Free ()<BaseTableViewCellDelegate,PaymentManagerDelegate>
/** paymentManager */
@property(nonatomic,strong)PaymentManager *paymentManager;
@end


@implementation SettingViewController_Free
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(restoreBtnAction) title:LOCALKEY(@"ResumeBuy")];
    self.paymentManager.delegate = self;
}

#pragma mark - TaleViewCellSelectedDelegate
- (void)cellSelectedWithIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{// 去广告
            [self.paymentManager removeAdAction];
        }break;
        case 2:{
            LockerVC *lockVC = [[LockerVC alloc]init];
            lockVC.completeBlock = ^(BOOL isOpen) {
                SettingStatusModel *statusModel = self.SettingTableView.dataArray[2];
                statusModel.canUse = isOpen;
                [self.SettingTableView reloadData];
            };
            [self presentViewController:lockVC animated:true completion:nil];
        }break;
        case 3:{
            FeedBackVC *feedBackVC = [[FeedBackVC alloc] init];
            // 设置邮件代理
            [feedBackVC setMailComposeDelegate:self];
            if (feedBackVC) {
                [self.navigationController presentViewController:feedBackVC animated:true completion:nil];
            }
        }break;
        default:break;
    }
}

#pragma mark - 恢复购买事件
- (void)restoreBtnAction{
    [self.paymentManager recoverPaymentAction];
}


#pragma mark - 购买完成后代理事件
- (void)paymentCompletWithProductType:(ProductType)type{
    switch (type) {
        case Product_AD:{
            // 改变勾勾
            SettingStatusModel *statusModel = self.SettingTableView.dataArray[0];
            statusModel.buyed = true;
            [self.SettingTableView reloadData];
            HUD_Right(@"");
//            // 更改高度
//            HZYTabbarController *soucreBarVC = (HZYTabbarController *)self.navigationController.tabBarController;
//            Tabbar_Free *bar = (Tabbar_Free *)soucreBarVC.customBar;
//            [bar.bannerBackBoardView removeFromSuperview];
//            [[HTAdTool share].bannerView removeFromSuperview];
//            [self.view layoutIfNeeded];
//            [UIView animateWithDuration:0.7 animations:^{
//                [soucreBarVC.customBar mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.width.offset(SCREEN_W);
//                    make.left.offset(0);
//                    make.bottom.offset(0);
//                    make.height.offset(49);
//                }];
//            }completion:^(BOOL finished) {
            
//            }];
        }break;
        default:break;
    }
}

#pragma mark - Setter && Getter
- (PaymentManager *)paymentManager{
    if (!_paymentManager) {
        _paymentManager = [[PaymentManager alloc] init];
    }
    return _paymentManager;
}

- (CGSize)sizeWithString:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (BOOL)shouldAutorotate {
    return false;
}
@end
