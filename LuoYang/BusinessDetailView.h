//
//  BusinessDetailViewViewController.h
//  BeautyLife
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessGoods.h"
#import "Coupons.h"
#import "Goods.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "StrikeThroughLabel.h"
#import "BusinessGoodCell.h"
#import "GoodsDetailView.h"
#import "CouponDetailView.h"
#import "BMapKit.h"
#import "StoreMapPointView.h"

@interface BusinessDetailView : UIViewController<SGFocusImageFrameDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIWebView *phoneCallWebView;
    NSMutableArray *goods;
    NSMutableArray *coupons;
    MBProgressHUD *hud;
    NSString *orderByStr;
    SGFocusImageFrame *bannerView;
    int couponIndex;
}

@property (weak, nonatomic) Shop *shop;
@property (weak, nonatomic) NSString *tjTitle;
@property (weak, nonatomic) NSString *tjCatId;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderSegmented;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *couponIv;
- (IBAction)segnebtedChangeAction:(id)sender;

@end
