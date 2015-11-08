//
//  RanQiFeeView.m
//  LuoYangSQ
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "RanQiFeeView.h"
#import "PayOrder.h"
#import "AlipayUtils.h"
#import <AlipaySDK/AlipaySDK.h>

@interface RanQiFeeView ()

@end

@implementation RanQiFeeView

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
    titleLabel.text = @"缴纳燃气费";
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

- (IBAction)payAction:(id)sender {
    [self.view endEditing:YES];
    NSString *comNameStr = self.companyNameTf.text;
    NSString *rqCodeNumStr = self.rqCodeNumTf.text;
    NSString *moneyStr = self.moneyTv.text;
    if (comNameStr == nil || [comNameStr length] == 0)
    {
        [Tool showCustomHUD:@"请输入缴纳单位" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (rqCodeNumStr == nil || [rqCodeNumStr length] == 0)
    {
        [Tool showCustomHUD:@"请输入燃气客户编号" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (moneyStr == nil || [moneyStr length] == 0)
    {
        [Tool showCustomHUD:@"请输入充值金额" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.payBtn.enabled = NO;
    
    NSString *qrStr = [NSString stringWithFormat:@"您向%@ 客户编号为：%@，充值%@元燃气费", comNameStr, rqCodeNumStr, moneyStr];
    
    UIAlertView *qrAlert = [[UIAlertView alloc] initWithTitle:@"充值确认" message:qrStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    qrAlert.tag = 0;
    [qrAlert show];
    
}

- (void)payFeeMethod
{
    UserModel *user = [UserModel Instance];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.companyNameTf.text forKey:@"comname"];
    [dictionary setValue:self.rqCodeNumTf.text forKey:@"number"];
    [dictionary setValue:self.moneyTv.text forKey:@"money"];
    [dictionary setValue:[user getUserValueForKey:@"id"] forKey:@"userid"];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *regUrl  = [NSString stringWithFormat:@"%@%@", api_base_url, api_ranqipay];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    //商品订单json数据
    [request setPostValue:jsonStr  forKey:@"content"];
    
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
            
            pro.subject = @"燃气充值";
            pro.body = @"燃气在线充值";
            orderString = [AlipayUtils getPayStr:pro NotifyURL:api_ranqi_notify];
            
            
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
    if (buttonIndex == 1)
    {
        if (alertView.tag == 0)
        {
            [self payFeeMethod];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
