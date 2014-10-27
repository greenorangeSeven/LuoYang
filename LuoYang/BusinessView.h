//
//  ConvView.h
//  BeautyLife
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "Shop.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "BusinessCateCell.h"
#import "BusinessCell.h"
#import "BusinessDetailView.h"
#import "BusniessSearchView.h"

@interface BusinessView : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,BMKLocationServiceDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *shopData;
    NSMutableArray *shopCateData;
    BMKMapPoint myPoint;
    BMKLocationService* _locService;
    MBProgressHUD *hud;
    NSString *catid;
    UILabel *noDataLabel;
    
    //下拉刷新
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL isLoading;
    BOOL isLoadOver;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *cateCollection;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
