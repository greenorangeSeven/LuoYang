//
//  MyInBoxView.m
//  BeautyLife
//
//  Created by Seven on 14-8-20.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "MyInBoxView.h"

@interface MyInBoxView ()

@end

@implementation MyInBoxView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"我的收件箱";
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
    usermodel = [UserModel Instance];
    self.inboxNumLb.text = [usermodel getUserValueForKey:@"inboxnum"];
    
    self.myInboxTable.dataSource = self;
    self.myInboxTable.delegate = self;
    //    设置无分割线
    self.myInboxTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    //设置图形上部圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
    [self reload];
    
    //适配iOS7uinavigationbar遮挡问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)reload
{
    [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&cid=%@&build_id=%@&house_number=%@", api_base_url, api_myinbox, appkey, [usermodel getUserValueForKey:@"cid"], [usermodel getUserValueForKey:@"build_id"], [usermodel getUserValueForKey:@"house_number"]];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           myInExpressData = [Tool readJsonStrToMyOutBox:operation.responseString];
                                           [self.myInboxTable reloadData];
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
    return [myInExpressData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySendExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:MySendExpressCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MySendExpressCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MySendExpressCell class]]) {
                cell = (MySendExpressCell *)o;
                break;
            }
        }
    }
    
    [Tool borderView:cell.bgLb];
    OutExpress *exp = [myInExpressData objectAtIndex:[indexPath row]];
    NSString *timeStr = [Tool TimestampToDateStr:exp.addtime andFormatterStr:@"YYYY年MM月dd日 HH:mm"];
    cell.boxInfoLb.text = [NSString stringWithFormat:@"您%@添加的%@,%@", timeStr, exp.express_type, exp.status];
    if ([exp.express_number length] > 0) {
        cell.expInfoLb.text = [NSString stringWithFormat:@"%@  单号:%@", exp.express_company, exp.express_number];
    }
    
    return cell;
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutExpress *exp = [myInExpressData objectAtIndex:[indexPath row]];
    if (exp) {
        KuaiDi100View *kuaidi100 = [[KuaiDi100View alloc] init];
        kuaidi100.expcom = exp.express_company;
        kuaidi100.expnum = exp.express_number;
        [self.navigationController pushViewController:kuaidi100 animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)addMyInBoxAciton:(id)sender {
    AddInboxView *addInbox = [[AddInboxView alloc] init];
    [self.navigationController pushViewController:addInbox animated:YES];

}

@end
