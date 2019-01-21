//
//  MediaView.m
//  TinyPlayer_V1
//
//  Created by hong on 2017/5/6.
//  Copyright © 2017年 Great. All rights reserved.
//

#import "MediaView.h"
#import "UILabel+extension.h"
#import "UIButton+extension.h"
#import "MediaPlayCell.h"
#import "VolumeAndBrightHUDView.h"
#import "ProgressHUDView.h"
#import "PlayerTool.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MediaTool.h"
#import "MediaModel.h"
#import "HZYGCDLater.h"

typedef NS_OPTIONS(NSInteger, GesturePosition){
    LEFT = 1,
    CENTER,
    RIGHT
};

#define ListWidth SCREEN_H >= 1024 ? 300 : 200
#define VolumeBrightWidth 28

@interface MediaView (){
    CGPoint _beginPoint;
    CGPoint _firstPoint;
    CGPoint _lastPoint;
    GesturePosition _fingerPosition;
    
    
    CGFloat _defaultBright;
    CGFloat _defaultVolume;
}

/** voluemHUD */
@property(nonatomic,strong)VolumeAndBrightHUDView *volumeHUDView;

/** brightHUD */
@property(nonatomic,strong)VolumeAndBrightHUDView *brightHUDView;

/** progressHUD */
@property(nonatomic,strong)ProgressHUDView *progressHUDView;

/** volumeView */
@property(nonatomic,strong) MPVolumeView *volumeView;

/** model */
@property(nonatomic,weak)MediaModel *mediaModel;

/** isChanging */
@property(nonatomic,assign)BOOL isChanging;

/** fileWatherTask */
@property(nonatomic,copy)GCDTask controllTask;


@end

@implementation MediaView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.playView];
        [self addSubview:self.volumeView];
        [self addSubview:self.volumeHUDView];
        [self addSubview:self.brightHUDView];
        [self addSubview:self.progressHUDView];
        [self addSubview:self.playListTBV];
        [self addSubview:self.configView];
        [self willNotBeChangeLayout];
        [self configGesture];
//        //系统声音改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
    return self;
}

- (void)willBeChangeLayout{
    [_progressHUDView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-44.5);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(SCREEN_W * 0.6);
        make.height.offset(30);
    }];
    
    [_configView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W * 0.7 , SCREEN_W * 0.3));
    }];
}

- (void)willNotBeChangeLayout{
    [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [_volumeHUDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.offset(30);
        make.size.mas_equalTo(CGSizeMake(VolumeBrightWidth, 170));
    }];
    
    [_brightHUDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.offset(-30);
        make.size.mas_equalTo(CGSizeMake(VolumeBrightWidth, 170));
    }];
    
    [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.offset(2000);
         make.top.offset(2000);
         make.size.mas_equalTo(CGSizeMake(1, 1));
     }];

    [_playListTBV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(ListWidth);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(ListWidth);
    }];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_defaultBright) {
        _defaultBright  = [UIScreen mainScreen].brightness;
    }
    _brightHUDView.valueViewConstraint.constant = _brightHUDView.grayBackView.mj_h * _defaultBright;
     UISlider *volumeSilder;
    if (!_defaultVolume) {
        for (UIView *view in [self.volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeSilder = (UISlider*)view;
                break;
            }
        }
    }
    _brightHUDView.valueViewConstraint.constant = _brightHUDView.grayBackView.mj_h * _defaultBright;
    _volumeHUDView.valueViewConstraint.constant = _volumeHUDView.grayBackView.mj_h * volumeSilder.value;
    [self willBeChangeLayout];
}

#pragma mark - notification
-(void)volumeChanged:(NSNotification *)notification {
     _defaultVolume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    _volumeHUDView.valueViewConstraint.constant = _defaultVolume * _volumeHUDView.grayBackView.mj_h;
}

