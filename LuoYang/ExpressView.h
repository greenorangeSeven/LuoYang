//
//  ExpressView.h
//  BeautyLife
//
//  Created by Seven on 14-8-6.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySendExpressView.h"
#import "EGOImageView.h"
#import "MyInBoxView.h"

@interface ExpressView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate>
{
    NSArray *typeData;
    NSString *typeStr;
    UIWebView *phoneCallWebView;
}

@property (weak, nonatomic) IBOutlet UILabel *inboxNumLb;
@property (weak, nonatomic) IBOutlet UILabel *inboxBtnLb;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLb;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UITextField *descTv;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

- (IBAction)mySendExpressAction:(id)sender;
- (IBAction)sendAction:(id)sender;
- (IBAction)selectTypeAction:(id)sender;
- (IBAction)telAction:(id)sender;

@end
