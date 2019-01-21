//
//  PlayerVC.h
//  TinyPlayer_V1
//
//  Created by hong on 2017/6/4.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "BaseViewController.h"
#import "MediaModel.h"
#import "MediaTopInfoView.h"
#import "MediaControllView.h"
#import "MediaView.h"


@protocol PlayerVCDelgate <NSObject>

- (void)backActionRefreshThumbnail;

@end

typedef NS_OPTIONS(NSInteger, PlayStatus){
    PAUSE = 0,
    PLAYING
};
@interface PlayerVC : BaseViewController


/** delgate */
@property(nonatomic,weak)id <PlayerVCDelgate> delegate;

/** mediaView */
@property(nonatomic,strong) MediaView *mediaView;

/** topInfo */
@property(nonatomic,strong) MediaTopInfoView *topInfoView;

/** bottomControl */
@property(nonatomic,strong) MediaControllView *controllView;

/** currentUrlIndex */
@property(nonatomic,assign) NSInteger currentUrlIndex;



- (instancetype)initWithMediaDataArray:(NSMutableArray *)mediaDataArray;
    
/** startPlay */
- (void)startPlayWithIndex:(NSInteger)index;

/** checkOrientation */
- (void)orientationChanged;

/** nextMediaMethod */
- (void)nextMediaMethod;



@end
