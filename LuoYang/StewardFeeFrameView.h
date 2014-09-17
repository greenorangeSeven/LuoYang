//
//  StewardFeeFrameView.h
//  BeautyLife
//
//  Created by Seven on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StewardFeeView.h"
#import "ParkFeeView.h"

@interface StewardFeeFrameView : UIViewController

@property (strong, nonatomic) NSString * viewType;

@property (strong, nonatomic) StewardFeeView * stewardView;
@property (strong, nonatomic) ParkFeeView * parkView;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *stewardFeeBtn;
@property (strong, nonatomic) IBOutlet UIButton *parkFeeBtn;

- (IBAction)stewardFeeAction:(id)sender;
- (IBAction)parkFeeAction:(id)sender;

@end
