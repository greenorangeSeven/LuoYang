//
//  CommunityView.h
//  NanNIng
//  社区商务(跳蚤市场)
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQImageCache.h"
#import "Commercial.h"
#import "CommunityDetailView.h"

@interface CommunityView : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate,IconDownloaderDelegate>
{
    NSMutableArray *commercials;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSString *catalog;
    BOOL isInitialize;
    TQImageCache * _iconCache;
    
    UIWebView *phoneCallWebView;
}

@property (weak, nonatomic) IBOutlet UIButton *item1Btn;
@property (weak, nonatomic) IBOutlet UIButton *item2Btn;
@property (weak, nonatomic) IBOutlet UIButton *item3Btn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)item1Action:(id)sender;
- (IBAction)item2Action:(id)sender;
- (IBAction)item3Action:(id)sender;

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)startIconDownload:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath;

- (void)reloadType:(NSString *)ncatalog;
- (void)reload:(BOOL)noRefresh;

//清空
- (void)clear;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
