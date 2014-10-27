//
//  VolnInfoView.h
//  NanNIng
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "TQImageCache.h"

@interface VolnInfoView : UIViewController<UITableViewDataSource,UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
    NSMutableArray *volnArray;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
