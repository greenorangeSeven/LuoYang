//
//  ShuiBill.h
//  LuoYangSQ
//
//  Created by Seven on 15/10/26.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShuiBill : NSObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *riqi;
@property (nonatomic, retain) NSString *pre_chaobiao_num;
@property (nonatomic, retain) NSString *benyue_chaobiao_num;
@property (nonatomic, retain) NSString *erci_dianfei;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *flag;
@property bool isSelect;
@property double total;

@property (nonatomic, retain) NSString *total_shui;
@property (nonatomic, retain) NSString *total_fee;
@property (nonatomic, retain) NSString *fee_enddate;

@property (nonatomic, retain) NSString *fee_name;
@property (nonatomic, retain) NSString *amount;

@end
