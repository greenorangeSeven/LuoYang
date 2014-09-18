//
//  MyOrderView.m
//  BeautyLife
//
//  Created by mac on 14-8-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "MyOrderView.h"
#import "MyGoodsCell.h"
#import "MyGoods.h"
#import "EGOImageView.h"
#import "ResponseCode.h"
#import "MyOrder.h"

//确认收货
#define TAKE_ORDER 200
//取消订单
#define CANCLE_ORDER 400

@interface MyOrderView () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *orderData;
    MBProgressHUD *hud;
}

@end

@implementation MyOrderView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"我的订单";
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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    //适配iOS7uinavigationbar遮挡的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //加载订单记录
    [self loadOrder];
}

//弹出框事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == TAKE_ORDER)
    {
        [self loadOrder];
    }
    else if(alertView.tag == CANCLE_ORDER)
    {
        [self loadOrder];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 获取订单记录集合
- (void)loadOrder{
    UserModel *usermodel = [UserModel Instance];
    //如果有网络连接
    if (usermodel.isNetworkRunning) {
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_my_order_list, appkey,[usermodel getUserValueForKey:@"id"]];
        
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [orderData removeAllObjects];
                                       @try {
                                           orderData = [Tool readJsonStrToMyOrder:operation.responseString];
                                           NSLog(@"rty");

                                           if(orderData.count == 0)
                                           {
                                               UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                                            message:@"您当前没有订单信息"                         delegate:self
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
    MyOrder *order = [orderData objectAtIndex:section];
    return order.goodArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return orderData.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyOrder *order = [orderData objectAtIndex:section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];//创建一个视图
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *order_no_Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 180, 20)];
    order_no_Label.backgroundColor = [UIColor clearColor];
    order_no_Label.font = [UIFont boldSystemFontOfSize:12.0];
    order_no_Label.textColor = [UIColor grayColor];
    order_no_Label.text = [NSString stringWithFormat:@"订单号:%@",order.order_sn];
    [headerView addSubview:order_no_Label];
    
    UILabel *time_Label = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 180, 20)];
    time_Label.backgroundColor = [UIColor clearColor];
    time_Label.font = [UIFont boldSystemFontOfSize:12.0];
    time_Label.textColor = [UIColor grayColor];
    time_Label.text = [NSString stringWithFormat:@"下单时间:%@",[Tool TimestampToDateStr:order.addtime andFormatterStr:@"yyyy-MM-dd HH:mm"]];
    [headerView addSubview:time_Label];
    
    UILabel *express_Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 100, 20)];
    express_Label.backgroundColor = [UIColor clearColor];
    express_Label.font = [UIFont boldSystemFontOfSize:12.0];
    express_Label.textColor = [UIColor grayColor];
    express_Label.text = [NSString stringWithFormat:@"快递公司:%@",order.express_company];
    [headerView addSubview:express_Label];
    
    UILabel *express_no_Label = [[UILabel alloc] initWithFrame:CGRectMake(140, 25, 180, 20)];
    express_no_Label.backgroundColor = [UIColor clearColor];
    express_no_Label.font = [UIFont boldSystemFontOfSize:12.0];
    express_no_Label.textColor = [UIColor grayColor];
    express_no_Label.text = [NSString stringWithFormat:@"快递单号:%@",order.express_number];
    [headerView addSubview:express_no_Label];
    
    
    
    UILabel *status_Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 180, 20)];
    status_Label.backgroundColor = [UIColor clearColor];
    status_Label.font = [UIFont boldSystemFontOfSize:12.0];
    status_Label.textColor = [UIColor redColor];
    status_Label.text = [NSString stringWithFormat:@"订单状态:%@",order.status];
   [headerView addSubview:status_Label];
    
    if([order.status isEqualToString:@"卖家已发货"] ||
       [order.status isEqualToString:@"未付款"])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(220, 40, 90, 30);
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.textColor = [UIColor blueColor];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        if([order.status isEqualToString:@"卖家已发货"])
        {
            [btn setTitle:@"确认收货" forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitle:@"取消订单" forState:UIControlStateNormal];
        }
        [btn setTag:section];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];

        NSLog(@"nhujmkilop");
    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];//创建一个视图
    footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 320, 1)];
    lineLabel.backgroundColor = [UIColor grayColor];
    [footerView addSubview:lineLabel];
    
    return footerView;
}

//确认收货和取消订单按钮事件
- (void) btnClick:(UIButton *) target
{
    MyOrder *order = [orderData objectAtIndex:[target tag]];
    if([order.status isEqualToString:@"卖家已发货"])
    {
        [self verifyShouHuo:order];
    }
    else
    {
        [self cancleOrder:order];
    }
}

//确认收货
- (void)verifyShouHuo:(MyOrder *)order
{
    UserModel *usermodel = [UserModel Instance];
    //如果有网络连接
    if (usermodel.isNetworkRunning) {
        [Tool showHUD:@"正在确认收货" andView:self.view andHUD:hud];
        
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@&order_sn=%@", api_base_url, api_take_my_order, appkey,order.userid,order.order_sn];
        
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           ResponseCode *code = [Tool readJsonStrToResponseCode:operation.responseString];
                                           UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:code.info
                                                    delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
                                           [av setTag:TAKE_ORDER];
                                           [av show];
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

//取消订单
- (void)cancleOrder:(MyOrder *)order
{
    UserModel *usermodel = [UserModel Instance];
    //如果有网络连接
    if (usermodel.isNetworkRunning) {
        [Tool showHUD:@"正在取消订单" andView:self.view andHUD:hud];
        
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@&order_sn=%@", api_base_url, api_cancel_my_order, appkey,order.userid,order.order_sn];
        
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           ResponseCode *code = [Tool readJsonStrToResponseCode:operation.responseString];
                                           UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:code.info
                                                    delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
                                           [av setTag:CANCLE_ORDER];
                                           [av show];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:FeeHistoryIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyGoodsCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MyGoodsCell class]]) {
                cell = (MyGoodsCell *)o;
                break;
            }
        }
    }
    MyOrder *order = [orderData objectAtIndex:indexPath.section];
    MyGoods *goods = [order.goodArray objectAtIndex:indexPath.row];
    cell.title.text = goods.goods_name;
    cell.numbers.text = goods.quantity;
    cell.price.text = goods.price;
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"nopic2.png"]];
    imageView.imageURL = [NSURL URLWithString:goods.thumb];
    imageView.frame = CGRectMake(0.0f, 0.0f, 80.0f, 80.0f);
    [cell.img addSubview:imageView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 120;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


@end
