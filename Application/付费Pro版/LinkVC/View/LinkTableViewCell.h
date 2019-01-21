//
//  LinkTableViewCell.h
//  HZYToolBox
//
//  Created by hong  on 2018/7/5.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
@interface LinkTableViewCell : UITableViewCell
/** x */
@property(nonatomic,strong)UIImageView *backGroundImgView;

/** guideImgView */
@property(nonatomic,strong)UIImageView *guideImgView;

///** subTableView */
//@property(nonatomic,strong)BaseTableView *subTableView;

/** explainTextView */
@property(nonatomic,strong)UITextView *explainTextView;

/** isSecondCell */
@property(nonatomic,assign)BOOL isSecondCell;



//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
