//
//  SettingView.m
//  oschina
//
//  Created by wangjun on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingView.h"


@implementation SettingView
@synthesize tableSettings;
@synthesize settings;
@synthesize settingsInSection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"设置";
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

#pragma mark - View lifecycle

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!IS_IOS7) {
        [self.tableSettings setBackgroundColor:[Tool getBackgroundColor]];
    }
    
    if ([self.typeView isEqualToString:@"setting"]) {
        ((UILabel *)self.navigationItem.titleView).text = @"设置";
        [self initSettingData];
    }
    else if ([self.typeView isEqualToString:@"my"]) {
        ((UILabel *)self.navigationItem.titleView).text = @"我的";
        [self initMyData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:Notification_RefreshSetting object:nil];
}

- (void)initSettingData
{
    bool islogin = [[UserModel Instance] isLogin];
    self.settingsInSection = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSArray *first = [[NSArray alloc] initWithObjects:
                      [[SettingModel alloc] initWith:@"注册" andImg:@"setting_register" andTag:1 andTitle2:nil],
                      [[SettingModel alloc] initWith: islogin?@"注销":@"登录" andImg:islogin?@"setting_logout":@"setting_login" andTag:2 andTitle2:nil],
                      [[SettingModel alloc] initWith: @"个人信息" andImg:@"setting_info" andTag:3 andTitle2:nil],
                      [[SettingModel alloc] initWith: @"修改密码" andImg:@"setting_update" andTag:4 andTitle2:nil],
                      nil];

    NSArray *third = [[NSArray alloc] initWithObjects:
                      [[SettingModel alloc] initWith:@"版本更新" andImg:@"setting_update" andTag:10 andTitle2:nil],
                      [[SettingModel alloc] initWith:@"推送消息" andImg:@"setting_push" andTag:11 andTitle2:nil],
                      nil];
    
    [self.settingsInSection setObject:first forKey:@"帐号"];
    [self.settingsInSection setObject:third forKey:@"设置"];
    self.settings = [[NSArray alloc] initWithObjects:@"帐号",@"设置",nil];
}

- (void)initMyData
{
    self.settingsInSection = [[NSMutableDictionary alloc] initWithCapacity:1];

    NSArray *second = [[NSArray alloc] initWithObjects:
                       [[SettingModel alloc] initWith:@"我的订单" andImg:@"setting_order" andTag:5 andTitle2:nil],
                       [[SettingModel alloc] initWith:@"我的物业费" andImg:@"setting_propertyfee" andTag:6 andTitle2:nil],
                       [[SettingModel alloc] initWith:@"我的停车费" andImg:@"setting_parkfee" andTag:7 andTitle2:nil],
                       [[SettingModel alloc] initWith:@"我的寄件箱" andImg:@"setting_mail" andTag:8 andTitle2:nil],
                       [[SettingModel alloc] initWith:@"我的收藏" andImg:@"setting_collect" andTag:9 andTitle2:nil],
                       nil];

    
    [self.settingsInSection setObject:second forKey:@"我的"];
    self.settings = [[NSArray alloc] initWithObjects:@"我的",nil];
}

