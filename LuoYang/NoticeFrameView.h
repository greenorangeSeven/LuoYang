//
//  NoticeFrameView.h
//  BeautyLife
//
//  Created by Seven on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTableView.h"

@interface NoticeFrameView : UIViewController

@property (strong, nonatomic) NewsTableView *noticeView;
@property (strong, nonatomic) NewsTableView *activityView;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *noticeBtn;
@property (strong, nonatomic) IBOutlet UIButton *activityBtn;

- (IBAction)noticeAction:(id)sender;
- (IBAction)activityAction:(id)sender;

@end
