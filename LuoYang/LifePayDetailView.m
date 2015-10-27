//
//  LifePayDetailView.m
//  LuoYangSQ
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "LifePayDetailView.h"
#import "SSCheckBoxView.h"
#import "FeeDetailView.h"
#import "UIViewController+CWPopup.h"
#import "ShuiBill.h"
#import "DianBill.h"
#import "ShuiDianOrder.h"
#import "ShuiDianOrderArray.h"
#import "PayOrder.h"
#import "AlipayUtils.h"
#import <AlipaySDK/AlipaySDK.h>


@interface LifePayDetailView ()
{
    double totalMoney;
}

@end

@implementation LifePayDetailView

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
        titleName = @"缴纳水费";
    }
    else if([self.type isEqualToString:@"2"])
    {
        titleName = @"缴纳电费";
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
        [self getShuiNoPayBills];
    }
    else if([self.type isEqualToString:@"2"])
    {
        [self getDianNoPayBills];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//水费取数方法
- (void)getShuiNoPayBills
{
    UserModel *user = [UserModel Instance];

    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&tel=%@", api_base_url, api_getNoPayShui, appkey, [user getUserValueForKey:@"tel"]];
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

//水费取数方法
- (void)getDianNoPayBills
{
    UserModel *user = [UserModel Instance];
    
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&tel=%@", api_base_url, api_getNoPayDian, appkey, [user getUserValueForKey:@"tel"]];
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

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bills.count == 0 ? 1 : bills.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([bills count] > 0) {
        LifePayCell *cell = [tableView dequeueReusableCellWithIdentifier:LifePayCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"LifePayCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[LifePayCell class]]) {
                    cell = (LifePayCell *)o;
                    break;
                }
            }
        }
        
        NSInteger row = [indexPath row];
        if ([self.type isEqualToString:@"1"]) {
            ShuiBill *s = [bills objectAtIndex:row];
            
            SSCheckBoxView *cb = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(12, 2, 30, 30) style:kSSCheckBoxViewStyleGreen checked:s.isSelect];
            cb.tag = row;
            [cb setStateChangedBlock:^(SSCheckBoxView *cbv) {
                ShuiBill *bill = [bills objectAtIndex:cbv.tag];
                if (cbv.checked) {
                    bill.isSelect = YES;
                }
                else
                {
                    bill.isSelect = NO;
                }
                [self totalSelectMoney];
            }];
            [cell addSubview:cb];
            
            if(s.total == 0)
            {
                s.total = [s.total_fee doubleValue];
            }
            
            [cell.cellBtn addTarget:self action:@selector(popDetailAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.cellBtn.tag = row;
            
            cell.monthStrLb.text = s.riqi;
            cell.totalLb.text = [NSString stringWithFormat:@"%@元", s.total_fee];
            
        }
        else if([self.type isEqualToString:@"2"])
        {
            DianBIll *s = [bills objectAtIndex:row];
            
            SSCheckBoxView *cb = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(12, 2, 30, 30) style:kSSCheckBoxViewStyleGreen checked:s.isSelect];
            cb.tag = row;
            [cb setStateChangedBlock:^(SSCheckBoxView *cbv) {
                ShuiBill *bill = [bills objectAtIndex:cbv.tag];
                if (cbv.checked) {
                    bill.isSelect = YES;
                }
                else
                {
                    bill.isSelect = NO;
                }
                [self totalSelectMoney];
            }];
            [cell addSubview:cb];
            
            if(s.total == 0)
            {
                s.total = [s.total_dianfei doubleValue];
            }
            
            [cell.cellBtn addTarget:self action:@selector(popDetailAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.cellBtn.tag = row;
            
            cell.monthStrLb.text = s.riqi;
            cell.totalLb.text = [NSString stringWithFormat:@"%@元", s.total_dianfei];
        }
        return cell;
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:NO andLoadOverString:@"暂无数据" andLoadingString:@"暂无数据" andIsLoading:NO];
    }
}

- (void)popDetailAction:(id)sender
{
    UIButton *tap = (UIButton *)sender;
    
    FeeDetailView *sampleDetailView = [[FeeDetailView alloc] initWithNibName:@"FeeDetailView" bundle:nil];
    sampleDetailView.parentView = self;
    if ([self.type isEqualToString:@"1"]) {
        ShuiBill *bill = [bills objectAtIndex:tap.tag];
        sampleDetailView.bill = bill;
    }
    else if([self.type isEqualToString:@"2"])
    {
        DianBIll *bill = [bills objectAtIndex:tap.tag];
        sampleDetailView.dianBill = bill;
    }
    [self presentPopupViewController:sampleDetailView animated:YES completion:^(void) {
        NSLog(@"popup view presented");
    }];
}

- (void)totalSelectMoney
{
    totalMoney = 0.00;
    for (ShuiBill *bill in bills) {
        if (bill.isSelect) {
            totalMoney += bill.total;
        }
    }
    self.totalMoneyLb.text = [NSString stringWithFormat:@"合计：%0.2f元", totalMoney];
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    FeeDetailView *sampleDetailView = [[FeeDetailView alloc] initWithNibName:@"FeeDetailView" bundle:nil];
//    sampleDetailView.parentView = self;
//    [self presentPopupViewController:sampleDetailView animated:YES completion:^(void) {
//        NSLog(@"popup view presented");
//    }];
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

- (IBAction)payAction:(id)sender {
    NSMutableArray *billOrders = [[NSMutableArray alloc] init];
    
    if ([self.type isEqualToString:@"1"]) {
        for (ShuiBill *bill in bills) {
            if (bill.isSelect) {
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                [dictionary setValue:bill.id forKey:@"id"];
                [dictionary setValue:bill.tel forKey:@"tel"];
                [billOrders addObject:dictionary];
            }
        }
    }
    else if([self.type isEqualToString:@"2"])
    {
        for (DianBIll *bill in bills) {
            if (bill.isSelect) {
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                [dictionary setValue:bill.id forKey:@"id"];
                [dictionary setValue:bill.tel forKey:@"tel"];
                [billOrders addObject:dictionary];
            }
        }
    }
    
    if ([billOrders count] == 0) {
        [Tool showCustomHUD:@"请选择支付的费用" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    self.payBtn.enabled = NO;
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:billOrders options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self payFeeMethod:jsonStr];
}

#pragma mark 付费事件处理
- (void)payFeeMethod:(NSString *)content
{
    NSString *regUrl = @"";
    if ([self.type isEqualToString:@"1"]) {
        regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_shuifeipay];
    }
    else if([self.type isEqualToString:@"2"])
    {
        regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_dianfeipay];
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    //商品订单json数据
    [request setPostValue:content  forKey:@"content"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestBuy:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"付费中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}
- (void)requestBuy:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSLog(@"%@", request.responseString);
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!json)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:request.responseString
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        self.payBtn.enabled = YES;
        return;
    }
    
    OrdersNum *num = [Tool readJsonStrToOrdersNum:request.responseString];
    int errorCode = num.flag;
    NSString *errorMessage = num.msg;
    switch (errorCode) {
        case 1:
        {
            UserModel *usermodel = [UserModel Instance];
            PayOrder *pro = [[PayOrder alloc] init];
            pro.out_no = num.trade_no;
            
            //            pro.price = 0.01;
//            pro.price = totalMoney;
            pro.price = [[NSString stringWithFormat:@"%.2f", [num.amount doubleValue]] doubleValue];
            pro.partnerID = [usermodel getUserValueForKey:@"DEFAULT_PARTNER"];
            pro.partnerPrivKey = [usermodel getUserValueForKey:@"PRIVATE"];
            pro.sellerID = [usermodel getUserValueForKey:@"DEFAULT_SELLER"];
            
            NSString *orderString = @"";
            if ([self.type isEqualToString:@"1"]) {
                pro.subject = @"缴纳水费";
                pro.body = @"水费在线付款";
                orderString = [AlipayUtils getPayStr:pro NotifyURL:api_shui_notify];
            }
            else if([self.type isEqualToString:@"2"])
            {
                pro.subject = @"缴纳电费";
                pro.body = @"电费在线付款";
                orderString = [AlipayUtils getPayStr:pro NotifyURL:api_dian_notify];
            }
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"LuoYangAlipay" callback:^(NSDictionary *resultDic)
             {
                 NSString *resultState = resultDic[@"resultStatus"];
                 if([resultState isEqualToString:ORDER_PAY_OK])
                 {
                     [self buyOK];
                 }
             }];
        }
            break;
        case 0:
        {
            self.payBtn.enabled = YES;
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        }
            break;
    }
}

- (void)buyOK
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                 message:@"支付成功"                         delegate:self
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitles:nil];
    [av show];
}

//弹出框事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
