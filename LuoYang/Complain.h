//
//  Complain.h
//  LuoYang
//
//  Created by Seven on 14-10-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Complain : NSObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *cid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *customer_id;
@property (nonatomic, retain) NSString *addtime;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *reply;
@property (nonatomic, retain) NSString *reply_time;
@property (nonatomic, retain) NSString *aid;

@property (nonatomic, retain) NSString *addtimeStr;
@property (nonatomic, retain) NSString *replytimeStr;

@end
