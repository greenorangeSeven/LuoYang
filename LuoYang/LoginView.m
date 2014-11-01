//
//  LoginView.m
//  BeautyLife
//
//  Created by Seven on 14-8-12.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

@end

@implementation LoginView
@synthesize scrollView;
@synthesize mobileTf;
@synthesize pwdTf;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"登录";
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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    NSString *mobileStr = self.mobileTf.text;
    NSString *pwdStr = self.pwdTf.text;
    if (![mobileStr isValidPhoneNum]) {
        [Tool showCustomHUD:@"手机号错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (pwdStr == nil || [pwdStr length] == 0) {
        [Tool showCustomHUD:@"请输入密码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.loginBtn.enabled = NO;
    NSString *regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_login];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:mobileStr forKey:@"tel"];
    [request setPostValue:pwdStr forKey:@"pwd"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestLogin:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"登录中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}
- (void)requestLogin:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!json) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:request.responseString
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    NSLog(request.responseString);
    User *user = [Tool readJsonStrToUser:request.responseString];
    int errorCode = [user.status intValue];
    NSString *errorMessage = user.info;
    switch (errorCode) {
        case 1:
        {
            //设置登录并保存用户信息
            UserModel *userModel = [UserModel Instance];
            [userModel saveIsLogin:YES];
            [userModel saveAccount:self.mobileTf.text andPwd:self.pwdTf.text];
            [userModel saveValue:user.id ForKey:@"id"];
            [userModel saveValue:user.cid ForKey:@"cid"];
            [userModel saveValue:user.build_id ForKey:@"build_id"];
            [userModel saveValue:user.house_number ForKey:@"house_number"];
            [userModel saveValue:user.carport_number ForKey:@"carport_number"];
            [userModel saveValue:user.name ForKey:@"name"];
            [userModel saveValue:user.nickname ForKey:@"nickname"];
            [userModel saveValue:user.address ForKey:@"address"];
            [userModel saveValue:user.tel ForKey:@"tel"];
            [userModel saveValue:user.pwd ForKey:@"pwd"];
            [userModel saveValue:user.avatar ForKey:@"avatar"];
            [userModel saveValue:user.email ForKey:@"email"];
            [userModel saveValue:user.card_id ForKey:@"card_id"];
            [userModel saveValue:user.property ForKey:@"property"];
            [userModel saveValue:user.plate_number ForKey:@"plate_number"];
            [userModel saveValue:user.credits ForKey:@"credits"];
            [userModel saveValue:user.remark ForKey:@"remark"];
            [userModel saveValue:user.checkin ForKey:@"checkin"];
            [userModel saveValue:user.comm_name ForKey:@"comm_name"];
            [userModel saveValue:user.build_name ForKey:@"build_name"];
            
            NSArray *tags = [[NSArray alloc] initWithObjects:user.cid, [NSString stringWithFormat:@"userid%@", user.id], nil];
            [BPush setTags:tags];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"登录提醒"
                                                         message:errorMessage
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
            [av show];
            //通知刷新设置
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RefreshSetting object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
            self.loginBtn.enabled = YES;
        }
            break;
    }
    self.loginBtn.enabled = YES;
}

@end
