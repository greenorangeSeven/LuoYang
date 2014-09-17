//
//  ArticleView.m
//  NanNIng
//
//  Created by Seven on 14-9-3.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "VolnView.h"
#import "VolnJoinView.h"

@interface VolnView ()

@end

@implementation VolnView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"志愿者";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
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
    //适配iOS7uinavigationbar遮挡问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    //下拉刷新
    if (_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    allCount = 0;
    [_refreshHeaderView refreshLastUpdatedDate];
    self.view.backgroundColor = [Tool getBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [Tool getBackgroundColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (isInitialize == NO)
    {
        isInitialize = YES;
        [self reload:YES];
    }
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

#pragma 生命周期
- (void)viewDidUnload
{
    [self setTableView:nil];
    _refreshHeaderView = nil;
    [cityArray removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
    cityArray = nil;
    _iconCache = nil;
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    //清空
    for (Citys *c in cityArray) {
        c.imgData = nil;
    }

    [super didReceiveMemoryWarning];
}

- (void)clear
{
    allCount = 0;
    [cityArray removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
    isLoadOver = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.imageDownloadsInProgress != nil) {
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)reload:(BOOL)noRefresh
{
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount / 20;
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&p=%i", api_base_url, api_get_volnews_list, appkey,pageIndex];
        
         NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient] getPath:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            @try {
                isLoading = NO;
                if (!noRefresh) {
                    [self clear];
                }
                cityArray = [Tool readJsonStrToCitys:operation.responseString];
                int count = [cityArray count];
                allCount += count;
                if (count < 20) {
                    isLoadOver = YES;
                }
                [self.tableView reloadData];
                [self doneLoadingTableViewData];
            }
            @catch (NSException *exception) {
                [NdUncaughtExceptionHandler TakeException:exception];
            }
            @finally {
                [self doneLoadingTableViewData];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"获取出错");
            //刷新错误
            [self doneLoadingTableViewData];
            isLoading = NO;
            if ([UserModel Instance].isNetworkRunning == NO) {
                return;
            }
            if ([UserModel Instance].isNetworkRunning) {
                [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
            }
        }];
        
        isLoading = YES;
        //        [self.tableView reloadData];
    }
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

- (void)refresh
{
    if ([UserModel Instance].isNetworkRunning) {
        isLoadOver = NO;
        [self reload:NO];
    }
}

//2013.12.18song. tableView添加上拉更新
- (void)egoRefreshTableHeaderDidTriggerToBottom
{
    if (!isLoading)
    {
        NSLog(@"lp;");
        [self performSelector:@selector(reload:)];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return NSDate.date;
}

#pragma 下载图片
- (void)startIconDownload:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%d",[indexPath row]];
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:key];
    if (iconDownloader == nil) {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imgRecord = imgRecord;
        iconDownloader.index = key;
        iconDownloader.delegate = self;
        [_imageDownloadsInProgress setObject:iconDownloader forKey:key];
        [iconDownloader startDownload];
    }
}

- (void)appImageDidLoad:(NSString *)index
{
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:index];
    if (iconDownloader)
    {
        int _index = [index intValue];
        if (_index >= [cityArray count])
        {
            return;
        }
        Citys *c = [cityArray objectAtIndex:[index intValue]];
        if (c) {
            c.imgData = iconDownloader.imgRecord.img;
            // cache it
            NSData * imageData = UIImagePNGRepresentation(c.imgData);
            [_iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:c.thumb]];
            [self.tableView reloadData];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoadOver) {
            return cityArray.count == 0 ? 1 : cityArray.count;
        }
        else
            return cityArray.count + 1;
    }
    else
        return cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cityArray count] > 0)
    {
        if (indexPath.row < [cityArray count])
        {
            VolnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VolnCell"];
            if (!cell)
            {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"VolnCell" owner:self options:nil];
                for (NSObject *o in objects)
                {
                    if ([o isKindOfClass:[VolnCell class]])
                    {
                        cell = (VolnCell *)o;
                        break;
                    }
                }
            }
            Citys *city = [cityArray objectAtIndex:[indexPath row]];
            cell.titleLb.text = city.title;
            cell.summaryLb.text = city.summary;
            if (city.imgData)
            {
                cell.thumImg.image = city.imgData;
            }
            else
            {
                if ([city.thumb isEqualToString:@""]) {
                    city.imgData = [UIImage imageNamed:@"loadingpic2"];
                }
                else
                {
                    NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:city.thumb]];
                    if (imageData)
                    {
                        city.imgData = [UIImage imageWithData:imageData];
                        cell.thumImg.image = city.imgData;
                    }
                    else
                    {
                        IconDownloader *downloader = [_imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                        if (downloader == nil) {
                            ImgRecord *record = [ImgRecord new];
                            record.url = city.thumb;
                            [self startIconDownload:record forIndexPath:indexPath];
                        }
                    }
                }
            }
            return cell;
        }
        else
        {
            return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"已经加载全部内容" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
        }
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"已经加载全部内容" andLoadingString:(isLoading ? loadingTip : loadNext20Tip)  andIsLoading:isLoading];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < cityArray.count)
    {
        return 92;
    }
    else
    {
        return 62;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Citys *art = [cityArray objectAtIndex:[indexPath row]];
    if (art) {
        VolnDetailView *volnDetailView = [[VolnDetailView alloc] init];
        volnDetailView.art = art;
        [self.navigationController pushViewController:volnDetailView animated:YES];
    }
}

- (IBAction)joinAction:(UIButton *)sender
{
    VolnJoinView *volnJoinView = [[VolnJoinView alloc] init];
    volnJoinView.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:volnJoinView animated:YES];

}
@end
