//
//  CityPageView.h
//  NanNIng
//
//  Created by Seven on 14-8-9.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ArticleView.h"
#import "ADVDetailView.h"

@interface CityPageView : UIViewController<SGFocusImageFrameDelegate, UIActionSheetDelegate>
{
    UIWebView *phoneCallWebView;
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *telBg;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;

- (IBAction)clickCity:(UIButton *)sender;

- (IBAction)clickDongmeng:(UIButton *)sender;

- (IBAction)clickZhiyuan:(UIButton *)sender;

- (IBAction)clickHelp:(UIButton *)sender;

- (IBAction)telAction:(id)sender;
- (IBAction)sqzsAction:(id)sender;
- (IBAction)ptzsAction:(id)sender;
- (IBAction)zxlsAction:(id)sender;
- (IBAction)fwdjAction:(id)sender;

@end
