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
#import "ConvCell.h"
#import "ConvOrderView.h"
#import "BusniessSearchView.h"

@interface ConvView : UIViewController<UITableViewDelegate,UITableViewDataSource, EGORefreshTableHeaderDelegate>
{
    NSMutableArray *shopData;
    MBProgressHUD *hud;
    UILabel *noDataLabel;
    
    //下拉刷新
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL isLoading;
    BOOL isLoadOver;
}

@property (weak, nonatomic) NSString *catid;
@property (weak, nonatomic) NSString *typeTitle;
@property BMKMapPoint myPoint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
