//
//  DuiHuanBuyView.m
//  LuoYangSQ
//
//  Created by Seven on 15/9/3.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "DuiHuanBuyView.h"
#import "DuiHuanInfo.h"
#import "PayOrder.h"
#import "AlipayUtils.h"
#import <AlipaySDK/AlipaySDK.h>

@interface DuiHuanBuyView ()

@end

@implementation DuiHuanBuyView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"付款信息确认";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    UserModel *user = [UserModel Instance];
    //适配iOS7uinavigationbar遮挡问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.amountLb.text = [NSString stringWithFormat:@"￥%@", self.amountStr];
    self.nameField.text = [user getUserValueForKey:@"name"];
    self.addressField.text = [user getUserValueForKey:@"address"];
    self.phoneField.text =[user getUserValueForKey:@"tel"];
    [self initOrderTitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyOK) name:ORDER_PAY_NOTIC object:nil];
}

- (void)initOrderTitle
{    
    NSMutableString *goodsTitleStr = [[NSMutableString alloc] init];
    [goodsTitleStr appendString:[NSString stringWithFormat:@"%@     数量：%@\n", [NSString stringWithFormat:@"%@  %@", _goods.title,  _goods.attrsStr], _goods.number]];
    self.GoodsTitles.text = goodsTitleStr;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBuy:(UIButton *)sender
{
    self.payBuootn.enabled = NO;
    NSString *nameStr = self.nameField.text;
    NSString *phoneStr = self.phoneField.text;
    NSString *addressStr = self.addressField.text;
    
    if (nameStr == nil || [nameStr length] == 0)
    {
        [Tool showCustomHUD:@"请输入姓名" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (![phoneStr isValidPhoneNum])
    {
        [Tool showCustomHUD:@"请输入手机号" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (addressStr == nil || [addressStr length] == 0)
    {
        [Tool showCustomHUD:@"请输入地址" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    DuiHuanInfo *dhInfo = [[DuiHuanInfo alloc] init];
    dhInfo.duihuan_quan02 = self.goods.duihuan_quan02;
    dhInfo.receiver = nameStr;
    dhInfo.address = addressStr;
    dhInfo.mobile = phoneStr;
    dhInfo.duihuan_xianjin = self.goods.duihuan_xianjin;
    dhInfo.attr = self.goods.attrsStr;
    
    NSData *jsonData = [PrintObject getJSON:dhInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self payFeeAction:jsonText];
}

#pragma mark 付费事件处理
- (void)payFeeAction:(NSString *)content
{
    UserModel *user = [UserModel Instance];
    NSString *regUrl = [NSString stringWithFormat:@"%@/duihuanXiaofei", api_base_url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:@"1"  forKey:@"keys"];
    [request setPostValue:self.goods.id  forKey:@"goods_id"];
    [request setPostValue:[user getUserValueForKey:@"id"]  forKey:@"customer_id"];
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
            pro.out_no = num.serial_no;
            pro.subject = @"订单付款";
            pro.body = @"订单在线付款";
            //            pro.price = 0.01;
            pro.price = [self.goods.duihuan_xianjin doubleValue];
            pro.partnerID = [usermodel getUserValueForKey:@"DEFAULT_PARTNER"];
            pro.partnerPrivKey = [usermodel getUserValueForKey:@"PRIVATE"];
            pro.sellerID = [usermodel getUserValueForKey:@"DEFAULT_SELLER"];
            
            NSString *orderString = [AlipayUtils getPayStr:pro NotifyURL:api_goods_notify];
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
            self.payBuootn.enabled = YES;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
