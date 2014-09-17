//
//  RepairsFrameView.h
//  BeautyLife
//
//  Created by Seven on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepairsFormView.h"
#import "MyRepairsView.h"

@interface RepairsFrameView : UIViewController

@property (strong, nonatomic) RepairsFormView *repairsView;
@property (strong, nonatomic) MyRepairsView *myRepairsView;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *repairsBtn;
@property (strong, nonatomic) IBOutlet UIButton *myRepairsBtn;

- (IBAction)repairsAction:(id)sender;
- (IBAction)myRepairsAction:(id)sender;

@end
