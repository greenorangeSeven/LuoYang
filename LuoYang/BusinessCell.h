//
//  BusinessCell.h
//  BeautyLife
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellbackgroudView;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *summaryLb;
@property (weak, nonatomic) IBOutlet UILabel *distanceLb;

@end
