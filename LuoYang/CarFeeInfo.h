//
//  CarFeeInfo.h
//  BeautyLife
//
//  Created by Seven on 14-8-19.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarFeeInfo : NSObject

@property (nonatomic, retain) NSString *cid;
@property (nonatomic, retain) NSString *car_number;
@property (nonatomic, retain) NSString *carport_number;
@property (nonatomic, retain) NSString *fee_enddate;
@property (nonatomic, retain) NSString *park_fee;
@property (nonatomic, retain) NSString *discount;

@property (nonatomic, retain) NSString *park_three_month_discount;
@property (nonatomic, retain) NSString *park_six_month_discount;
@property (nonatomic, retain) NSString *park_one_year_discount;

@end
