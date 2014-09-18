//
//  ChangPWDView.m
//  BeautyLife
//
//  Created by Seven on 14-9-16.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ChangPWDView.h"

@interface ChangPWDView ()

@end

@implementation ChangPWDView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"修改密码";
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
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePwdAction:(id)sender {
    NSString *oldPwdStr = self.oldPwdTf.text;
    NSString *pwdStr = self.PwdTf.text;
    NSString *pwdAgainStr = self.pwdAgainTf.text;
    
    if (oldPwdStr == nil || [oldPwdStr length] == 0) {
        [Tool showCustomHUD:@"请输入原始密码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (pwdStr == nil || [pwdStr length] == 0) {
        [Tool showCustomHUD:@"请输入新密码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (![pwdStr isEqualToString:pwdAgainStr]) {
        [Tool showCustomHUD:@"密码确认不一致" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        self.pwdAgainTf.text = @"";
        return;
    }
    [self.oldPwdTf resignFirstResponder];
    [self.PwdTf resignFirstResponder];
    [self.pwdAgainTf resignFirstResponder];
    self.changePwdBtn.enabled = NO;
    NSString *changeUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_changepwd];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:changeUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:[[UserModel Instance] getUserValueForKey:@"tel"] forKey:@"userid"];
    [request setPostValue:oldPwdStr forKey:@"oldpwd"];
    [request setPostValue:pwdStr forKey:@"newpwd"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestChange:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在提交" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}
- (void)requestChange:(ASIHTTPRequest *)request
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
    User *user = [Tool readJsonStrToUser:request.responseString];
    int errorCode = [user.status intValue];
    NSString *errorMessage = user.info;
    switch (errorCode) {
        case 1:
        {
            self.oldPwdTf.text = @"";
            self.PwdTf.text = @"";
            self.pwdAgainTf.text = @"";
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];
            
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:@"原始密码错误！" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        }
            break;
    }
    self.changePwdBtn.enabled = YES;
}

@end
