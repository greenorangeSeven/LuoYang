//
//  SubtleCellTableViewCell.m
//  BeautyLife
//
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "SubtleCell.h"

@implementation SubtleCell

+ (id)initWith
{
    UINib *nib = [UINib nibWithNibName:@"SubtleCell" bundle:nil];
    SubtleCell *cell = [nib instantiateWithOwner:nil options:nil][0];
    return cell;
}

+ (NSString *)identifyID
{
    return @"subtle";
}

- (void)awakeFromNib
{
}

- (void)setImg:(int)ID
{
    self.showImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"jingxuan%d",ID]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
