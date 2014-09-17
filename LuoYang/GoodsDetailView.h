//
//  GoodsDetailView.h
//  BeautyLife
//  商品详情
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

@interface GoodsDetailView : UIViewController<UIWebViewDelegate>
{
    Goods *goodDetail;
    MBProgressHUD *hud;
}

@property (weak, nonatomic) Goods *good;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)toShoppingCartAction:(id)sender;
- (IBAction)buyAction:(id)sender;

@end
