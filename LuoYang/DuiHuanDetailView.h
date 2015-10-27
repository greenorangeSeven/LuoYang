//
//  DuiHuanDetailView.h
//  LuoYangSQ
//
//  Created by Seven on 15/9/2.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuiHuanShop.h"
#import "GoodsAttrs.h"
#import "UIImageView+WebCache.h"

@interface DuiHuanDetailView : UIViewController<UIWebViewDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *hud;
    
    NSMutableArray *attrsKeyArray;
    NSMutableArray *attrsValArray;
}

@property (weak, nonatomic) DuiHuanShop *goodDetail;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *baseInfoView;
@property (weak, nonatomic) IBOutlet UILabel *stocksLb;
@property (weak, nonatomic) IBOutlet UIView *attrs0View;
@property (weak, nonatomic) IBOutlet UITextField *numberTf;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

- (IBAction)buyAction:(id)sender;
- (IBAction)selectTabAction:(id)sender;
- (IBAction)scheme1Action:(id)sender;
- (IBAction)scheme2Action:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *scheme1Btn;
@property (weak, nonatomic) IBOutlet UIButton *scheme2Btn;

@end
