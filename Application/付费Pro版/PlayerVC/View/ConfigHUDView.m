//
//  ConfigHUDView.m
//  TestApp
//
//  Created by hong  on 2018/1/15.
//  Copyright © 2018年 洪正烨. All rights reserved.
//

#import "ConfigHUDView.h"
#import "PlayerTool.h"
#import "PlayerVC.h"





@interface ConfigHUDView () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *subtitleBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

/** lastBtn */
@property(nonatomic,strong)UIButton *lasMutiBtn;


/** lastRateBtn */
@property(nonatomic,strong)UIButton *lastRateBtn;
@property (weak, nonatomic) IBOutlet UITableView *subtitleTBV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subtitleBtnHight;

@property (strong, nonatomic) NSMutableArray *subtitleArr;



@property (strong, nonatomic) NSMutableArray *portraitRatioArr;

@property (strong, nonatomic) NSMutableArray *landscapeRatioArr;


@end

@implementation ConfigHUDView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_defaultBtn setTitle:LOCALKEY(@"Default") forState:UIControlStateNormal];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = true;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = true;
            btn.titleLabel.font = FONT_SIZE(13);
            if (btn.tag == 101) {
                _lasMutiBtn = btn;
                btn.backgroundColor = RGB(160, 160, 160, 1);
            }else if (btn.tag == 107) {
                _lastRateBtn = btn;
                btn.backgroundColor = RGB(160, 160, 160, 1);
            }
        }
    }
    _subtitleTBV.delegate = self;
    _subtitleTBV.dataSource = self;
    _subtitleTBV.rowHeight = 25.0;
    _subtitleTBV.layer.cornerRadius = 3;
    _subtitleTBV.layer.masksToBounds = true;
    _subtitleTBV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_subtitleTBV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _RateLB.text = [NSString stringWithFormat:@"%@ :",LOCALKEY(@"Ratio")];
    _SubTitleLB.text = [NSString stringWithFormat:@"%@ :",LOCALKEY(@"Subtitle")];
    _PlaySpeedLB.text = [NSString stringWithFormat:@"%@ :",LOCALKEY(@"Rate")];
}


- (IBAction)HUDBtnAction:(UIButton *)sender {
    if (sender.tag <= 104) {
        char *ratio = "16:9";
        _lasMutiBtn.selected = false;
        _lasMutiBtn.backgroundColor = RGB(60, 60, 60, 60);
        sender.backgroundColor = RGB(160, 160, 160, 1);
        switch (sender.tag) {
            case 101:{
//                [PLAYER.media parseWithOptions:nil];
                
                
//                NSLog(@"%@",Playing.media.metaDictionary);
//                NSArray *trackInfoArr = Playing.media.tracksInformation;
//
//                CGSize videoSize =  PLAYER.videoSize;
//                CGFloat width = videoSize.width;
//                CGFloat height = videoSize.height;
//                NSString *ratioStr;
//                if (trackInfoArr.count) {
//                    width = [[trackInfoArr[0] objectForKey:@"width"] floatValue];
//                    height = [[trackInfoArr[0] objectForKey:@"height"] floatValue];
//                    ratioStr = [NSString stringWithFormat:@"%.0f:%.0f",width,height];
//                }
//                ratioStr = [NSString stringWithFormat:@"%.0f:%.0f",width,height];
//                if ([ratioStr canBeConvertedToEncoding:NSUTF8StringEncoding]) {
//                    ratio = [ratioStr cStringUsingEncoding:NSUTF8StringEncoding];
//                }
                ratio = "0";
            }break;
            case 102:ratio = "16:10";break;
            case 103:ratio = "4:3";break;
            case 104:{
                ratio = "1:1";break;
            };break;
            default:break;
        }
         [self changeRatio:ratio];
        _lasMutiBtn = sender;
    }else if (sender.tag >= 106){
          CGFloat rate = 0.0;
        _lastRateBtn.selected = false;
        _lastRateBtn.backgroundColor = RGB(60, 60, 60, 60);
        sender.backgroundColor = RGB(160, 160, 160, 1);
        switch (sender.tag) {
            case 106:rate = 0.5; break;
            case 107:rate = 1.0;break;
            case 108:rate = 1.25;break;
            case 109:rate = 1.5;break;
            default:break;
        }
        [self changeRate:rate];
        _lastRateBtn = sender;
    }else{
        [self blowUpBtn:sender];
    }
}


#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.subtitleArr.count) {
        return 1;
    }
    return self.subtitleArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = FONT_SIZE(12);
    if (self.subtitleArr.count) {
        cell.textLabel.text = self.subtitleArr[indexPath.row];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@!",LOCALKEY(@"NoSubtitle")];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_subtitleBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        _subtitleBtnHight.constant = 25;
        [self.superview layoutIfNeeded];
    }];
    
    if (_subtitleArr.count > 0) {
        NSString *subtitlePath  = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",_subtitleArr[indexPath.row]]];
        [self openSubTitles:subtitlePath];
    }
    _subtitleTBV.userInteractionEnabled = false;
    [_subtitleTBV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - response
/** 设置字幕 */
- (void)openSubTitles:(NSString *)path{
}

- (void)changeRatio:(char *)ratio{
}

- (void)changeRate:(CGFloat)rate{
}

#pragma mark - setter && getter
- (NSMutableArray *)subtitleArr{
    if (!_subtitleArr) {
        _subtitleArr = [PlayerTool searchSubTitlesFilePath];
    }
    return _subtitleArr;
}


- (void)blowUpBtn:(UIButton *)button{
    if (!button.isSelected) {
        [UIView animateWithDuration:0.5 animations:^{
            _subtitleBtnHight.constant = self.frame.size.height;
            [self.superview layoutIfNeeded];
        }];
        _subtitleTBV.userInteractionEnabled = true;
    }
//    button.selected = false;
}

@end
