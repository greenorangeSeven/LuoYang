//
//  StewardFeeView.m
//  BeautyLife
//
//  Created by Seven on 14-8-1.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "StewardFeeView.h"
#import "AlipayUtils.h"
#import "PayOrder.h"
#import "OrdersNum.h"
#import "FeeHistoryView.h"
#import <AlipaySDK/AlipaySDK.h>

@interface StewardFeeView ()

@end

@implementation StewardFeeView

@synthesize scrollView;
@synthesize bgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    usermodel = [UserModel Instance];
    //用户是否已认证，已认证后才能报修
//    if (![[usermodel getUserValueForKey:@"checkin"] isEqualToString:@"1"]) {
//        self.payfeeBtn.enabled = NO;
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提醒"
//                                                     message:@"您的入住信息暂未审核通过，暂未能在线缴费，请联系客户服务中心！"
//                                                    delegate:nil
//                                           cancelButtonTitle:@"确定"
//                                           otherButtonTitles:nil];
//        [av show];
//    }
//    else
//    {
//        [self getPropertyFee];
//    }
    if ([[usermodel getUserValueForKey:@"house_number"] isEqualToString:@""]) {
        self.payfeeBtn.enabled = NO;
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提醒"
                                                     message:@"您的个人信息不完善，暂未能在线缴费，请完善个人信息！"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
        [av show];
    }
    [Tool roundView:self.bgView andCornerRadius:3.0];
    if (!IS_IPHONE_5) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, 473);
    }
    
    self.nameLb.text = [usermodel getUserValueForKey:@"name"];
    self.telLb.text = [NSString stringWithFormat:@"(%@)", [usermodel getUserValueForKey:@"tel"]];
    EGOImageView *faceEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"userface.png"]];
    faceEGOImageView.imageURL = [NSURL URLWithString:[[UserModel Instance] getUserValueForKey:@"avatar"]];
    faceEGOImageView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    [self.faceIv addSubview:faceEGOImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[usermodel getUserValueForKey:@"house_number"] isEqualToString:@""] == NO)
    {
        self.payfeeBtn.enabled = YES;
        [self getPropertyFee];
    }
//    if ([Tool testAlipayInstall]) {
//        self.payfeeBtn.hidden = NO;
//    }
//    else
//    {
//        self.payfeeBtn.hidden = YES;
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UserInfoView *userinfoView = [[UserInfoView alloc] init];
        userinfoView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userinfoView animated:YES];
    }
}

- (void)getPropertyFee
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_mypropertyfee, appkey, [[UserModel Instance] getUserValueForKey:@"id"]];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           PropertyFeeInfo *feeInfo = [Tool readJsonStrToPropertyFeeInfo:operation.responseString];
                                           
                                           self.userInfoLb.text = [NSString stringWithFormat:@"%@%@%@(%@㎡)", [usermodel getUserValueForKey:@"comm_name"], [usermodel getUserValueForKey:@"build_name"], feeInfo.house_number, feeInfo.area];
                                           
                                           monthFee = [feeInfo.property_fee doubleValue] * [feeInfo.area intValue];
                                           //获得已缴月份
                                           int endFeeMonth = [[feeInfo.fee_enddate substringWithRange:NSMakeRange(0, 4)] intValue] *12 + [[feeInfo.fee_enddate substringWithRange:NSMakeRange(5, 2)] intValue];
//                                           //获得当前月份
//                                           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                                           [formatter setDateFormat:@"YYYY-MM"];
//                                           NSString *currentMonthStr = [formatter stringFromDate:[NSDate date]];
//                                           int currentMonth = [[currentMonthStr substringWithRange:NSMakeRange(0, 4)] intValue] *12 + [[currentMonthStr substringWithRange:NSMakeRange(5, 2)] intValue];
                                           //获得当前月份
                                           NSDate* now = [NSDate date];
                                           NSCalendar *cal = [NSCalendar currentCalendar];
                                           
                                           unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
                                           NSDateComponents *dd = [cal components:unitFlags fromDate:now];
                                           int y = [dd year];
                                           int m = [dd month];
                                           int currentMonth = y *12 + m;
                                           
                                           if ( (currentMonth - endFeeMonth) > 0)
                                           {
                                               arrearage = monthFee * (currentMonth - endFeeMonth);
                                               arrearageMonth = currentMonth - endFeeMonth;
                                               self.feeinfoLb.text = [NSString stringWithFormat:@"您已欠缴%d个月物业费", currentMonth - endFeeMonth];
                                           }
                                           else
                                           {
                                               arrearage = 0.00;
                                               arrearageMonth = 0;
                                               self.feeinfoLb.text = [NSString stringWithFormat:@"您的物业费将于%d个月后到期", endFeeMonth - currentMonth];
                                           }
                                           self.shouldPayLb.text = [NSString stringWithFormat:@"￥%0.2f元", arrearage];
                                           self.sumMoneyLb.text = [NSString stringWithFormat:@"￥%0.2f元", arrearage];
                                           
                                           //不预交字典
                                           NSDictionary *preset0 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    @"0.00", @"money",
                                                                    @"不预缴", @"text", nil];
                                           //季度预交字典，季度98折优惠
                                           double month3Fee = monthFee * 3 * [feeInfo.three_month_discount doubleValue];
                                           NSDictionary *preset1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [Tool notRounding:month3Fee afterPoint:2], @"money",
                                                                    [NSString stringWithFormat:@"预缴一季度  %@元", [Tool notRounding:month3Fee afterPoint:2]], @"text", nil];
                                           //半年预交字典，半年95折优惠
                                           double month6Fee = monthFee * 6 * [feeInfo.six_month_discount doubleValue];
                                           NSDictionary *preset2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [Tool notRounding:month6Fee afterPoint:2], @"money",
                                                                    [NSString stringWithFormat:@"预缴半年  %@元", [Tool notRounding:month6Fee afterPoint:2]], @"text", nil];
                                           //一年预交字典，半年9折优惠
                                           double month12Fee = monthFee * 12 * [feeInfo.one_year_discount doubleValue];
                                           NSDictionary *preset3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [Tool notRounding:month12Fee afterPoint:2], @"money",
                                                                    [NSString stringWithFormat:@"预缴一年  %@元", [Tool notRounding:month12Fee afterPoint:2]], @"text", nil];
                                           presetData = [[NSArray alloc] initWithObjects:preset0, preset1, preset2, preset3, nil];
                                           
                                           NSDictionary *preset = (NSDictionary *)[presetData objectAtIndex:0];
                                           
                                           presetMonth = 0;
                                           presetValue = [[preset objectForKey:@"money"] doubleValue];
                                           [self.presetBtn setTitle:[preset objectForKey:@"text"] forState:UIControlStateNormal];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           
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
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPresetAction:(id)sender {
    if (IS_IOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIPickerView *catePicker = [[UIPickerView alloc] init];
        catePicker.delegate = self;
        catePicker.showsSelectionIndicator = YES;
        [alert.view addSubview:catePicker];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    double sumMoney = arrearage + presetValue;
                                                    self.sumMoneyLb.text = [NSString stringWithFormat:@"￥%0.2f元", sumMoney];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        actionSheet.tag = 0;
        [actionSheet showInView:self.parentView];
        UIPickerView *catePicker = [[UIPickerView alloc] init];
        catePicker.delegate = self;
        catePicker.showsSelectionIndicator = YES;
        [actionSheet addSubview:catePicker];
    }
}

