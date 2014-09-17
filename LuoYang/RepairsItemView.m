//
//  RepairsItemView.m
//  BeautyLife
//
//  Created by Seven on 14-8-16.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "RepairsItemView.h"

@interface RepairsItemView ()

@end

@implementation RepairsItemView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"报修详情";
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
    self.statusLb.text = [NSString stringWithFormat:@"您的报修%@", self.repair.status];
    [Tool roundView:self.bgView andCornerRadius:3.0];
    self.repairItemTable.dataSource = self;
    self.repairItemTable.delegate = self;
    //    设置无分割线
    self.repairItemTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    repairsItemData = [[NSMutableArray alloc] init];
    [self reload];
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)reload
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@&order_no=%@", api_base_url, api_getbaoxiuinfo, appkey, [[UserModel Instance] getUserValueForKey:@"id"], self.repair.order_no];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           NSArray *tempItems = [Tool readJsonStrToRepairItems:operation.responseString];
                                           for (RepairsItem *item in tempItems) {
                                               if ([item.time intValue] > 0) {
                                                   [repairsItemData insertObject:item atIndex:0];
                                               }
                                           }
                                           if([repairsItemData count] > 0)
                                           {
                                               RepairsItem *item = [repairsItemData objectAtIndex:0];
                                               self.timeLb.text = [Tool TimestampToDateStr:item.time andFormatterStr:@"YYYY年MM月dd日 HH:mm"];
                                           }
                                           [self.repairItemTable reloadData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           
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

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [repairsItemData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:RepairsItemCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RepairsItemCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[RepairsItemCell class]]) {
                cell = (RepairsItemCell *)o;
                break;
            }
        }
    }
    RepairsItem *item = [repairsItemData objectAtIndex:[indexPath row]];
    [Tool roundView:cell.bgView andCornerRadius:3.0];
    cell.statusLb.text = [item.status stringValue];
    cell.textLb.text = item.text;
    cell.timeLb.text = [Tool TimestampToDateStr:item.time andFormatterStr:@"YYYY年MM月dd日 HH:mm"];
    
    if ([repairsItemData count] == 1) {
        cell.statusIv.image = [UIImage imageNamed:@"ritem-2.png"];
    }
    else
    {
        if ([indexPath row] == 0) {
            cell.statusIv.image = [UIImage imageNamed:@"ritem-1.png"];
        }
        else if ([indexPath row] == [repairsItemData count] - 1)
        {
            cell.statusIv.image = [UIImage imageNamed:@"ritem-6.png"];
        }
        else
        {
            cell.statusIv.image = [UIImage imageNamed:@"ritem-4.png"];
        }
    }
    
    return cell;
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
