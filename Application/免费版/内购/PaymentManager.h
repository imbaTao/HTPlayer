//
//  PaymentManager.h
//  WhatsPlayer
//
//  Created by Mr.h on 12/9/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
NS_ASSUME_NONNULL_BEGIN


typedef NS_OPTIONS(NSInteger, ProductType) {
    Product_AD = 1
};

@protocol PaymentManagerDelegate <NSObject>

// 购买完成根据类型来处理
- (void)paymentCompletWithProductType:(ProductType)type;

@end

@interface PaymentManager : NSObject
/** delegate */
@property(nonatomic,weak)id<PaymentManagerDelegate> delegate;
/**
 1.购买单利类
 2.给自己签代理
 3.代理完成事件改变设置值，用通知刷新界面
 */


/** 恢复购买操作 */
- (void)recoverPaymentAction;

/** 移除广告事件 */
- (void)removeAdAction;
@end

NS_ASSUME_NONNULL_END
