//
//  Citys.h
//  NanNIng
//
//  Created by mac on 14-9-9.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Citys : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *catid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSString *published;
@property (retain,nonatomic) UIImage * imgData;
@end
