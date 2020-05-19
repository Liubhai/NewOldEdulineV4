//
//  STRIAPManager.m
//  YunKeTang
//
//  Created by IOS on 2018/12/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "STRIAPManager.h"
#import <StoreKit/StoreKit.h>
#import "NSData+Base64.h"
#import "BigWindCar.h"
#import "SYG.h"


static bool hasAddObersver = NO;

@interface STRIAPManager()<SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    NSString           *_purchID;
    IAPCompletionHandle _handle;
    
    NSString           *priceStr;
    NSString           *receipt_data_str;
}
@end

@implementation STRIAPManager

#pragma mark - ♻️life cycle
+ (instancetype)shareSIAPManager{
    
    static STRIAPManager *IAPManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        IAPManager = [[STRIAPManager alloc] init];
    });
    return IAPManager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
        
        if (!hasAddObersver) {
            hasAddObersver = YES;
            // 监听购买结果
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        }
    }
    return self;
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


#pragma mark - 🚪public
- (void)startPurchWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle{
    if (purchID) {
        if ([SKPaymentQueue canMakePayments]) {
            // 开始购买服务
            _purchID = purchID;
            _handle = handle;
            NSSet *nsset = [NSSet setWithArray:@[purchID]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }else{
            [self handleActionWithType:SIAPPurchNotArrow data:nil];
        }
    }
}
#pragma mark - 🔒private
- (void)handleActionWithType:(SIAPPurchType)type data:(NSData *)data{
#if DEBUG
    switch (type) {
        case SIAPPurchSuccess:
            NSLog(@"购买成功");
            if (receipt_data_str == nil) {
                if (self.controlLoadingBlock) {
                    self.controlLoadingBlock(NO, @"未能获取到支付凭据");
                }
            } else {
                [self netWorkApplePayResults:receipt_data_str];
            }
            break;
        case SIAPPurchFailed:
            NSLog(@"购买失败");
            if (self.controlLoadingBlock) {
                self.controlLoadingBlock(NO, @"购买失败");
            }
            break;
        case SIAPPurchCancle:
            NSLog(@"用户取消购买");
            if (self.controlLoadingBlock) {
                self.controlLoadingBlock(NO, @"用户取消购买");
            }
            break;
        case SIAPPurchVerFailed:
            NSLog(@"订单校验失败");
            if (self.controlLoadingBlock) {
                self.controlLoadingBlock(NO, @"订单校验失败");
            }
            break;
        case SIAPPurchVerSuccess:
            NSLog(@"订单校验成功");
            if (self.controlLoadingBlock) {
                self.controlLoadingBlock(YES, @"订单校验成功");
            }
            break;
        case SIAPPurchNotArrow:
            NSLog(@"不允许程序内付费");
            if (self.controlLoadingBlock) {
                self.controlLoadingBlock(NO, @"不允许程序内付费");
            }
            break;
        default:
            break;
    }
#endif
    if(_handle){
        _handle(type,data);
    }
}


#pragma mark - 🍐delegate
// 交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    [self verifyPurchaseWithPaymentTransaction:transaction];
}

// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:SIAPPurchFailed data:nil];
    }else{
        [self handleActionWithType:SIAPPurchCancle data:nil];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction {
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if(!receipt){
        // 交易凭证为空验证失败
        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }
   
    
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    receipt_data_str = [requestContents stringValueForKey:@"receipt-data"];
    
    if (!requestData) { // 交易凭证为空验证失败
        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }
    // 购买成功将交易凭证发送给服务端进行再次校验
    [self handleActionWithType:SIAPPurchSuccess data:receipt];
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] <= 0){
#if DEBUG
        NSLog(@"--------------没有商品------------------");
#endif
        return;
    }
    
    SKProduct *selectedProduct = nil;
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:_purchID]){
            selectedProduct = pro;
            break;
        }
    }
    
#if DEBUG
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    NSLog(@"%@",[selectedProduct description]);
    NSLog(@"%@",[selectedProduct localizedTitle]);
    NSLog(@"%@",[selectedProduct localizedDescription]);
    NSLog(@"%@",[selectedProduct price]);
    NSLog(@"%@",[selectedProduct productIdentifier]);
    NSLog(@"发送购买请求");
    priceStr = [NSString stringWithFormat:@"%@",[selectedProduct price]];
#endif
    
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:selectedProduct];
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
#if DEBUG
    NSLog(@"------------------错误-----------------:%@", error);
#endif
    if (self.controlLoadingBlock) {
        self.controlLoadingBlock(NO, error.description);
    }
}

- (void)requestDidFinish:(SKRequest *)request{
#if DEBUG
    NSLog(@"------------反馈信息结束-----------------");
    
#endif
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    
    if (![SKPaymentQueue canMakePayments]) {
        if (self.controlLoadingBlock) {
            self.controlLoadingBlock(NO, @"不可进行苹果内购");
        }
        return;
    }

    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
#if DEBUG
                NSLog(@"商品添加进列表11");
#endif
                break;
            case SKPaymentTransactionStateRestored:
#if DEBUG
                NSLog(@"已经购买过商品");
#endif
                // 消耗型不支持恢复购买
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                if (self.controlLoadingBlock) {
                   self.controlLoadingBlock(NO, @"已经购买过商品");
                }
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];

                if (tran.error.code == 0) {
                    if (self.controlLoadingBlock) {
                        self.controlLoadingBlock(NO, tran.error.userInfo[@"NSLocalizedDescription"]);
                    }
                } else {
                    if (self.controlLoadingBlock) {
                       self.controlLoadingBlock(NO, @"支付已取消");
                    }
                }
                break;
            default:
                break;
        }
    }
}



#pragma mark  ----

- (void)netWorkApplePayResults:(NSString *)str {
    if (str == nil || str.length == 0) {
        if (self.controlLoadingBlock) {
            self.controlLoadingBlock(NO, @"支付凭证为空");
        }
        return;
    }
    NSString *endUrlStr = YunKeTang_User_user_verifyIPhoneScore;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:str forKey:@"receipt_data"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBalanceData" object:nil];
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        NSInteger errorCode = [dict[@"error_code"] integerValue];
        if (!errorCode) {
            if (self.controlLoadingBlock) {
                self.controlLoadingBlock(YES, @"支付成功");
            }
        } else {
            if (self.controlLoadingBlock) {
                self.controlLoadingBlock(NO, @"支付失败");
            }
        }
        NSLog(@"%@",dict);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (self.controlLoadingBlock) {
            self.controlLoadingBlock(NO, @"支付凭证验证失败");
        }
    }];
    [op start];
}


@end
