//
//  LinkTableView.h
//  HZYToolBox
//
//  Created by hong  on 2018/7/2.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "BaseTableView.h"
#import "LinkTableViewCell.h"
#import "GCDWebUploader.h"
@interface LinkTableView : BaseTableView
/** webServer */
@property(nonatomic,strong)GCDWebUploader *webServer;
- (void)closeServer;
@end




