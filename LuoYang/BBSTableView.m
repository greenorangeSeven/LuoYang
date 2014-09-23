//
//  BBSTableView.m
//  NanNIng
//
//  Created by Seven on 14-9-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "BBSTableView.h"

@interface BBSTableView ()

@end

@implementation BBSTableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
            UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
            [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
            [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
            UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
            self.navigationItem.leftBarButtonItem = btnBack;
            
            UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 63, 22)];
            [rBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
            [rBtn setTitle:@"+发帖" forState:UIControlStateNormal];
            [rBtn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
            UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
            self.navigationItem.rightBarButtonItem = btnSearch;
        }
        return self;
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
    BBSPostedView *publishView = [[BBSPostedView alloc] init];
    publishView.cid = self.cid;
    publishView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = [NSString stringWithFormat:@"%@论坛", _cname];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    samplePopupViewController = [[BBSReplyView alloc] initWithNibName:@"BBSReplyView" bundle:nil];
    samplePopupViewController.parentView = self;
//    [_replyTF becomeFirstResponder];
    
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
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableData) name:Notification_RefreshBBS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableDataAll) name:Notification_ADDBBS object:nil];
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loadingpic4.png"]];
    imageView.imageURL = [NSURL URLWithString:_project.logo];
    imageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 145.0f);
    [_logoIV addSubview:imageView];
    
    userId = [[UserModel Instance] getUserValueForKey:@"id"];
}

