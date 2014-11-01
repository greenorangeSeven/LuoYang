//
//  MyComplainView.m
//  LuoYang
//
//  Created by Seven on 14-10-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "MyComplainView.h"
#import "Complain.h"
#import "MyComplainCell.h"
#import "MyComplainDetailView.h"

@interface MyComplainView ()

@end

@implementation MyComplainView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"我的投诉建议";
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
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadData];
}

- (void)loadData
{
    NSString *url = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_myfeedback, appkey, [[UserModel Instance] getUserValueForKey:@"id"]];
    
    [[AFOSCClient sharedClient] getPath:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try
        {
            [self clear];
            comArray = [Tool readJsonStrToMyComplainArray:operation.responseString];
            [self.tableView reloadData];
            [self doneLoadingTableViewData];
        }
        @catch (NSException *exception)
        {
            [NdUncaughtExceptionHandler TakeException:exception];
        }
        @finally
        {
            [self doneLoadingTableViewData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"获取出错");
         [self doneLoadingTableViewData];
         //刷新错误
         if([UserModel Instance].isNetworkRunning == NO)
         {
             return;
         }
         if([UserModel Instance].isNetworkRunning)
         {
             [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
         }
     }];
}

#pragma 生命周期
- (void)viewDidUnload
{
    [self setTableView:nil];
    _refreshHeaderView = nil;
    [comArray removeAllObjects];
    comArray = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{

}

- (void)clear
{
    [comArray removeAllObjects];
}

- (void)viewDidDisappear:(BOOL)animated
{

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
        [self loadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return comArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([comArray count] > 0)
    {
        if (indexPath.row < [comArray count])
        {
            MyComplainCell *cell = [tableView dequeueReusableCellWithIdentifier:MyComplainCellIdentifier];
            if (!cell)
            {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyComplainCell" owner:self options:nil];
                for (NSObject *o in objects)
                {
                    if ([o isKindOfClass:[MyComplainCell class]])
                    {
                        cell = (MyComplainCell *)o;
                        break;
                    }
                }
            }
            Complain *com = [comArray objectAtIndex:[indexPath row]];
            cell.titleLb.text = com.title;
            cell.addTimeLb.text = com.addtimeStr;
            if ([com.status isEqualToString:@"1"]) {
                cell.statusLb.text = @"已回复";
            }
            else
            {
                cell.statusLb.text = @"未回复";
            }
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Complain *complain = [comArray objectAtIndex:[indexPath row]];
    if (complain) {
        MyComplainDetailView *complainDetail = [[MyComplainDetailView alloc] init];
        complainDetail.complain = complain;
        [self.navigationController pushViewController:complainDetail animated:YES];
    }
    
}

@end
