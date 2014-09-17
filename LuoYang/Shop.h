//
//  Shop.h
//  BeautyLife
//
//  Created by Seven on 14-8-15.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *catid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *logo;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *content;
@property int distance;

@end
