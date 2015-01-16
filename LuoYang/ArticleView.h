//
//  ArticleView.h
//  NanNIng
//
//  Created by Seven on 14-9-3.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "Article.h"
#import "ArticleCell.h"
#import "ArticleDetailView.h"

@interface ArticleView : UIViewController<SGFocusImageFrameDelegate, UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate, UIAlertViewDelegate>
{
    
    NSMutableArray *articles;
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
    
    MBProgressHUD *hud;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (weak, nonatomic) IBOutlet UIImageView *advIv;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
