//
//  SettingTableView.h
//  HZYToolBox
//
//  Created by hong  on 2018/7/2.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "BaseTableView.h"
@interface SettingTableView : BaseTableView
@end

@interface SettingTableViewCell: UITableViewCell

/** leftTitleLB */
@property(nonatomic,strong)UILabel *leftTitleLB;
/** rightImgView */
@property(nonatomic,strong)UIImageView *rightImgView;
@end