#pragma mark - ReponseActive
// 更改进度，声音，亮度手势
- (void)panAction:(UIPanGestureRecognizer *)sender{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            _isChanging = true;
            _beginPoint = _firstPoint = _lastPoint =  [sender locationInView:self];
            if (_beginPoint.x > 0 && _beginPoint.x <= SCREEN_W * 0.2) {
                _fingerPosition = LEFT;
                _brightHUDView.alpha = 1;
            }else if(_beginPoint.x >= SCREEN_W * 0.8){
                _fingerPosition = RIGHT;
                 _volumeHUDView.alpha = 1;
            }else{
                _fingerPosition = CENTER;
                _progressHUDView.alpha = 1;
                if (PLAYER.isPlaying) {
                    [PLAYER pause];
                    [_controllView.playOrPauseBtn setImage:[UIImage imageNamed:@"PlayPic_play"] forState:UIControlStateNormal];
                }
            }
        }break;
        case UIGestureRecognizerStateChanged:{
            _firstPoint = _lastPoint;
            _lastPoint = [sender locationInView:self];
        }break;
        case UIGestureRecognizerStateEnded:{
            switch (_fingerPosition) {
                case LEFT:{
                    _brightHUDView.alpha = 0;
                }break;
                case RIGHT:{
                     _volumeHUDView.alpha = 0;
                     _isChanging = false;
                     return;
                }break;
                case CENTER:{
                    _progressHUDView.alpha = 0;
                    PLAYER.position = (CGFloat)Playing.recordLength / Playing.mediaLength;
                    if (!PLAYER.playing) {
                        [PLAYER play];
                        [_controllView.playOrPauseBtn setImage:[UIImage imageNamed:@"PlayPic_pause"] forState:UIControlStateNormal];
                    }
                    return;
                }
                default:break;
            }
        }
        default: break;
    }
    
    switch (_fingerPosition) {
        case LEFT:[self changeBrightness:_firstPoint.y - _lastPoint.y];break;
        case RIGHT:[self changeVolume:_firstPoint.y - _lastPoint.y];break;
        case CENTER: [self changeProgress:_lastPoint.x - _firstPoint.x];break;
        default:break;
    }
}

// 更改进度
- (void)changeProgress:(float)value {
    Playing.recordLength += value * [PlayerTool share].mutiple;
    if (Playing.recordLength >= Playing.mediaLength) {
        Playing.recordLength = Playing.mediaLength - 2;
    }else if(Playing.recordLength <= 0){
        Playing.recordLength = 0;
    }
    _progressHUDView.valueViewConstraint.constant = (Playing.recordLength / Playing.mediaLength) * _progressHUDView.backProgessView.mj_w;
    _progressHUDView.progressTimeLB.text = [PlayerTool takeTimeStrTimeValue:Playing.recordLength];
    [_controllView refreshTime];
}

// 亮度
- (void)changeBrightness:(float)value{
    if (!_defaultBright) {
        _defaultBright = [UIScreen mainScreen].brightness;
    }
    _brightHUDView.valueViewConstraint.constant += value;
    if (_brightHUDView.valueViewConstraint.constant > _brightHUDView.grayBackView.mj_h) {
        _brightHUDView.valueViewConstraint.constant = _brightHUDView.grayBackView.mj_h;
        _defaultBright = 1;
    }else if (_brightHUDView.valueViewConstraint.constant < 0){
        _brightHUDView.valueViewConstraint.constant = 0;
        _defaultBright = 0;
    }else{
         _defaultBright  += value / _brightHUDView.grayBackView.mj_h;
    }
    [UIScreen mainScreen].brightness = _defaultBright;
}

// 音量
- (void)changeVolume:(float)value{
    if (!_defaultVolume) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        _defaultVolume = audioSession.outputVolume;
    }
    _volumeHUDView.valueViewConstraint.constant += value;
    if (_volumeHUDView.valueViewConstraint.constant > _volumeHUDView.grayBackView.mj_h) {
        _volumeHUDView.valueViewConstraint.constant = _brightHUDView.grayBackView.mj_h;
        _defaultVolume = 1;
    }else if (_volumeHUDView.valueViewConstraint.constant < 0){
        _volumeHUDView.valueViewConstraint.constant = 0;
        _defaultVolume = 0;
    }else {
        _defaultVolume += value / _volumeHUDView.grayBackView.mj_h;
    }

    UISlider *volumeSilder;
    for (UIView *view in [self.volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSilder = (UISlider*)view;
            break;
        }
    }
    [volumeSilder setValue:_defaultVolume animated:NO];
    [_volumeView setShowsVolumeSlider:YES];
}

//点击使控制面板显示
- (void)tapAction:(UITapGestureRecognizer *)sender{
    [self changeAlpha];
    [self p_packUpListTBV];
}

