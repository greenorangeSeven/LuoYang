//
//  ConvView.m
//  BeautyLife
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ConvView.h"

@interface ConvView () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ConvView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 63, 22)];
        [rBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"conv_search"] forState:UIControlStateNormal];
        UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnSearch;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAction
{
    if (self.myPoint.x > 0) {
        BusniessSearchView *searchView = [[BusniessSearchView alloc] init];
        searchView.myPoint = self.myPoint;
        searchView.viewType = @"conv";
        [self.navigationController pushViewController:searchView animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = self.typeTitle;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self reload];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
    noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2, 320, 44)];
    noDataLabel.font = [UIFont boldSystemFontOfSize:18];
    noDataLabel.text = @"暂无数据";
    noDataLabel.textColor = [UIColor blackColor];
    noDataLabel.backgroundColor = [UIColor clearColor];
    noDataLabel.textAlignment = UITextAlignmentCenter;
    noDataLabel.hidden = YES;
    [self.view addSubview:noDataLabel];
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)initMainADV
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&spaceid=14", api_base_url, api_getadv, appkey];
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
    bannerView.delegate = self;
}

//数组排序
-(void)startArraySort:(NSString *)keystring isAscending:(BOOL)isAscending
{
    NSSortDescriptor* sortByA = [NSSortDescriptor sortDescriptorWithKey:keystring ascending:isAscending];
    shopData = [[NSMutableArray alloc]initWithArray:[shopData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByA]]];
}

//取数方法
- (void)reload
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableString *urlTemp = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_lifelist, appkey];
        if (self.catid != nil && [self.catid intValue] > 0) {
            [urlTemp appendString:[NSString stringWithFormat:@"&catid=%@", self.catid]];
        }
        //        if (keyword != nil && [keyword length] > 0) {
        //            [urlTemp appendString:[NSString stringWithFormat:@"?name=%@", keyword]];
        //        }
        NSString *url = [[NSString stringWithString:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [shopData removeAllObjects];
                                       @try {
                                           noDataLabel.hidden = YES;
                                           shopData = [Tool readJsonStrToShopArray:operation.responseString];
                                           if (shopData == nil || [shopData count] == 0) {
                                               noDataLabel.hidden = NO;
                                           }
                                           [self.tableView reloadData];
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           [self doneLoadingTableViewData];
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [self doneLoadingTableViewData];
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

- (void)distanceShop
{
    //计算当前位置与商家距离
    for (int i = 0; i < [shopData count]; i++) {
        Shop *temp =[shopData objectAtIndex:(i)];
        CLLocationCoordinate2D coor;
        coor.longitude = [temp.longitude doubleValue];
        coor.latitude = [temp.latitude doubleValue];
        BMKMapPoint shopPoint = BMKMapPointForCoordinate(coor);
        CLLocationDistance distanceTmp = BMKMetersBetweenMapPoints(self.myPoint,shopPoint);
        temp.distance =(int)distanceTmp;
    }
    [self startArraySort:@"distance" isAscending:YES];
    [self.tableView reloadData];
    if (hud != nil) {
        [hud hide:YES];
    }
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
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
        [self reload];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [shopData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConvCell *cell = [tableView dequeueReusableCellWithIdentifier:ConvCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ConvCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[ConvCell class]]) {
                cell = (ConvCell *)o;
                break;
            }
        }
    }
    Shop *shop = [shopData objectAtIndex:[indexPath row]];
    
    cell.titleLb.text = shop.title;
    cell.adressLb.text = [NSString stringWithFormat:@"地址:%@", shop.address];;
    cell.telLb.text = [NSString stringWithFormat:@"电话:%@", shop.tel];
    
    if (shop.distance == 0) {
        cell.distanceLb.hidden = YES;
    }
    else
    {
        if (shop.distance > 1000) {
            float disf = ((float)shop.distance)/1000;
            cell.distanceLb.text = [NSString stringWithFormat:@"距您%.2f千米", disf];
        }
        else
        {
            cell.distanceLb.text = [NSString stringWithFormat:@"距您%d米", shop.distance];
        }
    }
    [Tool roundView:cell.cellbackgroudView andCornerRadius:3.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shop *shop = [shopData objectAtIndex:[indexPath row]];
    if (shop) {
        ConvOrderView *convView = [[ConvOrderView alloc] init];
        convView.shop = shop;
        convView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:convView animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}

@end
