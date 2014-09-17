//
//  RepairsRateView.h
//  BeautyLife
//
//  Created by Seven on 14-8-17.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMRatingControl.h"
#import "EGOImageView.h"

@interface RepairsRateView : UIViewController
{
    NSString *rateValue;
}

@property (weak, nonatomic) RepairsList *repair;

@property (weak, nonatomic) IBOutlet UIScrollView *scollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *commentTv;
@property (weak, nonatomic) IBOutlet UILabel *rateLb;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UITextView *summaryTv;
@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UILabel *startLb;
@property (weak, nonatomic) IBOutlet UILabel *weixiuNameLb;
@property (weak, nonatomic) IBOutlet UILabel *endLb;

@end
