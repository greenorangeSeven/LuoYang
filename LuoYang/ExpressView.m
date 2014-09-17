//
//  ExpressView.m
//  BeautyLife
//
//  Created by Seven on 14-8-6.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ExpressView.h"

@interface ExpressView ()

@end

@implementation ExpressView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"预约寄件";
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
    //适配iOS7uinavigationbar遮挡问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [Tool roundView:self.bgView andCornerRadius:3.0];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height - 56);
    
    UserModel *usermodel = [UserModel Instance];
    self.nameLb.text = [usermodel getUserValueForKey:@"name"];
    EGOImageView *faceEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"userface.png"]];
    faceEGOImageView.imageURL = [NSURL URLWithString:[[UserModel Instance] getUserValueForKey:@"avatar"]];
    faceEGOImageView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    [self.faceIv addSubview:faceEGOImageView];
    self.userInfoLb.text = [NSString stringWithFormat:@"%@    %@", [usermodel getUserValueForKey:@"tel"], [usermodel getUserValueForKey:@"house_number"]];
    typeData = [[NSArray alloc] initWithObjects:@"包裹", @"文件", @"大件", nil];
    typeStr = [typeData objectAtIndex:0];
    [self.typeBtn setTitle:[typeData objectAtIndex:0] forState:UIControlStateNormal];
    
    self.inboxNumLb.text = [usermodel getUserValueForKey:@"inboxnum"];
    //邮件提醒事件注册
    UITapGestureRecognizer *inboxTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inboxClick)];
	[self.inboxBtnLb addGestureRecognizer:inboxTap];
}

- (void)inboxClick
{
    MyInBoxView *inboxView = [[MyInBoxView alloc] init];
    inboxView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inboxView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)mySendExpressAction:(id)sender {
    MySendExpressView *mySendExpress = [[MySendExpressView alloc] init];
    [self.navigationController pushViewController:mySendExpress animated:YES];
}

- (IBAction)sendAction:(id)sender {
    self.sendBtn.enabled = NO;
    NSString *descStr = self.descTv.text;
    if (descStr == nil || [descStr length] == 0) {
        [Tool showCustomHUD:@"请填写描述" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    UserModel *usermodel = [UserModel Instance];
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addmyoutbox];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:apiUrl]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:[usermodel getUserValueForKey:@"cid"] forKey:@"cid"];
    [request setPostValue:[usermodel getUserValueForKey:@"build_id"] forKey:@"build_id"];
    [request setPostValue:[usermodel getUserValueForKey:@"house_number"] forKey:@"house_number"];
    [request setPostValue:typeStr forKey:@"express_type"];
    [request setPostValue:descStr forKey:@"remark"];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"寄件预约" andView:self.view andHUD:request.hud];
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
            [Tool showCustomHUD:@"寄件预约成功" andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];
            self.descTv.text = @"";
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        }
            break;
    }
    self.sendBtn.enabled = YES;
}

- (IBAction)selectTypeAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"确  定", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    UIPickerView *catePicker = [[UIPickerView alloc] init];
    catePicker.delegate = self;
    catePicker.showsSelectionIndicator = YES;
    [actionSheet addSubview:catePicker];
}

- (IBAction)telAction:(id)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", servicephone]];
    if (!phoneCallWebView) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [typeData count];
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [typeData objectAtIndex:row];
}

-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    [self.typeBtn setTitle:[typeData objectAtIndex:row] forState:UIControlStateNormal];
}


@end
