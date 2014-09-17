//
//  AddInboxView.m
//  BeautyLife
//
//  Created by Seven on 14-8-20.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "AddInboxView.h"

@interface AddInboxView ()

@end

@implementation AddInboxView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"我的快递";
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
    [Tool roundView:self.bgView andCornerRadius:3.0];
    [Tool roundView:self.telBg andCornerRadius:3.0];
    
    typeData = [[NSArray alloc] initWithObjects:@"包裹", @"文件", @"大件", nil];
    typeStr = [typeData objectAtIndex:0];
    [self.expTypeBtn setTitle:[typeData objectAtIndex:0] forState:UIControlStateNormal];
    
    expComData = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ExpressCompany.plist" ofType:nil]];
    NSDictionary *expCom = [expComData objectAtIndex:0];
    expComName = [expCom valueForKey:@"name"];
    expComCode = [expCom valueForKey:@"code"];
    [self.expComBtn setTitle:[expCom valueForKey:@"name"] forState:UIControlStateNormal];
    
    //适配iOS7uinavigationbar遮挡问题
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

- (IBAction)expComAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"确  定", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    UIPickerView *comPicker = [[UIPickerView alloc] init];
    comPicker.tag = 0;
    comPicker.delegate = self;
    comPicker.showsSelectionIndicator = YES;
    [actionSheet addSubview:comPicker];
}

- (IBAction)expTypeAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"确  定", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    UIPickerView *typePicker = [[UIPickerView alloc] init];
    typePicker.tag = 1;
    typePicker.delegate = self;
    typePicker.showsSelectionIndicator = YES;
    [actionSheet addSubview:typePicker];
}

- (IBAction)addAction:(id)sender {
    NSString *expNumStr = self.expNumLb.text;
    if (expNumStr == nil || [expNumStr length] == 0) {
        [Tool showCustomHUD:@"请填写快递单号" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.addBtn.enabled = NO;
    UserModel *usermodel = [UserModel Instance];
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addmyinbox];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:apiUrl]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:[usermodel getUserValueForKey:@"cid"] forKey:@"cid"];
    [request setPostValue:[usermodel getUserValueForKey:@"build_id"] forKey:@"build_id"];
    [request setPostValue:[usermodel getUserValueForKey:@"house_number"] forKey:@"house_number"];
    [request setPostValue:expComName forKey:@"express_company"];
    [request setPostValue:expNumStr forKey:@"express_number"];
    [request setPostValue:typeStr forKey:@"express_type"];
    [request setPostValue:@"" forKey:@"remark"];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{

}
- (void)requestSubmit:(ASIHTTPRequest *)request
{
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
            [Tool showCustomHUD:@"添加成功" andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];
            self.expNumLb.text = @"";
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        }
            break;
    }
    self.addBtn.enabled = YES;
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        return [expComData count];
    }
    else if (pickerView.tag == 1) {
        return [typeData count];
    }
    else
    {
        return 0;
    }
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        NSDictionary *expCom = [expComData objectAtIndex:row];
        return [expCom valueForKey:@"name"];
    }
    else if (pickerView.tag == 1) {
        return [typeData objectAtIndex:row];
    }
    else
    {
        return nil;
    }
}

-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    if (pickerView.tag == 0) {
        NSDictionary *expCom = [expComData objectAtIndex:row];
        expComName = [expCom valueForKey:@"name"];
        expComCode = [expCom valueForKey:@"code"];
        [self.expComBtn setTitle:[expCom valueForKey:@"name"] forState:UIControlStateNormal];
    }
    else if (pickerView.tag == 1) {
        [self.expTypeBtn setTitle:[typeData objectAtIndex:row] forState:UIControlStateNormal];
    }
    
}
@end
