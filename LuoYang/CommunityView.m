//
//  CommunityView.m
//  NanNIng
//  社区商务(跳蚤市场)
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "CommunityView.h"
#import "CommunityCell.h"
#import "CBusinessPublishView.h"

@interface CommunityView ()<UIActionSheetDelegate>
@end

@implementation CommunityView

@synthesize item1Btn;
@synthesize item2Btn;
@synthesize item3Btn;
@synthesize imageDownloadsInProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"社区商务";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
        UIBarButtonItem *btnMy = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnMy;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 63, 22)];
        [rBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setTitle:@"发布" forState:UIControlStateNormal];
        [rBtn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
        UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnSearch;
    }
    return self;
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publishAction
{
    if ([UserModel Instance].isLogin == NO)
    {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    CBusinessPublishView *publishView = [[CBusinessPublishView alloc] init];
    publishView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishView animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //适配iOS7uinavigationbar遮挡tableView的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    catalog = @"1";
    allCount = 0;
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    commercials = [[NSMutableArray alloc] initWithCapacity:20];
    
    //下拉刷新
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    _iconCache = [[TQImageCache alloc] initWithCachePath:@"loadingpic2" andMaxMemoryCacheNumber:50];
    
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
    [commercials removeAllObjects];
    [imageDownloadsInProgress removeAllObjects];
    commercials = nil;
    _iconCache = nil;
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    //清空
    for (Commercial *p in commercials) {
        p.imgData = nil;
    }
}

- (void)reloadType:(NSString *)ncatalog
{
    catalog = ncatalog;
    [self clear];
    [self.tableView reloadData];
    [self reload:NO];
}
- (void)clear
{
    allCount = 0;
    [commercials removeAllObjects];
    [imageDownloadsInProgress removeAllObjects];
    isLoadOver = NO;
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (self.imageDownloadsInProgress != nil) {
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    }
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
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&catid=%@&p=%d", api_base_url, api_commerciallist, appkey, catalog, pageIndex];
        
        NSString *cid = [[UserModel Instance] getUserValueForKey:@"cid"];
        if (cid != nil && [cid length] > 0) {
            [tempUrl appendString:[NSString stringWithFormat:@"&cid=%@", cid]];
        }
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient] getPath:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            @try {
                isLoading = NO;
                if (!noRefresh) {
                    [self clear];
                }
                NSMutableArray * newComm = [Tool readJsonStrToCommercials:operation.responseString];
                int count = [newComm count];
                allCount += count;
                if (count < 20) {
                    isLoadOver = YES;
                }
                [commercials addObjectsFromArray:newComm];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoadOver) {
            return commercials.count == 0 ? 1 : commercials.count;
        }
        else
            return commercials.count + 1;
    }
    else
        return commercials.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([commercials count] > 0)
    {
        if (indexPath.row < [commercials count])
        {
            CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityCellIdentifier];
            if (!cell) {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CommunityCell" owner:self options:nil];
                for (NSObject *o in objects) {
                    if ([o isKindOfClass:[CommunityCell class]]) {
                        cell = (CommunityCell *)o;
                        break;
                    }
                }
            }
            
            Commercial *commer = [commercials objectAtIndex:[indexPath row]];
            
            cell.commNameLb.text = commer.comm_name;
            cell.contentLb.text = commer.content;
            commer.timeStr = [Tool intervalSinceNow:[Tool TimestampToDateStr:commer.addtime andFormatterStr:@"yyyy-MM-dd HH:mm:ss"]];
            cell.timeLb.text = commer.timeStr;
            
            [cell.telBtn addTarget:self action:@selector(telAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.telBtn.tag = [indexPath row];
            
            if (commer.imgData) {
                cell.picIv.image = commer.imgData;
            }
            else
            {
                if ([commer.thumb isEqualToString:@""]) {
                    commer.imgData = [UIImage imageNamed:@"nopic2"];
                }
                else
                {
                    NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:commer.thumb]];
                    if (imageData) {
                        commer.imgData = [UIImage imageWithData:imageData];
                        cell.picIv.image = commer.imgData;
                    }
                    else
                    {
                        IconDownloader *downloader = [imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                        if (downloader == nil) {
                            ImgRecord *record = [ImgRecord new];
                            record.url = commer.thumb;
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
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"暂无数据" andLoadingString:(isLoading ? loadingTip : loadNext20Tip)  andIsLoading:isLoading];
    }
}

- (IBAction)telAction:(id)sender {
    UIButton *telBtn = (UIButton *)sender;
    int index = telBtn.tag;
    Commercial *commer = [commercials objectAtIndex:index];
    if (commer) {
        NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", commer.tel]];
        if (!phoneCallWebView) {
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    if (row >= [commercials count]) {
        if (!isLoading)
        {
            [self performSelector:@selector(reload:)];
        }
    }
    else
    {
        Commercial *commer = [commercials objectAtIndex:[indexPath row]];
        if (commer) {
            CommunityDetailView *detailView = [[CommunityDetailView alloc] init];
            detailView.commer = commer;
            detailView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailView animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < commercials.count)
    {
        return 124;
    }
    else
    {
        return 62;
    }
}

- (IBAction)item1Action:(id)sender {
    [self reloadType:@"2"];
    [self.item1Btn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)item2Action:(id)sender {
    [self reloadType:@"1"];
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
    [self.item3Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)item3Action:(id)sender {
    [self reloadType:@"3"];
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3Btn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
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

//2013.12.18song. tableView添加上拉更新
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
    return NSDate.date;
}
- (void)refresh
{
    if ([UserModel Instance].isNetworkRunning) {
        isLoadOver = NO;
        [self reload:NO];
    }
}

#pragma 下载图片
- (void)startIconDownload:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%d",[indexPath row]];
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:key];
    if (iconDownloader == nil) {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imgRecord = imgRecord;
        iconDownloader.index = key;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:key];
        [iconDownloader startDownload];
    }
}
- (void)appImageDidLoad:(NSString *)index
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:index];
    if (iconDownloader)
    {
        int _index = [index intValue];
        if (_index >= [commercials count]) {
            return;
        }
        Commercial *c = [commercials objectAtIndex:[index intValue]];
        if (c) {
            c.imgData = iconDownloader.imgRecord.img;
            // cache it
            NSData * imageData = UIImagePNGRepresentation(c.imgData);
            [_iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:c.thumb]];
            [self.tableView reloadData];
        }
    }
}
- (void)dealloc
{
    [self.tableView setDelegate:nil];
}

@end
