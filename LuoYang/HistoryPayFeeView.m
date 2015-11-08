//
//  HistoryPayFeeView.m
//  LuoYangSQ
//
//  Created by Seven on 15/10/28.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "HistoryPayFeeView.h"
#import "ShuiBill.h"
#import "DianBill.h"
#import "UIViewController+CWPopup.h"
#import "HistoryLifePayCell.h"
#import "FeeDetailView.h"
#import "RanQiBill.h"
#import "RanQiBill.h"

@interface HistoryPayFeeView ()

@end

@implementation HistoryPayFeeView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配iOS7uinavigationbar遮挡问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSString *titleName = @"";
    if ([self.type isEqualToString:@"1"]) {
        titleName = @"水费历史缴费";
    }
    else if([self.type isEqualToString:@"2"])
    {
        titleName = @"电费历史缴费";
    }
    else if([self.type isEqualToString:@"3"])
    {
        titleName = @"燃气费历史充值";
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = titleName;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.type isEqualToString:@"1"]) {
        [self getShuiPayBills];
    }
    else if([self.type isEqualToString:@"2"])
    {
        [self getDianPayBills];
    }
    else if([self.type isEqualToString:@"3"])
    {
        [self getRanQiPayBills];
    }
}

//水费取数方法
- (void)getShuiPayBills
{
    UserModel *user = [UserModel Instance];
    
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&tel=%@", api_base_url, api_getHavePayShui, appkey, [user getUserValueForKey:@"tel"]];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [bills removeAllObjects];
                                       @try {
                                           bills = [Tool readJsonStrToShuiBills:operation.responseString];
                                           
                                           [self.tableView reloadData];
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

//电费取数方法
- (void)getDianPayBills
{
    UserModel *user = [UserModel Instance];
    
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&tel=%@", api_base_url, api_getHavePayDian, appkey, [user getUserValueForKey:@"tel"]];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [bills removeAllObjects];
                                       @try {
                                           bills = [Tool readJsonStrToDianBills:operation.responseString];
                                           
                                           [self.tableView reloadData];
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

//燃气取数方法
- (void)getRanQiPayBills
{
    UserModel *user = [UserModel Instance];
    
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_ranqilist, appkey, [user getUserValueForKey:@"id"]];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [bills removeAllObjects];
                                       @try {
                                           bills = [Tool readJsonStrToRanQiBills:operation.responseString];
                                           
                                           [self.tableView reloadData];
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

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bills.count == 0 ? 1 : bills.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([bills count] > 0) {
        HistoryLifePayCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryLifePayCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"HistoryLifePayCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[HistoryLifePayCell class]]) {
                    cell = (HistoryLifePayCell *)o;
                    break;
                }
            }
        }
        
        NSInteger row = [indexPath row];
        if ([self.type isEqualToString:@"1"]) {
            ShuiBill *s = [bills objectAtIndex:row];
            
            cell.riqiLb.text = s.riqi;
            cell.moneyLb.text = [NSString stringWithFormat:@"%@元", s.total_fee];
            cell.payTimeLb.text = [NSString stringWithFormat:@"缴费时间:%@", s.fee_enddate];
        }
        else if([self.type isEqualToString:@"2"])
        {
            DianBIll *s = [bills objectAtIndex:row];
            
            cell.riqiLb.text = s.riqi;
            cell.moneyLb.text = [NSString stringWithFormat:@"%@元", s.total_dianfei];
            cell.payTimeLb.text = [NSString stringWithFormat:@"缴费时间:%@", s.fee_enddate];
        }
        else if([self.type isEqualToString:@"3"])
        {
            RanQiBill *s = [bills objectAtIndex:row];
            
            cell.riqiLb.text = [NSString stringWithFormat:@"编号:%@", s.ranqi_num];
            cell.moneyLb.text = [NSString stringWithFormat:@"%@元", s.amout];
            cell.payTimeLb.text = [NSString stringWithFormat:@"充值时间:%@", s.endtime];
        }
        return cell;
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:NO andLoadOverString:@"暂无数据" andLoadingString:@"暂无数据" andIsLoading:NO];
    }
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.type isEqualToString:@"1"] || [self.type isEqualToString:@"2"]) {
        FeeDetailView *sampleDetailView = [[FeeDetailView alloc] initWithNibName:@"FeeDetailView" bundle:nil];
        sampleDetailView.parentView = self;
        if ([self.type isEqualToString:@"1"]) {
            ShuiBill *bill = [bills objectAtIndex:indexPath.row];
            sampleDetailView.bill = bill;
        }
        else if([self.type isEqualToString:@"2"])
        {
            DianBIll *bill = [bills objectAtIndex:indexPath.row];
            sampleDetailView.dianBill = bill;
        }
        [self presentPopupViewController:sampleDetailView animated:YES completion:^(void) {
            NSLog(@"popup view presented");
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
