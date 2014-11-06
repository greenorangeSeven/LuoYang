//
//  GoodsDetailView.h
//  BeautyLife
//  商品详情
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "GoodsAttrs.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

@interface GoodsDetailView : UIViewController<UIWebViewDelegate>
{
    Goods *goodDetail;
    MBProgressHUD *hud;
    
    NSMutableArray *attrsKeyArray;
    NSMutableArray *attrsValArray;
}

@property (weak, nonatomic) NSString *goodId;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *baseInfoView;
@property (weak, nonatomic) IBOutlet UILabel *stocksLb;
@property (weak, nonatomic) IBOutlet UIView *attrs0View;
@property (weak, nonatomic) IBOutlet UITextField *numberTf;

- (IBAction)toShoppingCartAction:(id)sender;
- (IBAction)buyAction:(id)sender;
- (IBAction)selectTabAction:(id)sender;
- (IBAction)minusAction:(id)sender;
- (IBAction)addAction:(id)sender;

@end
