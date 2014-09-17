//
//  AreaListModel.h
//  BeautyLife
//
//  Created by Seven on 14-8-12.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaListModel : NSObject<NSCoding>

@property (nonatomic, copy) NSArray *areaList;

- (id)initWithParameters:(NSArray *)mAreaList;

@end
