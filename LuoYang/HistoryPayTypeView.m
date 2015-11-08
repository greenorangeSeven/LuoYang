//
//  HistoryPayTypeView.m
//  LuoYangSQ
//
//  Created by Seven on 15/10/28.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "HistoryPayTypeView.h"
#import "HistoryPayFeeView.h"

@interface HistoryPayTypeView ()

@end

@implementation HistoryPayTypeView

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配iOS7uinavigationbar遮挡问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"生活历史缴费";
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

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)shuiHistoryAction:(id)sender {
    HistoryPayFeeView *lifePayType = [[HistoryPayFeeView alloc] init];
    lifePayType.type = @"1";
    [self.navigationController pushViewController:lifePayType animated:YES];
}

- (IBAction)dianHistoryAction:(id)sender {
    HistoryPayFeeView *lifePayType = [[HistoryPayFeeView alloc] init];
    lifePayType.type = @"2";
    [self.navigationController pushViewController:lifePayType animated:YES];
}

- (IBAction)ranqiHistoryAction:(id)sender {
    HistoryPayFeeView *lifePayType = [[HistoryPayFeeView alloc] init];
    lifePayType.type = @"3";
    [self.navigationController pushViewController:lifePayType animated:YES];
}
@end
