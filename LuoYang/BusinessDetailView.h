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
#import "TQImageCache.h"
#import "BMapKit.h"
#import "StoreMapPointView.h"

@interface BusinessDetailView : UIViewController<SGFocusImageFrameDelegate, EGORefreshTableHeaderDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, IconDownloaderDelegate>
{
    UIWebView *phoneCallWebView;
    NSMutableArray *goods;
    NSMutableArray *coupons;
    NSMutableArray *advDatas;
    MBProgressHUD *hud;
    NSString *orderByStr;
    SGFocusImageFrame *bannerView;
    int couponIndex;
    
    TQImageCache * _iconCache;
    
    //下拉刷新
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL isLoading;
    BOOL isLoadOver;
}

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@property (weak, nonatomic) Shop *shop;
@property (weak, nonatomic) NSString *tjTitle;
@property (weak, nonatomic) NSString *tjCatId;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderSegmented;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *couponIv;
- (IBAction)segnebtedChangeAction:(id)sender;

@end
