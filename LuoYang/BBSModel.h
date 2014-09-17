//
//  BBSModel.h
//  NanNIng
//
//  Created by Seven on 14-9-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSModel : NSObject

@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *cid;
@property (nonatomic,retain) NSString *subject;
@property (nonatomic,retain) NSArray *thumb;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *customer_id;
@property (nonatomic,retain) NSString *addtime;
@property (nonatomic,retain) NSString *replys;
@property (nonatomic,retain) NSString *istop;
@property (nonatomic,retain) NSString *nickname;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *avatar;
@property (nonatomic,retain) NSString *comm_name;

@property (nonatomic, retain) NSArray *reply_list;
@property (nonatomic, retain) NSArray *replyArray;
@property (retain,nonatomic) UIImage * imgData;
@property (nonatomic,retain) NSString *timeStr;
@property int contentHeight;
@property (nonatomic,retain) NSMutableString *replysStr;
@property int replyHeight;

@end
