//
//  RepairsItemCell.h
//  BeautyLife
//
//  Created by Seven on 14-8-17.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairsItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *statusIv;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *textLb;

@end
