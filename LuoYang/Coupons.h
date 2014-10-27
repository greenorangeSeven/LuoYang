//
//  Coupons.h
//  NewWorld
//
//  Created by Seven on 14-7-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupons : NSObject

@property (nonatomic, retain) NSString* id;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* thumb;

@property (nonatomic, retain) NSString *shop_name;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *business_id;
@property (nonatomic, retain) NSString *published;

//mycoupons
@property (nonatomic, retain) NSString *coupons_id;
@property (nonatomic, retain) NSString *coupons_title;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *remark;
@property (nonatomic, retain) NSString *addtime;
@property (nonatomic, retain) NSString *validity_date;
@property (nonatomic, retain) NSString *validityStr;
@property (nonatomic, retain) NSString *store_name;

@property (retain,nonatomic) UIImage * imgData;

@end
