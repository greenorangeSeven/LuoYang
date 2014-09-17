//
//  FeeHistory.h
//  BeautyLife
//
//  Created by mac on 14-8-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeeHistory : NSObject

@property(nonatomic,retain) NSString *trade_no;
@property(nonatomic,retain) NSString *fee_name;
@property(nonatomic,retain) NSString *comm_name;
@property(nonatomic,retain) NSString *house_number;
@property(nonatomic,retain) NSString *amount;
@property(nonatomic,retain) NSString *addtime;
@property(nonatomic,retain) NSString *remark;
@property(nonatomic,retain) NSString *pay_status;
@property(nonatomic,retain) NSString *operatorss;
@property(nonatomic,retain) NSString *pay_status_text;

@end
