//
//  FeeHistoryView.m
//  BeautyLife
//
//  Created by mac on 14-8-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "FeeHistoryView.h"
#import "FeeHistoryCell.h"

@interface FeeHistoryView () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *feeHData;
    MBProgressHUD *hud;
}

@end

@implementation FeeHistoryView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
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
    
    //如果是停车缴费清单则显示停车缴费title
    if(self.isShowPark)
    {
        ((UILabel *)self.navigationItem.titleView).text = @"我的停车缴费清单";
    }
    else
    {
        ((UILabel *)self.navigationItem.titleView).text = @"我的物业缴费清单";
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    hud = [[MBProgressHUD alloc] initWithView:self.view];

    //加载缴费历史记录
    [self loadFeeHistory];
}

//弹出框事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取缴费历史记录集合
- (void)loadFeeHistory{
    UserModel *usermodel = [UserModel Instance];
    //如果有网络连接
    if (usermodel.isNetworkRunning) {
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSString *url = nil;
        //如果是停车缴费则获取停车缴费清单
        if(self.isShowPark)
        {
            url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_pay_park_fee_record, appkey,[usermodel getUserValueForKey:@"id"]];
        }
        else
        {
            url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_pay_property_fee_record, appkey,[usermodel getUserValueForKey:@"id"]];
        }
        
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [feeHData removeAllObjects];
                                       @try {
                                           feeHData = [Tool readJsonStrToFeeHistory:operation.responseString];
                                           if(feeHData.count == 0)
                                           {
                                               UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                            message:@"您当前没有缴费信息"                         delegate:self
                                                                                  cancelButtonTitle:@"确定"
                                                                                  otherButtonTitles:nil];
                                               [av show];                                           }
                                           else
                                           {
                                               [self.tableView reloadData];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                             [hud hide:YES];
                                            }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feeHData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeeHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:FeeHistoryIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"FeeHistoryCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[FeeHistoryCell class]]) {
                cell = (FeeHistoryCell *)o;
                break;
            }
        }
    }
    FeeHistory *history = [feeHData objectAtIndex:indexPath.row];
    cell.order_no.text = history.trade_no;
    cell.order_status.text = history.pay_status_text;
    
    cell.order_summary.text = history.remark;
    if([history.pay_status isEqualToString:@"0"])
    {
        cell.order_status.textColor = [UIColor redColor];
        cell.order_tag_img.hidden = YES;
    }
    cell.order_time.text = [Tool TimestampToDateStr:history.addtime andFormatterStr:@"yyyy-MM-dd HH:mm:ss"];
    cell.order_price.text = [NSString stringWithFormat:@"￥%@",history.amount];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
