//
//  MyCouponView.h
//  LuoYang
//
//  Created by Seven on 14-10-15.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "IconDownloader.h"
#import "TQImageCache.h"
#import "CouponDetailView.h"

@interface MyCouponView : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate,IconDownloaderDelegate>
{
    NSMutableArray *couponArray;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    TQImageCache * _iconCache;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
