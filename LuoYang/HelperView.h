//
//  CityPageView.h
//  NanNIng
//
//  Created by Seven on 14-8-9.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "TQImageCache.h"

@interface HelperView : UIViewController
{
    NSMutableArray *cityArray;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    BOOL isInitialize;
    TQImageCache * _iconCache;
    
    UIWebView *phoneCallWebView;
    
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
    
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIImageView *advIv;
//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
