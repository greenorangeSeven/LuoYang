//
//  LifePayTypeView.m
//  LuoYangSQ
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "LifePayTypeView.h"
#import "LifePayDetailView.h"
#import "RanQiFeeView.h"

@interface LifePayTypeView ()
{
    NSString *jigouName;
}

@end

@implementation LifePayTypeView

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
        jigouName = @"水务集团";
    }
    else if([self.type isEqualToString:@"2"])
    {
        titleName = @"缴纳电费";
        jigouName = @"电力公司";
    }
    else if([self.type isEqualToString:@"3"])
    {
        titleName = @"缴纳燃气费";
        jigouName = @"燃气公司";
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
    
    [self.jigouNameBtn setTitle:jigouName forState:UIControlStateNormal];
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

- (IBAction)wuyeGetAction:(id)sender {
    if([self.type isEqualToString:@"3"])
    {
        RanQiFeeView *ranqiView = [[RanQiFeeView alloc] init];
        [self.navigationController pushViewController:ranqiView animated:YES];
    }
    else
    {
        LifePayDetailView *payDetail = [[LifePayDetailView alloc] init];
        payDetail.type = self.type;
        [self.navigationController pushViewController:payDetail animated:YES];
    }
}

- (IBAction)jigouGetAction:(id)sender {
//    您所在的社区工程师正在进行系统对接，即将上线！
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您所在的社区工程师正在进行系统对接，即将上线！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
}
@end
