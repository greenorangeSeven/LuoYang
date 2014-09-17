//
//  CommunityCell.h
//  NanNIng
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityCell : UITableViewCell

+ (id)initWith;
+ (NSString *)ID;
@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UILabel *commNameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@end
