//
//  LinkTableViewCell.m
//  HZYToolBox
//
//  Created by hong  on 2018/7/5.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "LinkTableViewCell.h"
#import "LinkGuideCell.h"


#pragma mark - CELL

@interface LinkTableViewCell()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation LinkTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backGroundImgView];
        [self.backGroundImgView addSubview:self.explainTextView];
//        [self.backGroundImgView addSubview:self.subTableView];
        [self.backGroundImgView addSubview:self.guideImgView];
        [self layoutPageViews];
//        [_subTableView reloadData];
    }
    return self;
}


- (void)layoutPageViews{
    [self.backGroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.explainTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(left(21));
        make.top.offset(top(10));
        make.bottom.mas_equalTo(self.guideImgView.mas_bottom);
        make.right.mas_equalTo(self.guideImgView.mas_left).offset(-right(5));
    }];
    
//    [self.subTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(left(21));
//        make.top.offset(top(6));
//        make.bottom.offset(bottom(-6));
//        make.right.mas_equalTo(self.guideImgView.mas_left).offset(-right(5));
//    }];
    
    [self.guideImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.offset(-right(15));
        make.width.mas_equalTo(self.guideImgView.mas_height);
        make.height.offset(SCREEN_W * 0.3867);
    }];
}

#pragma mark - UITableViewDelegate
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    LinkGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:self.subTableView.cellID];
//    cell.titleLB.text = [NSString stringWithFormat:@"%ld.%@",indexPath.section + 1,self.subTableView.dataArray[indexPath.section]];
////    if (indexPath.section == 3 && _isSecondCell) {
////        cell.titleLB.font = FONT_SIZE(14);
////        cell.titleLB.textColor = [UIColor redColor];
////    }
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.subTableView.dataArray.count;
//}


#pragma mark - delegate
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return top(15);//section头部高度
    }
    return top(5);//section头部高度
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, top(15))];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return top(5);
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, top(15))];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - Setter && Getter
//- (BaseTableView *)subTableView{
//    if (!_subTableView) {
//        _subTableView = [[BaseTableView alloc] initWithCellClass:[LinkGuideCell class] identifier:@"GuideCell" style:UITableViewStyleGrouped];
//        _subTableView.delegate = self;
//        _subTableView.dataSource = self;
//        _subTableView.backgroundColor = [UIColor clearColor];
//        _subTableView.userInteractionEnabled = false;
//        _subTableView.rowHeight = top(40);
//        if (KIsiPhoneX) {
//            _subTableView.rowHeight = 45;
//        }
//    }
//    return _subTableView;
//}

- (UIImageView *)backGroundImgView{
    if (!_backGroundImgView) {
        _backGroundImgView = [[UIImageView alloc] init];
        _backGroundImgView.contentMode = UIViewContentModeScaleToFill;
        _backGroundImgView.userInteractionEnabled = true;
    }
    return _backGroundImgView;
}

- (UITextView *)explainTextView{
    if (!_explainTextView) {
        _explainTextView = [[UITextView alloc] init];
        [_explainTextView setScrollEnabled:YES];
        _explainTextView.userInteractionEnabled = YES;
        _explainTextView.showsVerticalScrollIndicator = YES;
        
        _explainTextView.font = [UIFont systemFontOfSize:14];
        _explainTextView.textColor = [UIColor whiteColor];
        _explainTextView.backgroundColor = [UIColor clearColor];
//        _explainTextView.contentSize = CGSizeMake(1000, 1000);
        _explainTextView.editable = false;
        
    }
    return _explainTextView;
}

- (UIImageView *)guideImgView{
    if (!_guideImgView) {
        _guideImgView = [[UIImageView alloc] init];
    }
    return _guideImgView;
}
@end
