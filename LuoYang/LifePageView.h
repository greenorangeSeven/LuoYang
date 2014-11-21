//
//  LifePageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-30.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConvView.h"
#import "RechargeView.h"
#import "SubtleView.h"
#import "BusinessView.h"
#import "CommunityView.h"
#import "ProjectCollectionView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ArticleView.h"
#import "ADVDetailView.h"
#import "CouponView.h"
#import "BusinessCateView.h"
#import "ConvCateView.h"

@interface LifePageView : UIViewController<SGFocusImageFrameDelegate, UIActionSheetDelegate>
{
    UIWebView *phoneCallWebView;
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *telBg;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;
@property (weak, nonatomic) IBOutlet UILabel *tellB;

- (IBAction)clickService:(UIButton *)sender;
- (IBAction)clickRecharge:(UIButton *)sender;
- (IBAction)clickSubtle:(UIButton *)sender;
- (IBAction)clickBusiness:(UIButton *)sender;

- (IBAction)clickCommunity:(UIButton *)sender;
- (IBAction)clickBBS:(id)sender;
- (IBAction)telAction:(id)sender;
- (IBAction)znjjAction:(id)sender;
- (IBAction)jjzsAction:(id)sender;
- (IBAction)sqjrAction:(id)sender;
- (IBAction)yhqAction:(id)sender;

@end