// 双击暂停
- (void)doubleTapAction:(UITapGestureRecognizer *)sender{
    if (PLAYER.playing) {
        [PLAYER pause];
        [_controllView.playOrPauseBtn setImage:[UIImage imageNamed:@"PlayPic_play"] forState:UIControlStateNormal];
    }else{
        PLAYER.position += 0;
        [PLAYER play];
        [_controllView.playOrPauseBtn setImage:[UIImage imageNamed:@"PlayPic_pause"] forState:UIControlStateNormal];
    }
}





#pragma mark - Setter&Getter
- (UIView *)playView{
    if (!_playView) {
        _playView = [[UIView alloc] init];
        _playView.backgroundColor = [UIColor clearColor];
    }
    return _playView;
}

- (MediaPlayListTBV *)playListTBV{
    if (!_playListTBV) {
        _playListTBV = [[MediaPlayListTBV alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _playListTBV.showsVerticalScrollIndicator = NO;
        _playListTBV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_playListTBV setSeparatorColor:[UIColor clearColor]];
        _playListTBV.hidden = true;
    }
    return _playListTBV;
}

- (VolumeAndBrightHUDView *)volumeHUDView{
    if (!_volumeHUDView) {
        _volumeHUDView = (VolumeAndBrightHUDView *)[[NSBundle mainBundle] loadNibNamed:@"VolumeAndBrightHUDView" owner:self options:nil].firstObject;
        [_volumeHUDView.iconImageView setImage:[UIImage imageNamed:@"PlayPic_volume"]];
        _volumeHUDView.alpha = 0;
    }
    return _volumeHUDView;
}

- (VolumeAndBrightHUDView *)brightHUDView{
    if (!_brightHUDView) {
        _brightHUDView = (VolumeAndBrightHUDView *)[[NSBundle mainBundle] loadNibNamed:@"VolumeAndBrightHUDView" owner:self options:nil].firstObject;
        [_brightHUDView.iconImageView setImage:[UIImage imageNamed:@"PlayPic_bright"]];
        _brightHUDView.alpha = 0;
    }
    return _brightHUDView;
}

- (MPVolumeView *)volumeView{
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc]initWithFrame:CGRectMake(2000, 2000, 200,200)];
//        _volumeView.alpha = 0;
    }
    return _volumeView;
}


- (ProgressHUDView *)progressHUDView{
    if (!_progressHUDView) {
        _progressHUDView = (ProgressHUDView *)[[NSBundle mainBundle] loadNibNamed:@"ProgressHUDView" owner:self options:nil].firstObject;
        _progressHUDView.alpha = 0;
    }
    return _progressHUDView;
}

- (ConfigHUDView *)configView{
    if (!_configView) {
        _configView = (ConfigHUDView *)[[NSBundle mainBundle] loadNibNamed:@"ConfigHUDView" owner:self options:nil].firstObject;
        _configView.alpha = 0;
    }
    return _configView;
}

#pragma mark - private
- (void)configGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [pan setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:pan];

    /** 单击显示视图 */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    [self.playView addGestureRecognizer:tap];

    /** 双击暂停手势 */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.playView addGestureRecognizer:doubleTap];

    /** 手势共存 */
    [tap requireGestureRecognizerToFail:doubleTap];
    [_playListTBV reloadData];
}

// 改变信息面板透明度
- (void)changeAlpha{
}

// 收起
- (void)p_packUpListTBV{
    [UIView animateWithDuration:0.75 animations:^{
        [_playListTBV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(ListWidth);
        }];
        [self.superview layoutIfNeeded];
    }completion:^(BOOL finished) {
        _playListTBV.hidden = true;
        _controllView.playListBtn.userInteractionEnabled = true;;
    }];

    _controllView.playListBtn.selected = false;
}

// 显示
- (void)p_unfoldListTBV{
    _playListTBV.hidden = false;
    _controllView.playListBtn.userInteractionEnabled = false;
    [UIView animateWithDuration:0.75 animations:^{
        [_playListTBV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
        }];
          [self.superview layoutIfNeeded];
    }];
    [self changeAlpha];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self removeObserver:self forKeyPath:@"AVSystemController_SystemVolumeDidChangeNotification"];
}
@end
