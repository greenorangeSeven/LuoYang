//
//  NewsTable2View.m
//  LuoYang
//
//  Created by Seven on 14-11-21.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "NewsTable2View.h"

@interface NewsTable2View ()

@end

@implementation NewsTable2View

@synthesize newsTable;
@synthesize catalog;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"物业园地";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.newsTable.frame = CGRectMake(self.newsTable.frame.origin.x, self.newsTable.frame.origin.y, self.newsTable.frame.size.width, self.newsTable.frame.size.height-33);
    
    self.newsTable.dataSource = self;
    self.newsTable.delegate = self;
    //    设置无分割线
    self.newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    catalog = 3;
    
    allCount = 0;
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.newsTable addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    news = [[NSMutableArray alloc] initWithCapacity:20];
    [self reload:YES];
    [self initMainADV];
}

- (void)initMainADV
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&spaceid=20", api_base_url, api_getadv, appkey];
        NSString *cid = [[UserModel Instance] getUserValueForKey:@"cid"];
        if (cid != nil && [cid length] > 0) {
            [tempUrl appendString:[NSString stringWithFormat:@"&cid=%@", cid]];
        }
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           advDatas = [Tool readJsonStrToADV:operation.responseString];
                                           
                                           int length = [advDatas count];
                                           //点赞按钮初始化
                                           Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
                                           
                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                           if (length > 1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:length-1];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           for (int i = 0; i < length; i++)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:i];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                               
                                           }
                                           //添加第一张图 用于循环
                                           if (length >1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:0];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 145) delegate:self imageItems:itemArray isAuto:YES];
                                           [bannerView scrollToIndex:0];
                                           [self.advIv addSubview:bannerView];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           //                                           if (hud != nil) {
                                           //                                               [hud hide:YES];
                                           //                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

//顶部图片滑动点击委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    if (adv)
    {
        if ([adv.redirecturl length] > 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:adv.redirecturl]];
        }
        else
        {
            ADVDetailView *advDetail = [[ADVDetailView alloc] init];
            advDetail.hidesBottomBarWhenPushed = YES;
            advDetail.adv = adv;
            [self.navigationController pushViewController:advDetail animated:YES];
        }
    }
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
    advIndex = index;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bannerView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    bannerView.delegate = self;
}

- (void)refreshed:(NSNotification *)notification
{
    if (notification.object) {
        if ([(NSString *)notification.object isEqualToString:@"0"]) {
            [self.newsTable setContentOffset:CGPointMake(0, -75) animated:YES];
            [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
        }
    }
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.newsTable];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.newsTable];
}

- (void)viewDidUnload
{
    [self setNewsTable:nil];
    _refreshHeaderView = nil;
    [news removeAllObjects];
    news = nil;
    [super viewDidUnload];
}

//重新载入类型
- (void)reloadType:(int)ncatalog
{
    self.catalog = ncatalog;
    [self clear];
    [self.newsTable reloadData];
    [self reload:NO];
}

- (void)clear
{
    allCount = 0;
    [news removeAllObjects];
    isLoadOver = NO;
}

- (void)reload:(BOOL)noRefresh
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount/20 + 1;
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&p=%d&typeid=%d", api_base_url, api_getnoticelist, appkey, pageIndex, self.catalog];
        NSString *cid = [[UserModel Instance] getUserValueForKey:@"cid"];
        if (cid != nil && [cid length] > 0) {
            [tempUrl appendString:[NSString stringWithFormat:@"&cid=%@", cid]];
        }
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
         
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       NSMutableArray *newNews = [Tool readJsonStrToNews:operation.responseString];
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       
                                       @try {
                                           int count = [newNews count];
                                           allCount += count;
                                           if (count < 20)
                                           {
                                               isLoadOver = YES;
                                           }
                                           [news addObjectsFromArray:newNews];
                                           [self.newsTable reloadData];
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           [self doneLoadingTableViewData];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"列表获取出错");
                                       //如果是刷新
                                       [self doneLoadingTableViewData];
                                       
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       isLoading = NO;
                                       if ([UserModel Instance].isNetworkRunning) {
                                           //                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
        isLoading = YES;
        //        [self.newsTable reloadData];
    }
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoadOver) {
            return news.count == 0 ? 1 : news.count;
        }
        else
            return news.count + 1;
    }
    else
        return news.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([news count] > 0) {
        if ([indexPath row] < [news count])
        {
            NoticeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NoticeTableCellIdentifier];
            if (!cell) {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"NoticeTableCell" owner:self options:nil];
                for (NSObject *o in objects) {
                    if ([o isKindOfClass:[NoticeTableCell class]]) {
                        cell = (NoticeTableCell *)o;
                        break;
                    }
                }
            }
            News *n = [news objectAtIndex:[indexPath row]];
            cell.titleLb.text = n.title;
            cell.summaryLb.text = n.summary;
            return cell;
        }
        else
        {
            return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"已经加载全部" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
        }
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"暂无数据" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
    }
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    //点击“下面20条”
    if (row >= [news count]) {
        //启动刷新
        if (!isLoading) {
            [self performSelector:@selector(reload:)];
        }
    }
    else
    {
        News *n = [news objectAtIndex:[indexPath row]];
        if (n) {
            NewsDetailView *newsDetail = [[NewsDetailView alloc] init];
            newsDetail.news = n;
            newsDetail.catalog = catalog;
            [self.navigationController pushViewController:newsDetail animated:YES];
        }
    }
}

#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.newsTable];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
    [self refresh];
}

// tableView添加拉更新
- (void)egoRefreshTableHeaderDidTriggerToBottom
{
    if (!isLoading) {
        [self performSelector:@selector(reload:)];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
- (void)refresh
{
    if ([UserModel Instance].isNetworkRunning) {
        isLoadOver = NO;
        [self reload:NO];
    }
}

- (void)dealloc
{
    [self.newsTable setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)item1Action:(id)sender {
    [self reloadType:3];
    [self.item1Btn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)item2Action:(id)sender {
    [self reloadType:4];
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
    [self.item3Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)item3Action:(id)sender {
    [self reloadType:5];
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3Btn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
}

@end