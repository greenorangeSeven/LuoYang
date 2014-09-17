//
//  MyOrder.h
//  BeautyLife
//
//  Created by mac on 14-8-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrder : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *serial_no;
@property (nonatomic,copy) NSString *order_sn;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *receiver;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *pay_type;
@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *store_id;
@property (nonatomic,copy) NSString *store_name;
@property (nonatomic,copy) NSString *express_company;
@property (nonatomic,copy) NSString *express_number;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,retain) NSMutableArray *goodlist;
@property (nonatomic,retain) NSMutableArray *goodArray;

@end
