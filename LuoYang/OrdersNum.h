//
//  OrdersNum.h
//  BeautyLife
//
//  Created by mac on 14-8-28.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrdersNum : NSObject


@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, copy) NSString *info;

/**
 * 订单号(物业费,停车费使用这个)
 */
@property (nonatomic, copy) NSString *trade_no;

/**
 * 订单号(商品支付使用这个)
 */
@property (nonatomic, copy) NSString *serial_no;

@end
