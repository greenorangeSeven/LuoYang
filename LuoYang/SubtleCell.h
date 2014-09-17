//
//  SubtleCellTableViewCell.h
//  BeautyLife
//
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubtleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImg;

- (void)setImg:(int)ID;

+ (id)initWith;

+ (NSString *)identifyID;
@end
