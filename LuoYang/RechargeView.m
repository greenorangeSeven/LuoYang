//
//  RechargeView.m
//  BeautyLife
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "RechargeView.h"

@interface RechargeView ()

@end

@implementation RechargeView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"智慧查询";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
        UIBarButtonItem *btnMy = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnMy;
        
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
    //适配iOS7uinavigationbar遮挡tableView的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [Tool getBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)huocheAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"火车票";
    detailView.urlStr = @"http://touch.qunar.com/h5/train/?from=touchindex";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)jipiaoAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"机票";
    detailView.urlStr = @"http://touch.qunar.com/h5/flight/";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)yidongAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"移动充值";
    detailView.urlStr = @"http://wap.10086.cn/czjf/czjf.jsp";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)liantongAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"联通充值";
    detailView.urlStr = @"http://wap.10010.com/t/home.htm";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)dianxinAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"电信充值";
    detailView.urlStr = @"http://wapzt.189.cn";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)tianqiAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"天气";
    detailView.urlStr = @"http://mobile.weather.com.cn";
    [self.navigationController pushViewController:detailView animated:YES];
//    http://mobile.weather.com.cn/city/101300101.html
}

- (IBAction)wannianliAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"万年历";
    detailView.urlStr = @"http://m.46644.com/tool/calendar/?tpltype=weixin";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)shenfenzhengAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"身份证";
    detailView.urlStr = @"http://m.46644.com/tool/idcard/?tpltype=weixin";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)fangdaiAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"房贷计算器";
    detailView.urlStr = @"http://m.46644.com/tool/loan/?tpltype=weixin";
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
