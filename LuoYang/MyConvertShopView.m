//
//  MyConvertShopView.m
//  LuoYangSQ
//
//  Created by Seven on 15/9/1.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "MyConvertShopView.h"
#import "ConvertShopCell.h"
#import "ConvertShop.h"
#import "UIImageView+WebCache.h"

@interface MyConvertShopView ()
{
    NSMutableArray *mydhList;
    MBProgressHUD *hud;
}

@end

@implementation MyConvertShopView

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = @"我的兑换记录";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
    self.navigationItem.leftBarButtonItem = btnBack;

    //适配iOS7uinavigationbar遮挡的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self loadDHJL];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取订单记录集合
- (void)loadDHJL{
    UserModel *usermodel = [UserModel Instance];
    //如果有网络连接
    if (usermodel.isNetworkRunning) {
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSString *duihuanListUrl = [NSString stringWithFormat:@"%@/myDuihuanShop?APPKey=%@&tel=%@", api_base_url, appkey,[usermodel getUserValueForKey:@"tel"]];
        
        [[AFOSCClient sharedClient]getPath:duihuanListUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [mydhList removeAllObjects];
                                       @try {
                                           mydhList = [Tool readJsonStrToConvertShopArray:operation.responseString];
                                           
                                           if(mydhList.count > 0)
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

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mydhList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConvertShopCell *cell = [tableView dequeueReusableCellWithIdentifier:ConvertShopCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ConvertShopCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[ConvertShopCell class]]) {
                cell = (ConvertShopCell *)o;
                break;
            }
        }
    }
    ConvertShop *n = [mydhList objectAtIndex:[indexPath row]];
    [cell.imageIv sd_setImageWithURL:[NSURL URLWithString:n.thumb] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleLb.text = n.title;
    cell.logLb.text = n.log;
    
    return cell;
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
