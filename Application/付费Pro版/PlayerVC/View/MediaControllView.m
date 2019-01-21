//
//  MediaControllView.m
//  TinyPlayer_V1
//
//  Created by Mr.H on 2017/12/8.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "MediaControllView.h"
#import "PlayerTool.h"
#import "PlayerVC.h"


@interface MediaControllView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playProgressWidth;

@property (weak, nonatomic) IBOutlet UILabel *segementLB;


@end

@implementation MediaControllView

#pragma mark - respons

- (void)awakeFromNib{
    [super awakeFromNib];
    _playListBtn.layer.cornerRadius = _playListBtn.mj_h * 0.5;
    _playListBtn.layer.borderWidth = 1.0;
    _playListBtn.layer.borderColor = RGB(98, 98, 98, 1).CGColor;
    _playListBtn.backgroundColor = [UIColor clearColor];
    [_playListBtn setTitle:LOCALKEY(@"playlist") forState:UIControlStateNormal];
    _playListBtn.titleLabel.font = FONT_SIZE(13);
    _playedTimeLb.font = FONT_SIZE(12);
    _allPlayTimeLb.font = FONT_SIZE(12);
    _segementLB.font = FONT_SIZE(12);
}

/** 播放或暂停事件 */
- (IBAction)playOrPauseAction:(UIButton *)sender {
}

/** 播放下一个事件 */
- (IBAction)playNextAction:(UIButton *)sender {
}

/** 播放列表事件 */
- (IBAction)playListAction:(UIButton *)sender {
    if (!sender.isSelected) {
        _playListBtn.layer.borderColor = RGB(98, 98, 98, 1).CGColor;
        [_mediaView p_unfoldListTBV];
    }
    sender.selected = !sender.selected;
}

/** 设置按钮事件 */
- (IBAction)configAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    if (!sender.isSelected) {
        [sender setImage:[UIImage imageNamed:@"PlayPic_settingDown"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            _mediaView.configView.alpha  = 1;
        }completion:^(BOOL finished) {
            sender.userInteractionEnabled = true;
        }];
    }else{
         [sender setImage:[UIImage imageNamed:@"PlayPic_setting"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            _mediaView.configView.alpha  = 0;
        }completion:^(BOOL finished) {
            sender.userInteractionEnabled = true;
        }];
    }
    sender.selected = !sender.selected;
}

/** 全屏按钮点击事件 */
- (IBAction)fullScreenAction:(UIButton *)sender {
    if (!sender.isSelected) {
        [PlayerTool orientationTo:UIInterfaceOrientationLandscapeRight];
    }else{
        [PlayerTool orientationTo:UIInterfaceOrientationPortrait];
    }
    sender.selected = !sender.selected;
}


#pragma mark - Private
- (void)refreshTime{
    _playedTimeLb.text = [PlayerTool takeTimeStrTimeValue:Playing.recordLength];
    _playProgressWidth.constant = SCREEN_W * Playing.recordLength / Playing.mediaLength ;
}

@end