#pragma mark 付费按钮事件处理
- (IBAction)payFeeAction:(UIButton *)sender
{
    NSString *regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_pay_property_fee];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    //用户ID
    [request setPostValue:[usermodel getUserValueForKey:@"id"]  forKey:@"userid"];
    //社区ID
    [request setPostValue:[usermodel getUserValueForKey:@"cid"] forKey:@"cid"];
    //楼宇ID
    [request setPostValue:[usermodel getUserValueForKey:@"build_id"] forKey:@"build_id"];
    //房间编号
    [request setPostValue:[usermodel getUserValueForKey:@"house_number"] forKey:@"house_number"];
    int month = presetMonth + arrearageMonth;
    //缴费月数
    [request setPostValue:[NSString stringWithFormat:@"%i",month] forKey:@"mount"];
    //缴费金额
    double sumMoney = arrearage + presetValue;
    [request setPostValue:[NSString stringWithFormat:@"%f",sumMoney] forKey:@"amount"];
    //费用名称
    [request setPostValue:@"物业费缴纳" forKey:@"fee_name"];
    //备注
    [request setPostValue:[NSString stringWithFormat:@"%@缴纳了%i个月物业费",[usermodel getUserValueForKey:@"name"],month] forKey:@"remark"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestBuy:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"缴费中..." andView:self.view andHUD:request.hud];
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
            PayOrder *pro = [[PayOrder alloc] init];
            pro.out_no = num.trade_no;
            pro.subject = @"深盟智慧社区物业费";
            pro.body = @"深盟智慧社区物业费在线缴纳";
            double sumMoney = arrearage + presetValue;
            pro.price = sumMoney;
//            pro.price = 0.01;
            pro.partnerID = [usermodel getUserValueForKey:@"DEFAULT_PARTNER"];
            pro.partnerPrivKey = [usermodel getUserValueForKey:@"PRIVATE"];
            pro.sellerID = [usermodel getUserValueForKey:@"DEFAULT_SELLER"];
            
            NSString *orderString = [AlipayUtils getPayStr:pro NotifyURL:api_property_notify];
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"LuoYangAlipay" callback:^(NSDictionary *resultDic)
             {
                 NSString *resultState = resultDic[@"resultStatus"];
                 if([resultState isEqualToString:ORDER_PAY_OK])
                 {
                     [self updatePayedTable];
                 }
             }];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        }
            break;
    }
}

#pragma mark 刷新列表(当程序支付时在后台被kill掉时供appdelegate调用)
- (void)updatePayedTable
{
    [Tool showCustomHUD:@"支付成功" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:2];
}

#pragma -mark 显示我的缴费历史
- (IBAction)showHistoryAction:(UIButton *)sender
{
    FeeHistoryView *feeHistoryView = [[FeeHistoryView alloc] init];
    feeHistoryView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feeHistoryView animated:YES];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            double sumMoney = arrearage + presetValue;
            self.sumMoneyLb.text = [NSString stringWithFormat:@"￥%0.2f元", sumMoney];
        }
    }
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [presetData count];
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *preset = (NSDictionary *)[presetData objectAtIndex:row];
    return [preset objectForKey:@"text"];
}

-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    NSDictionary *preset = (NSDictionary *)[presetData objectAtIndex:row];
    presetValue = [[preset objectForKey:@"money"] doubleValue];
    
    switch (row) {
        case 0:
            presetMonth = 0;
            break;
        case 1:
            presetMonth = 3;
            break;
        case 2:
            presetMonth = 6;
            break;
        case 3:
            presetMonth = 12;
            break;
        default:
            presetMonth = 0;
            break;
    }
    [self.presetBtn setTitle:[preset objectForKey:@"text"] forState:UIControlStateNormal];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, 30)];
    myView.textAlignment = UITextAlignmentCenter;
    NSDictionary *preset = (NSDictionary *)[presetData objectAtIndex:row];
    myView.text = [preset objectForKey:@"text"];
    myView.font = [UIFont systemFontOfSize:16];         //用label来设置字体大小
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

@end
