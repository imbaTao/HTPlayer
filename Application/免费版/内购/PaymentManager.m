//
//  PaymentManager.m
//  WhatsPlayer
//
//  Created by Mr.h on 12/9/18.
//  Copyright © 2018 Great. All rights reserved.
//

#import "PaymentManager.h"
#import <StoreKit/StoreKit.h>
#import "HTAdTool.h"
//在内购项目中创的商品单号
#define ProductID_AD @"com.removeAd.imbaTao"//20
#define ProductID_Lock @"com.lock.imbaTao" //100
typedef NS_OPTIONS(NSInteger, buyCoinsTag) {
    RemoveAd = 5,
    Lock,
    SubTitle,
    IAP9p1000,
    IAP24p6000,
};
@interface PaymentManager()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@end

@implementation PaymentManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 添加观察者
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}



#pragma mark - 移除广告事件
-(void)removeAdAction{
    HUD_Loading;
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductID:ProductID_AD];
    }else{
        HUD_Hide;
//        NSLog(@"没有可购买产品");
    }
}



#pragma mark 1.请求所有的商品ID
-(void)requestProductID:(NSString *)productID{
    // 1.拿到所有可卖商品的ID数组
    NSArray *productIDArray = [[NSArray alloc]initWithObjects:productID, nil];
    NSSet *sets = [[NSSet alloc]initWithArray:productIDArray];
    
    // 2.向苹果发送请求，请求所有可买的商品
    // 2.1.创建请求对象
    SKProductsRequest *sKProductsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:sets];
    // 2.2.设置代理(在代理方法里面获取所有的可卖的商品)
    sKProductsRequest.delegate = self;
    // 2.3.开始请求
    [sKProductsRequest start];
}

#pragma mark - 内购代理
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
//    NSLog(@"可卖商品的数量=%ld",response.products.count);
    
    NSArray *product = response.products;
    if([product count] == 0){
//        NSLog(@"没有商品");
        return;
    }
    
    for (SKProduct *sKProduct in product) {
        
//        NSLog(@"pro info");
//        NSLog(@"SKProduct 描述信息：%@", sKProduct.description);
//        NSLog(@"localizedTitle 产品标题：%@", sKProduct.localizedTitle);
//        NSLog(@"localizedDescription 产品描述信息：%@",sKProduct.localizedDescription);
//        NSLog(@"price 价格：%@",sKProduct.price);
//        NSLog(@"productIdentifier Product id：%@",sKProduct.productIdentifier);
        
        if([sKProduct.productIdentifier isEqualToString: ProductID_AD]){
            [self buyProduct:sKProduct];
        }else{
            
            //NSLog(@"不不不相同");
        }
    }
}

#pragma mark 内购的代码调用
-(void)buyProduct:(SKProduct *)product{
    
    // 1.创建票据
    SKPayment *skpayment = [SKPayment paymentWithProduct:product];
    
    // 2.将票据加入到交易队列
    [[SKPaymentQueue defaultQueue] addPayment:skpayment];
    
    // 3.添加观察者，监听用户是否付钱成功(不在此处添加观察者)
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}



#pragma mark 4.实现观察者监听付钱的代理方法,只要交易发生变化就会走下面的方法
#pragma mark - 请求失败弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [self alertWithProductId:@"error"];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchased:{
                [self completeTransaction:transaction];
                [queue finishTransaction:transaction];
            } break;
            case SKPaymentTransactionStateFailed:{
                [self failedTransaction:transaction];
                [queue finishTransaction:transaction];
            }break;
            case SKPaymentTransactionStateRestored:{
                [queue finishTransaction:transaction];
            }break;
            case SKPaymentTransactionStatePurchasing:{
//                NSLog(@"需要付款...");
            }break;
            default:break;
        }
    }
}


#pragma mark - 完成购买
- (void)completeTransaction: (SKPaymentTransaction *)transaction{
    HUD_Hide;
    [self buySuccess:RemoveAd];
}

#pragma mark - 购买失败
- (void) failedTransaction: (SKPaymentTransaction *)transaction{
     HUD_Hide;
    [self alertWithProductId:@"error"];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - 恢复购买
- (void)recoverPaymentAction{
    HUD_Loading;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - 完成购买代理回调
-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    HUD_Hide;
    NSString *productId = @"";
    //    NSLog(queue.transactions);
    if (queue.transactions.count) {
//        for (SKPaymentTransaction *transactions in queue.transactions) {
//            productId = transactions.payment.productIdentifier;
//            if ([productId isEqualToString:ProductID_AD]) {
//                [self buySuccess:RemoveAd];
//            }
//        }
        [self buySuccess:RemoveAd];
        [self alertWithProductId:@"恢复购买"];
    }else{
        [self alertWithProductId:LOCALKEY(@"BuyNothing")];
    }
}



#pragma mark - 根据购买类型分类
- (void)buySuccess:(buyCoinsTag)tag{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    switch (tag) {
        case RemoveAd:{
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"NoAD"];
            ADTOOL.NoAD = true;
            [self.delegate paymentCompletWithProductType:Product_AD];
        }break;
        default:break;
    }
}

#pragma mark - 警告窗口
- (void)alertWithProductId:(NSString *)ID{
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle: LOCALKEY(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    NSString *message;
    if ([ID isEqualToString:@"恢复购买"]) {
        message = [NSString stringWithFormat:@"%@!",LOCALKEY(@"ResumeBuySuccess")];
        okAction = [UIAlertAction actionWithTitle: LOCALKEY(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
    }else if ([ID isEqualToString:@"error"]) {
        message = LOCALKEY(@"BuyFailed");
    }else{
        message = ID;
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:LOCALKEY(@"Tips") message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:okAction];
}

@end
