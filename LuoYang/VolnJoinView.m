//
//  VolnJoinView.m
//  NanNIng
//
//  Created by mac on 14-9-10.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "VolnJoinView.h"

@interface VolnJoinView ()

@end

@implementation VolnJoinView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"志愿者";
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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    [Tool roundTextView:self.joinField andBorderWidth:1 andCornerRadius:3.0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)joinAction:(UIButton *)sender
{
    NSString *nameStr = self.nameField.text;
    NSString *phoneStr = self.phoneField.text;
    NSString *idStr = self.idField.text;
    NSString *joinStr = self.joinField.text;
    
    if (nameStr == nil || [nameStr length] == 0)
    {
        [Tool showCustomHUD:@"请输入姓名" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    if (![phoneStr isValidPhoneNum])
    {
        [Tool showCustomHUD:@"手机号错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    if (![idStr isValidIdCardNum])
    {
        [Tool showCustomHUD:@"身份证错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (joinStr == nil || [joinStr length] == 0)
    {
        [Tool showCustomHUD:@"请输入加入原因" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }

    self.joinBtn.enabled = NO;
    NSString *regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_vol_baoming];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:nameStr forKey:@"name"];
    [request setPostValue:phoneStr forKey:@"tel"];
    [request setPostValue:idStr forKey:@"id_card"];
    [request setPostValue:joinStr forKey:@"cause"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestJoin:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"提交报名..." andView:self.view andHUD:request.hud];

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}
- (void)requestJoin:(ASIHTTPRequest *)request
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
            self.nameField.text = @"";
            self.phoneField.text = @"";
            self.idField.text = @"";
            self.joinField.text = @"";
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        }
            break;
    }
    self.joinBtn.enabled = YES;
}

@end
