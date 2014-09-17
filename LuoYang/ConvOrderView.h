//
//  ConvOrder.h
//  BeautyLife
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "StoreMapPointView.h"

@interface ConvOrderView : UIViewController<UIWebViewDelegate>
{
    Shop *shopDetail;
    MBProgressHUD *hud;
    UIWebView *phoneCallWebView;
}

@property (weak, nonatomic) Shop *shop;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *telLb;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)telAction:(id)sender;
- (IBAction)telShopAction:(id)sender;
- (IBAction)mapPointAction:(id)sender;

@end
