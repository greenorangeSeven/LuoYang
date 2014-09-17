//
//  CommunityModel.h
//  BeautyLife
//
//  Created by Seven on 14-8-13.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityModel : NSObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *logo;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *address;

@property (nonatomic, retain) NSArray *build_list;
@property (nonatomic, retain) NSArray *buildArray;
@property (retain,nonatomic) UIImage * imgData;

@end
