//
//  BBSReplyModel.h
//  NanNIng
//
//  Created by Seven on 14-9-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSReplyModel : NSObject

@property (nonatomic,retain) NSString *reply_id;
@property (nonatomic,retain) NSString *subject_id;
@property (nonatomic,retain) NSString *reply_content;
@property (nonatomic,retain) NSString *reply_time;
@property (nonatomic,retain) NSString *nickname;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *house_number;
@property (nonatomic,retain) NSString *avatar;

@end