- (void)refreshTableData
{
    NSIndexPath *te=[NSIndexPath indexPathForRow:tableIndex inSection:0];//刷新第一个section的第二行
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)refreshTableDataAll
{
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [bbsArray removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
    bbsArray = nil;
    _iconCache = nil;
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    //清空
    for (BBSModel *c in bbsArray) {
        c.imgData = nil;
    }
    
    [super didReceiveMemoryWarning];
}

- (void)clear
{
    allCount = 0;
    [bbsArray removeAllObjects];
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
        int pageIndex = allCount / 20 + 1;
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&cid=%@&p=%i", api_base_url, api_bbslist, appkey, _cid, pageIndex];
        
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient] getPath:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            @try {
                isLoading = NO;
                if (!noRefresh) {
                    [self clear];
                }
                bbsArray = [Tool readJsonStrToBBSArray:operation.responseString];
                int count = [bbsArray count];
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
        if (_index >= [bbsArray count])
        {
            return;
        }
        BBSModel *c = [bbsArray objectAtIndex:[index intValue]];
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
            return bbsArray.count == 0 ? 1 : bbsArray.count;
        }
        else
            return bbsArray.count + 1;
    }
    else
        return bbsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < bbsArray.count)
    {
        BBSModel *bbs = [bbsArray objectAtIndex:[indexPath row]];
        int height = 186 + bbs.contentHeight - 33 + bbs.replyHeight - 42;
        if ([bbs.thumb count] == 0)
        {
            height -= 60;
        }
        if ([bbs.replysStr isEqualToString:@""] == YES)
        {
            height -= 22;
        }
        return height;
    }
    else
    {
        return 62;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([bbsArray count] > 0)
    {
        if (indexPath.row < [bbsArray count])
        {
            BBSTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSTableCell"];
            if (!cell)
            {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BBSTableCell" owner:self options:nil];
                for (NSObject *o in objects)
                {
                    if ([o isKindOfClass:[BBSTableCell class]])
                    {
                        cell = (BBSTableCell *)o;
                        break;
                    }
                }
            }
            BBSModel *bbs = [bbsArray objectAtIndex:[indexPath row]];
            //内容
            cell.contentLb.text = bbs.content;
            CGRect contentLb = cell.contentLb.frame;
            cell.contentLb.frame = CGRectMake(contentLb.origin.x, contentLb.origin.y, contentLb.size.width, bbs.contentHeight -10);
            if ([bbs.thumb count] > 0)
            {
                cell.imageIv.hidden = NO;
                cell.imageIv.frame = CGRectMake(cell.imageIv.frame .origin.x, cell.contentLb.frame.origin.y + cell.contentLb.frame.size.height, cell.imageIv.frame.size.width, cell.imageIv.frame.size.height);
                cell.timeView.frame = CGRectMake(cell.timeView.frame .origin.x, cell.imageIv.frame.origin.y + cell.imageIv.frame.size.height, cell.timeView.frame.size.width, cell.timeView.frame.size.height);
                
                EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"nopic2.png"]];
                imageView.imageURL = [NSURL URLWithString:[bbs.thumb objectAtIndex:0]];
                imageView.frame = CGRectMake(0.0f, 0.0f, cell.imageIv.frame.size.width, cell.imageIv.frame.size.height);
                [cell.imageIv addSubview:imageView];
                //注册Cell按钮点击事件
                UITap *clickPicTap = [[UITap alloc] initWithTarget:self action:@selector(clickPicAction:)];
                [cell.imageIv addGestureRecognizer:clickPicTap];
                clickPicTap.tag = [indexPath row];
            }
            else
            {
                cell.imageIv.hidden = YES;
                cell.timeView.frame = CGRectMake(cell.timeView.frame .origin.x, cell.contentLb.frame.origin.y + cell.contentLb.frame.size.height, cell.timeView.frame.size.width, cell.timeView.frame.size.height);
            }
            cell.replyView.frame = CGRectMake(cell.replyView.frame .origin.x, cell.timeView.frame.origin.y + cell.timeView.frame.size.height, cell.replyView.frame.size.width, cell.replyView.frame.size.height);
            
            //评论
            cell.replyLb.text = bbs.replysStr;
            NSString *replysStr = [NSString stringWithString:bbs.replysStr];
            if ([replysStr isEqualToString:@""] == NO)
            {
                cell.replyLb.frame = CGRectMake(cell.replyLb.frame .origin.x, cell.replyLb.frame.origin.y, cell.replyLb.frame.size.width, bbs.replyHeight -10);
                cell.replyView.frame = CGRectMake(cell.replyView.frame .origin.x, cell.timeView.frame.origin.y + cell.timeView.frame.size.height, cell.replyView.frame.size.width, cell.replyLb.frame.size.height);
                cell.replyView.hidden = NO;
            }
            else
            {
                cell.replyView.hidden = YES;
            }
            //时间
            cell.timeLb.text = bbs.timeStr;
            NSString *nickname = @"匿名用户";
            if ([bbs.nickname isEqualToString:@""] == NO)
            {
                nickname = bbs.nickname;
            }
            else if ([bbs.name isEqualToString:@""] == NO)
            {
                nickname = bbs.name;
            }
            //昵称
            cell.nickNameLb.text = nickname;
            
            //评论按钮
            [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.replyBtn.tag = [indexPath row];
            
            //删除按钮
            if ([userId isEqualToString:bbs.customer_id]) {
                cell.delBtn.hidden = NO;
            }
            else
            {
                cell.delBtn.hidden = YES;
            }
            [cell.delBtn addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.delBtn.tag = [indexPath row];
            
            //头像
            if (bbs.imgData) {
                cell.facePic.image = bbs.imgData;
            }
            else
            {
                if ([bbs.avatar isEqualToString:@""]) {
                    bbs.imgData = [UIImage imageNamed:@"userface"];
                }
                else
                {
                    NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:bbs.avatar]];
                    if (imageData)
                    {
                        bbs.imgData = [UIImage imageWithData:imageData];
                        cell.facePic.image = bbs.imgData;
                    }
                    else
                    {
                        IconDownloader *downloader = [_imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                        if (downloader == nil) {
                            ImgRecord *record = [ImgRecord new];
                            record.url = bbs.avatar;
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

- (void)clickPicAction:(id)sender
{
    UITap *tap = (UITap *)sender;
    if (tap) {
        BBSModel *bbs = [bbsArray objectAtIndex:tap.tag];
        if (bbs.thumb && [bbs.thumb count] > 0) {
            NSMutableArray *photos = [[NSMutableArray alloc] init];
            for (NSString *imageUrl in bbs.thumb) {
                [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]]];
            }
            self.photos = photos;
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = YES;
            self.navigationController.navigationBar.hidden = NO;
            [self.navigationController pushViewController:browser animated:YES];
        }
    }
}

//MWPhotoBrowserDelegate委托事件
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)replyAction:(id)sender
{
    UIButton *tap = (UIButton *)sender;
    if (tap) {
        BBSModel *bbs = [bbsArray objectAtIndex:tap.tag];
        tableIndex = tap.tag;
        
        
        samplePopupViewController.bbs = bbs;
        [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
            NSLog(@"popup view presented");
        }];
    }
}

- (void)delAction:(id)sender
{
    UIButton *tap = (UIButton *)sender;
    if (tap) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"删除提醒"
                                                     message:@"您确定要删除这篇贴子？"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
        av.tag =tap.tag;
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        int tag = alertView.tag;
        BBSModel *bbs = [bbsArray objectAtIndex:tag];
        if (bbs) {
            NSString *delUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@&id=%@", api_base_url, api_delbbs, appkey, userId, bbs.id];
            NSURL *url = [ NSURL URLWithString : delUrl];
            // 构造 ASIHTTPRequest 对象
            ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
            // 开始同步请求
            [request startSynchronous ];
            NSError *error = [request error ];
            assert (!error);
            // 如果请求成功，返回 Response
            NSString *response = [request responseString ];
            NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            int status = 0;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if (json) {
                status = [[json objectForKey:@"status"] intValue];
                if (status == 1) {
                    [Tool showCustomHUD:@"删除成功" andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:1];
                    [bbsArray removeObjectAtIndex:tag];
                    [self.tableView reloadData];
                }
                else
                {
                    [Tool showCustomHUD:@"删除失败" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
