//
//  StewardPageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StewardFeeFrameView.h"
#import "RepairsFrameView.h"
#import "NoticeFrameView.h"
#import "ExpressView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ArticleView.h"
#import "ADVDetailView.h"

@interface StewardPageView : UIViewController<SGFocusImageFrameDelegate, UIActionSheetDelegate>
{
    UIWebView *phoneCallWebView;
    
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *telBg;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;

- (IBAction)stewardFeeAction:(id)sender;
- (IBAction)repairsAction:(id)sender;
- (IBAction)noticeAction:(id)sender;
- (IBAction)expressAction:(id)sender;
- (IBAction)arttileAction:(id)sender;
- (IBAction)telAction:(id)sender;

@end
