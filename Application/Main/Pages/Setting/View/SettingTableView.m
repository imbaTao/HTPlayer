//
//  SettingTableView.m
//  HZYToolBox
//
//  Created by hong  on 2018/7/2.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "SettingTableView.h"
#import "SettingStatusModel.h"
@implementation SettingTableView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingStatusModel *model = self.dataArray[indexPath.row];
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellID];
    cell.leftTitleLB.text = model.titleName;
    cell.rightImgView.image = model.buyed ? [UIImage imageNamed:@"setting_tick"]:[UIImage imageNamed:@"setting_untick"];
    if (model.canUse) {
        cell.rightImgView.image = [UIImage imageNamed:@"nav_rightArrow"];
    }
    return cell;
}


//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{\
    return top(10);//section头部高度
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W,15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataArray.count - 1) {
        return bottom(49 + 5);
    }
    return bottom(5);
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.cellDelegate cellSelectedWithIndexPath:indexPath];
}
@end



#pragma mark - CELL
@interface SettingTableViewCell ()
/** backBoardView */
@property(nonatomic,strong)UIView *backBoardView;
/** segementLine */
@property(nonatomic,strong)UIView *segementLine;
@end
@implementation SettingTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.15;
        self.layer.shadowOffset = CGSizeMake(0, 2.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.backBoardView];
//        [self addSubview:self.segementLine];
        [self addSubview:self.leftTitleLB];
        [self addSubview:self.rightImgView];
        [self layoutPageViews];
    }
    return self;
}

- (void)layoutPageViews{
    [self.backBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    [self.segementLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(0);
//        make.left.offset(0);
//        make.right.offset(0);
//        make.height.offset(0.5);
//    }];

    [self.leftTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.offset(12).priorityHigh();
        make.right.mas_equalTo(self.rightImgView.mas_right).offset(-12);
    }];

    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.offset(-12);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark - Setter && Getter
- (UIView *)backBoardView{
    if (!_backBoardView) {
        _backBoardView = [[UIView alloc] init];
        _backBoardView.backgroundColor = StyleColor;
//        _backBoardView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _backBoardView.layer.shadowOpacity = 0.8;
//        _backBoardView.layer.shadowOffset = CGSizeMake(0, 4);
    }
    return _backBoardView;
}

- (UIView *)segementLine{
    if (!_segementLine) {
        _segementLine = [[UIView alloc] init];
        _segementLine.backgroundColor = RGB(94, 94, 94, 1);
    }
    return _segementLine;
}


- (UILabel *)leftTitleLB{
    if (!_leftTitleLB) {
        _leftTitleLB = [UILabel creatLabelWithText:@"xxxx" textColor:[UIColor whiteColor] fontSize:14];
        _leftTitleLB.backgroundColor = [UIColor clearColor];
        _leftTitleLB.textAlignment = NSTextAlignmentLeft;
    }
    return _leftTitleLB;
}

- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
    }
    return _rightImgView;
}

@end


