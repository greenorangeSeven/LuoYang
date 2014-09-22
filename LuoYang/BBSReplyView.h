//
//  BBSReplyView.h
//  NanNIng
//
//  Created by Seven on 14-9-12.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CWPopup.h"
#import "BBSModel.h"

@interface BBSReplyView : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) BBSModel *bbs;
@property (weak, nonatomic) UIViewController *parentView;
- (IBAction)closeAction:(id)sender;
- (IBAction)publishAction:(id)sender;

@end
