//
//  MainPageView.h
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
#import "ADVDetailView.h"


@interface MainPageView : UIViewController<SGFocusImageFrameDelegate, UIActionSheetDelegate>
{
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
    
    MBProgressHUD *hud;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *pointsBtn;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;

#pragma mark -按钮点击事件

#pragma mark 便民服务
- (IBAction)clickService:(UIButton *)sender;

#pragma mark 城市文化
- (IBAction)clickCityCulture:(UIButton *)sender;

#pragma mark 精选特价
- (IBAction)clickSubtle:(UIButton *)sender;

#pragma mark 联盟商家
- (IBAction)clickBusiness:(UIButton *)sender;

- (IBAction)stewardFeeAction:(id)sender;
- (IBAction)repairsAction:(id)sender;
- (IBAction)noticeAction:(id)sender;
- (IBAction)expressAction:(id)sender;

- (IBAction)shareAction:(id)sender;
- (IBAction)advDetailAction:(id)sender;
- (IBAction)pointsAction:(id)sender;

@end