- (void)refresh
{
    [self initSettingData];
    [tableSettings reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [self.tableSettings reloadData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidUnload
{
    [self setTableSettings:nil];
    [super viewDidUnload];
}

#pragma TableView的处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger section = [indexPath section];
    NSString *key = [settings objectAtIndex:section];
    NSArray *sets = [settingsInSection objectForKey:key];
    SettingModel *action = [sets objectAtIndex:[indexPath row]];
    //开始处理
    switch (action.tag) {
        case 1:
        {
            RegisterView *registerView = [[RegisterView alloc] init];
            registerView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:registerView animated:YES];
        }
            break;
        case 2:
        {
            if ([[UserModel Instance] isLogin]) {
                [ASIHTTPRequest setSessionCookies:nil];
                [ASIHTTPRequest clearSession];
                [[UserModel Instance] saveIsLogin:NO];
                [self refresh];
                [Tool showCustomHUD:@"注销成功" andView:self.view andImage:@"37x-Checkmark.png" andAfterDelay:2];
            }
            else
            {
                LoginView *loginView = [[LoginView alloc] init];
                loginView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginView animated:YES];
            }
        }
            break;
        case 3:
        {
            if (![[UserModel Instance] isLogin])
            {
                [Tool showCustomHUD:@"请先登录" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                return;
            }
            UserInfoView *userinfoView = [[UserInfoView alloc] init];
            userinfoView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userinfoView animated:YES];
        }
            break;
        case 4:
        {
            //            ChooseAreaView *chooseView = [[ChooseAreaView alloc] init];
            //            chooseView.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:chooseView animated:YES];
        }
            break;
        case 5:
        {
            if (![[UserModel Instance] isLogin])
            {
                [Tool showCustomHUD:@"请先登录" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                return;
            }
            MyOrderView *myOrderView = [[MyOrderView alloc] init];
            myOrderView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myOrderView animated:YES];
        }
            break;
        case 6:
        {
            if (![[UserModel Instance] isLogin])
            {
                [Tool showCustomHUD:@"请先登录" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                return;
            }
            FeeHistoryView *feeHistoryView = [[FeeHistoryView alloc] init];
            feeHistoryView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feeHistoryView animated:YES];
        }
            break;
        case 7:
        {
            if (![[UserModel Instance] isLogin])
            {
                [Tool showCustomHUD:@"请先登录" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                return;
            }
            FeeHistoryView *feeHistoryView = [[FeeHistoryView alloc] init];
            feeHistoryView.hidesBottomBarWhenPushed = YES;
            feeHistoryView.isShowPark = YES;
            [self.navigationController pushViewController:feeHistoryView animated:YES];
        }
            break;
        case 8:
        {
            if (![[UserModel Instance] isLogin])
            {
                [Tool showCustomHUD:@"请先登录" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                return;
            }
            ExpressView *expressView = [[ExpressView alloc] init];
            expressView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:expressView animated:YES];
        }
            break;
        case 9:
        {
            
        }
            break;
        case 10:
        {
            
        }
            break;
        case 11:
        {
            
        }
            break;
        case 12:
        {
            if (![[UserModel Instance] isLogin])
            {
                [Tool showCustomHUD:@"请先登录" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
            }
            else
            {
                [ASIHTTPRequest setSessionCookies:nil];
                [ASIHTTPRequest clearSession];
                [[UserModel Instance] saveIsLogin:NO];
                [Tool showCustomHUD:@"注销成功" andView:self.view andImage:@"37x-Checkmark.png" andAfterDelay:2];
            }
        }
            break;
        default:
            break;
    }
}

- (void)telAction:(NSString *)phoneNum
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNum]];
    if (!phoneCallWebView) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [settings count];
}
//IOS7自带沾滞效果
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];//创建一个视图
//
//    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
//
//    UIImage *image = [UIImage imageNamed:@"top_bg.png"];
//
//    [headerImageView setImage:image];
//
//    [headerView addSubview:headerImageView];
//
//
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 150, 20)];
//
//    headerLabel.backgroundColor = [UIColor clearColor];
//
//    headerLabel.font = [UIFont boldSystemFontOfSize:15.0];
//
//    headerLabel.textColor = [UIColor blueColor];
//
//    headerLabel.text = @"Section";
//
//    [headerView addSubview:headerLabel];
//
//    return headerView;
//
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [settings objectAtIndex:section];
    NSArray *set = [settingsInSection objectForKey:key];
    return [set count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSString *key = [settings objectAtIndex:section];
    NSArray *sets = [settingsInSection objectForKey:key];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingTableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    }
    SettingModel *model = [sets objectAtIndex:row];
    cell.textLabel.text = model.title;
    [cell.textLabel setFont:[UIFont fontWithName:@"American Typewriter" size:14.0f]];
    cell.imageView.image = [UIImage imageNamed:model.img];
    cell.tag = model.tag;
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end