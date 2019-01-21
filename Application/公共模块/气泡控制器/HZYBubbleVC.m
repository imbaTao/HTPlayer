//
//  HZYBubbleVC.m
//  HZYToolBox
//
//  Created by hong  on 2018/8/28.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import "HZYBubbleVC.h"
#import "UIImage+extension.h"
#import "HZYPopoverBackgroundView.h"
#import "NSAttributedString+Colorful.h"
@interface ActivityBubbleModel : NSObject
/** 内容 */
@property(nonatomic,copy)NSString *content;

/** 图标 */
@property(nonatomic,copy)NSString *iconName;
@end
@implementation ActivityBubbleModel
@end

@interface HZYBubbleVC ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
/** dataArray */
@property(nonatomic,strong)NSMutableArray *dataArray;

/** contentWidth */
@property(nonatomic,assign)CGFloat contentWidth;
@end

#define HeaderHeight IS_IPHONE ? 10 + 30 + 10 : 120
@implementation HZYBubbleVC

- (instancetype)initWithTitleArr:(NSArray *)titleArr picNameArr:(NSArray *)picNameArr appointView:(id)appointView width:(CGFloat)width haveHeader:(BOOL)haveHeader{
    self = [super init];
    if (self) {
        if (titleArr.count != picNameArr.count) {
            return self;
        }else{
            for (int i = 0; i < titleArr.count; i++) {
                ActivityBubbleModel *model = [[ActivityBubbleModel alloc] init];
                model.content = titleArr[i];
                model.iconName = picNameArr[i];
                [self.dataArray addObject:model];
            }
            _appointView = appointView;
            _haveHeader = haveHeader;
            if (haveHeader) {
                self.preferredContentSize = CGSizeMake(width,titleArr.count * CellHeight + (HeaderHeight - 1));
            }else{
                self.preferredContentSize = CGSizeMake(width,titleArr.count * CellHeight - 1);
            }
            _contentWidth = width;
            self.modalPresentationStyle = UIModalPresentationPopover;
        }
    }
    return self;
}

/** 动态调整高度 */
- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    [self layoutPageViews];
}

- (void)layoutPageViews{
    [self.view addSubview:self.functionTableView];
    [self.functionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)showBubbleWithVC:(UIViewController *)vc{
    UIPopoverPresentationController *popController = [self popoverPresentationController];
    popController.backgroundColor = RGB(51, 51, 57,1);
    popController.delegate = self;
    //    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.popoverBackgroundViewClass = [HZYPopoverBackgroundView class];
    UIView *view = self.appointView;
    popController.sourceView = view;
    if (!_haveHeader) {
        popController.sourceRect = view.bounds;
    }else{
        popController.sourceRect = CGRectMake(0, 0, (SCREEN_W - _contentWidth) / 2,  SCREEN_H + self.dataArray.count * CellHeight + (HeaderHeight - 49 * 2));
    }
    [vc presentViewController:self animated:true completion:nil];
}

#pragma mark - BubbleDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    // click mask response
    //    [self dismissViewControllerAnimated:true completion:nil];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return true;
}



#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HZYBubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bubbleCell"];
    if (!self.haveHeader) {
        cell.contentLB.textAlignment = NSTextAlignmentCenter;
    }else{
        cell.contentLB.textAlignment = NSTextAlignmentLeft;
    }
    ActivityBubbleModel *model = self.dataArray[indexPath.row];
    cell.contentLB.text = model.content;
    cell.iconView.image = [UIImage imageNamed:model.iconName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate bubbleCellSelected:indexPath.row type:_haveHeader];
}

#pragma mark - Setter && Getter
- (UITableView *)functionTableView{
    if (!_functionTableView) {
        _functionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_functionTableView registerClass:[HZYBubbleCell class] forCellReuseIdentifier:@"bubbleCell"];
        _functionTableView.delegate = self;
        _functionTableView.dataSource = self;
        _functionTableView.backgroundColor = [UIColor clearColor];
        _functionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _functionTableView.showsVerticalScrollIndicator = NO;
        _functionTableView.scrollEnabled = false;
        _functionTableView.rowHeight = CellHeight;
        if (_haveHeader) {
            _headerView = [[HZYBubbleHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W * 0.8, HeaderHeight)];
            _functionTableView.tableHeaderView = _headerView;
        }
    }
    return _functionTableView;
}



#pragma mark - private
- (void)hideBubble{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
