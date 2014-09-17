//
//  FeeHistoryCell.h
//  BeautyLife
//
//  Created by mac on 14-8-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeeHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *order_time;
@property (weak, nonatomic) IBOutlet UILabel *order_summary;
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UIImageView *order_tag_img;
@property (weak, nonatomic) IBOutlet UILabel *order_price;

@end
