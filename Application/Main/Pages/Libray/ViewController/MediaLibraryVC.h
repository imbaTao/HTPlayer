//
//  MediaLibraryVC.h
//  myProgramming
//
//  Created by hong on 2017/4/27.
//  Copyright © 2017年 hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaLibraryTBV.h"
#import "BaseViewController.h"
#import "LibraryCollectionView.h"
#import "MediaLibraryNavTitleView.h"


@protocol screenRotateDelegate <NSObject>

- (void)allowedRotate:(BOOL)flag;

@end

@interface MediaLibraryVC : BaseViewController

/** pageTableView */
@property(nonatomic,strong)LibraryCollectionView *libraryCollectionView;

/** navHeader */
@property(nonatomic,strong)MediaLibraryNavTitleView *navtitleView;

/** delegate */
@property(nonatomic,weak) id<screenRotateDelegate> delegate;



@end
