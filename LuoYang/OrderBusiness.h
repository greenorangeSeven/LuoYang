//
//  OrderBusiness.h
//  BeautyLife
//
//  Created by Seven on 14-8-28.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderBusiness : NSObject

@property (nonatomic, retain) NSNumber *store_id;
@property (nonatomic, retain) NSNumber *amount;
@property (nonatomic, retain) NSMutableArray *goodlist;

@end
