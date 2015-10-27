//
//  DuiHuanShop.h
//  LuoYangSQ
//
//  Created by Seven on 15/9/2.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DuiHuanShop : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *catid;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSString *market_price;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *stocks;
@property (nonatomic,copy) NSString *buys;
@property (nonatomic,copy) NSString *isrecommend;
@property (nonatomic,copy) NSString *target;
@property (nonatomic,copy) NSString *aid;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *duihuan_quan;
@property (nonatomic,copy) NSString *duihuan_quan02;
@property (nonatomic,copy) NSString *duihuan_xianjin;
@property (nonatomic,copy) NSString *totime;
@property (nonatomic,copy) NSString *keys;

@property (nonatomic, retain) NSArray *attrs;
@property (nonatomic, retain) NSArray *attrsArray;

@property (nonatomic, retain) NSString *attrsStr;

@property (nonatomic, retain) NSNumber *number;

@end
