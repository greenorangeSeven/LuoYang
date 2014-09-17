//
//  CommunityCell.m
//  NanNIng
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "CommunityCell.h"

@implementation CommunityCell

+ (id)initWith
{
    // 初始化时加载collectionCell.xib文件
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CommunityCell" owner:nil options:nil];
    
    // 加载nib
    CommunityCell *cell = [arrayOfViews objectAtIndex:0];
    return cell;
}

+ (NSString *)ID
{
    return @"CommunityCell";
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
