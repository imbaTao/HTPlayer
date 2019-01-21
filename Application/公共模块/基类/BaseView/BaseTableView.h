//
//  BaseTableView.h
//  HZYToolBox
//
//  Created by hong  on 2018/7/2.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BaseTableViewCellDelegate <NSObject>
@optional;
- (void)cellSelectedWithIndexPath:(NSIndexPath *)indexPath;
@end


@interface BaseTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

/** cellDelegate */
@property(nonatomic,weak)id <BaseTableViewCellDelegate> cellDelegate;
/** dataArray */
@property(nonatomic,strong)NSMutableArray *dataArray;

/** ID */
@property(nonatomic,copy)NSString *cellID;


- (instancetype)initWithCellClass:(id)class identifier:(NSString *)identifier style:(UITableViewStyle)style;

@end
