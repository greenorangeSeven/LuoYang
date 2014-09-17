//
//  CouponDetailView.h
//  NewWorld
//
//  Created by Seven on 14-7-14.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface CouponDetailView : UIViewController<UIWebViewDelegate,UIActionSheetDelegate>
{
    UIWebView *phoneCallWebView;
    MBProgressHUD *hud;
    Coupons *couponDetail;
}

@property (strong, nonatomic) NSString *couponsId;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *picIv;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *getBtn;

- (IBAction)getAction:(id)sender;

@end
