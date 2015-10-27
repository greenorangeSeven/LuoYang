//
//  ShoppingBuyView.m
//  BeautyLife
//
//  Created by mac on 14-9-4.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ShoppingBuyView.h"
#import "OrderInfo.h"
#import "OrderBusiness.h"
#import "OrderGood.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "RMMapper.h"
//#import "JSONKit.h"
#import "PrintObject.h"
#import "PayOrder.h"
#import "AlipayUtils.h"
#import <AlipaySDK/AlipaySDK.h>

@interface ShoppingBuyView () <UIAlertViewDelegate>

@end

@implementation ShoppingBuyView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    if ([Tool testAlipayInstall]) {
    //        self.payBuootn.hidden = NO;
    //    }
    //    else
    //    {
    //        self.payBuootn.hidden = YES;
    //    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)buyOK
{
    FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
    if (![database open]) {
        NSLog(@"Open database failed");
        return;
    }
    if (![database tableExists:@"shoppingcart"])
    {
        [database executeUpdate:createshoppingcart];
    }
    BOOL isOK = [database executeUpdate:@"DELETE FROM shoppingcart"];
    if(isOK)
    {
        NSLog(@"数据已清空");
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initOrderTitle
{
    UserModel *user = [UserModel Instance];
    
    NSMutableString *goodsTitleStr = [[NSMutableString alloc] init];
    
    if(_goods == nil)
    {
        FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
        if (![database open]) {
            NSLog(@"Open database failed");
            return;
        }
        if (![database tableExists:@"shoppingcart"])
        {
            [database executeUpdate:createshoppingcart];
        }
        FMResultSet* businessSet=[database executeQuery:@"SELECT DISTINCT business_id FROM shoppingcart where user_id = ? and ischeck = '1'", [user getUserValueForKey:@"id"]];
        while ([businessSet next]) {
            FMResultSet* goodSet=[database executeQuery:@"SELECT * FROM shoppingcart where business_id = ? and ischeck = '1'", [businessSet stringForColumn:@"business_id"]];
            while ([goodSet next]) {
                [goodsTitleStr appendString:[NSString stringWithFormat:@"%@     数量：%@\n", [NSString stringWithFormat:@"%@  %@", [goodSet stringForColumn:@"title"], [goodSet stringForColumn:@"attrs"]], [NSNumber numberWithInteger:[goodSet intForColumn:@"number"]]]];
            }
        }
        [database close];
    }
    else
    {
        [goodsTitleStr appendString:[NSString stringWithFormat:@"%@     数量：%@\n", [NSString stringWithFormat:@"%@  %@", _goods.title,  _goods.attrsStr], _goods.number]];
    }
    self.GoodsTitles.text = goodsTitleStr;
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
    UserModel *user = [UserModel Instance];
    
    OrderInfo *orderInfo = [[OrderInfo alloc] init];
    orderInfo.userid = [NSNumber numberWithInt:[[user getUserValueForKey:@"id"] intValue]];
    orderInfo.mobile = phoneStr;
    orderInfo.address = addressStr;
    orderInfo.receiver = nameStr;
    //    orderInfo.amount = [NSNumber numberWithFloat:total];
    if(_goods == nil)
    {
        FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
        if (![database open]) {
            NSLog(@"Open database failed");
            return;
        }
        if (![database tableExists:@"shoppingcart"])
        {
            [database executeUpdate:createshoppingcart];
        }
        FMResultSet* businessSet=[database executeQuery:@"SELECT DISTINCT business_id FROM shoppingcart where user_id = ? and ischeck = '1'", [user getUserValueForKey:@"id"]];
        NSMutableArray *orderBusinessArray = [[NSMutableArray alloc] init];
        while ([businessSet next]) {
            OrderBusiness *business = [[OrderBusiness alloc] init];
            business.store_id = [NSNumber numberWithInt:[[businessSet stringForColumn:@"business_id"] intValue]];
            
            FMResultSet* goodSet=[database executeQuery:@"SELECT * FROM shoppingcart where business_id = ? and user_id = ? and ischeck = '1'", [businessSet stringForColumn:@"business_id"], [user getUserValueForKey:@"id"]];
            NSMutableArray *goodArray = [[NSMutableArray alloc] init];
            float businessAmount = 0.0;
            while ([goodSet next]) {
                OrderGood *good = [[OrderGood alloc] init];
                good.goods_id = [NSNumber numberWithInt:[[goodSet stringForColumn:@"goodid"] intValue]];
                good.title = [goodSet stringForColumn:@"title"];
                good.title = [NSString stringWithFormat:@"%@  %@", [goodSet stringForColumn:@"title"], [goodSet stringForColumn:@"attrs"]];
                good.price = [goodSet stringForColumn:@"price"];
                good.quantity = [NSNumber numberWithInteger:[goodSet intForColumn:@"number"]];
                businessAmount += [good.price floatValue] * [goodSet intForColumn:@"number"];
                [goodArray addObject:good];
            }
            business.goodlist = goodArray;
            business.amount = [NSNumber numberWithFloat:businessAmount];
            amount = [business.amount doubleValue];
            [orderBusinessArray addObject:business];
        }
        [database close];
        orderInfo.businessOrderList = orderBusinessArray;
    }
    else
    {
        NSMutableArray *orderBusinessArray = [[NSMutableArray alloc] init];
        OrderBusiness *business = [[OrderBusiness alloc] init];
        NSLog(@"the:%@",_goods.business_id);
        business.store_id = [[NSNumber alloc] initWithInt:[_goods.business_id intValue]];
        NSLog(@"thessss:%@",business.store_id);
        NSMutableArray *goodArray = [[NSMutableArray alloc] init];
        float businessAmount = 0.0;
        OrderGood *good = [[OrderGood alloc] init];
        good.goods_id = [[NSNumber alloc] initWithInt:[_goods.id intValue]];
        good.title = [NSString stringWithFormat:@"%@  %@", _goods.title,  _goods.attrsStr];
        good.price = _goods.price;
        good.quantity = _goods.number;
        businessAmount += [good.price floatValue] * [_goods.number intValue];
        [goodArray addObject:good];
        
        business.goodlist = goodArray;
        business.amount = [NSNumber numberWithFloat:businessAmount];
        amount = [business.amount doubleValue];
        [orderBusinessArray addObject:business];
        
        orderInfo.businessOrderList = orderBusinessArray;
    }
    
    NSData *jsonData = [PrintObject getJSON:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(jsonText);
    [self payFeeAction:jsonText];
}

#pragma mark 付费事件处理
- (void)payFeeAction:(NSString *)content
{
    NSString *regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_send_order];
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
    int errorCode = [num.status intValue];
    NSString *errorMessage = num.info;
    switch (errorCode) {
        case 1:
        {
            [self deleteSelectGoods];
            UserModel *usermodel = [UserModel Instance];
            PayOrder *pro = [[PayOrder alloc] init];
            pro.out_no = num.serial_no;
            pro.subject = @"订单付款";
            pro.body = @"订单在线付款";
            //            pro.price = 0.01;
            pro.price = amount;
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

- (void)deleteSelectGoods
{
    FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
    if (![database open]) {
        NSLog(@"Open database failed");
        return;
    }
    if (![database tableExists:@"shoppingcart"])
    {
        [database executeUpdate:createshoppingcart];
    }
    BOOL isOK = [database executeUpdate:@"DELETE FROM shoppingcart where ischeck = '1'"];
    [database close];
    if(isOK)
    {
        NSLog(@"数据已清空");
    }
}

@end
