//
//  MerchantsView.m
//  LuoYang
//
//  Created by Seven on 14-10-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "MerchantsView.h"

@interface MerchantsView ()

@end

@implementation MerchantsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"招商";
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Tool roundTextView:self.remarkTv andBorderWidth:1 andCornerRadius:4.0];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAction:(id)sender {
    NSString *companyName = self.companyNameTf.text;
    NSString *companyProduct = self.companyProductTf.text;
    NSString *contacts = self.contactsTf.text;
    NSString *phone = self.phoneTf.text;
    NSString *remark = self.remarkTv.text;
    if (companyName == nil || [companyName length] == 0) {
        [Tool showCustomHUD:@"请填写公司名称" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (companyProduct == nil || [companyProduct length] == 0) {
        [Tool showCustomHUD:@"请填写开店产品" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (contacts == nil || [contacts length] == 0) {
        [Tool showCustomHUD:@"请填写联系人" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (phone == nil || [phone length] == 0) {
        [Tool showCustomHUD:@"请填写联系电话" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (remark == nil || [remark length] == 0) {
        [Tool showCustomHUD:@"请填写意向说明" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.submitBtn.enabled = NO;
    NSString *updateUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_supplier];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:companyName forKey:@"company_name"];
    [request setPostValue:companyProduct forKey:@"company_product"];
    [request setPostValue:contacts forKey:@"contacts"];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:remark forKey:@"remark"];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"报修提交" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}
- (void)requestSubmit:(ASIHTTPRequest *)request
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
            self.companyNameTf.text = @"";
            self.companyProductTf.text = @"";
            self.contactsTf.text = @"";
            self.phoneTf.text = @"";
            self.remarkTv.text = @"";
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];

        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        }
            break;
    }
    self.submitBtn.enabled = YES;
}
@end
