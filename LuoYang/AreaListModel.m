//
//  AreaListModel.m
//  BeautyLife
//
//  Created by Seven on 14-8-12.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "AreaListModel.h"

@implementation AreaListModel
@synthesize areaList;

- (id)initWithParameters:(NSArray *)mAreaList
{
    AreaListModel *mlist = [[AreaListModel alloc] init];
    mlist.areaList = mAreaList;
    return mlist;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:areaList forKey:@"areaList"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSMutableArray *mAreaList = [decoder decodeObjectForKey:@"areaList"];
    return [self initWithParameters:mAreaList];
}
@end
