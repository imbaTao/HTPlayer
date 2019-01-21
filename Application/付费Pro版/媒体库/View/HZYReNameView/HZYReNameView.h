//
//  HZYReNameView.h
//  HZYToolBox
//
//  Created by hong  on 2018/9/5.
//  Copyright © 2018年 HZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HZYRenameViewDelegate <NSObject>
- (void)finishChangeFileName:(NSString *)fileName;
@end

@interface HZYReNameView : UIView
@property (weak, nonatomic) IBOutlet UITextField *changeTitleTF;
/** finishBlock */
@property(nonatomic,weak)id<HZYRenameViewDelegate> delegate;
- (void)showWithSourceName:(NSString *)sourceName;
- (void)hid;
@end
