//
//  AlipayUtils.h
//  AlipaySdkDemo
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayOrder.h"

@interface AlipayUtils : NSObject

+ (NSString *)getPayStr:(PayOrder *)payOrder NotifyURL :(NSString *) notifyURL;

@end
