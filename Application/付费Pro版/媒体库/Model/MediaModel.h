//
//  MediaModel.h
//  TinyPlayer_V1
//
//  Created by hong on 2017/6/4.
//  Copyright © 2017年 Great. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>

@interface MediaModel : NSObject

/** media */
@property(nonatomic,strong) VLCMedia *media;

/** mediaURL */
@property(nonatomic,strong) NSURL *mediaURL;

/** mediaName */
@property(nonatomic,copy) NSString *mediaName;

/** mediaSize */
@property(nonatomic,copy) NSString *mediaSize;

/** allPlayTime */
@property(nonatomic,copy) NSString *allPlayTime;

/** recordPlayTime */
@property(nonatomic,copy) NSString *recordPlayTime;

/** mediaLength */
@property(nonatomic,assign) CGFloat mediaLength;

/** recordLength */
@property(nonatomic,assign) CGFloat recordLength;

/** thumbnail */
@property(nonatomic,strong) UIImage *thumbnail;

/** rankNumber */
@property(nonatomic,assign)NSInteger rankNumber;

/** 正在获取缩略图 */
@property(nonatomic,assign)BOOL isFetching;

/** 正在播放 */
@property(nonatomic,assign)BOOL isPlaying;

/** 是否被选中 */
@property(nonatomic,assign)BOOL isSeleted;

/** canPlay */
@property(nonatomic,assign) BOOL canPlay;

/** needArrange */
@property(nonatomic,assign) BOOL needArrange;

- (void)loadMedia;

@end
