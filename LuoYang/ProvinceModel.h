//
//  ProvinceModel.h
//  BeautyLife
//
//  Created by Seven on 14-8-12.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *pid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSArray *_child;
@property (nonatomic, retain) NSArray *cityArray;

@end
