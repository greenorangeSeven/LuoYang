//
//  CouponDetailView.m
//  NewWorld
//
//  Created by Seven on 14-7-14.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "CouponDetailView.h"

@interface CouponDetailView ()

@end

@implementation CouponDetailView

@synthesize scrollView;
@synthesize picIv;
@synthesize webView;
@synthesize getBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"优惠券";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 25)];
        [rBtn addTarget:self action:@selector(telAction) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"top_tel"] forState:UIControlStateNormal];
        UIBarButtonItem *btnTel = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnTel;
    }
    return self;
}

- (void)telAction
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", couponDetail.tel]];
    if (!phoneCallWebView) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
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
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    NSString *detailUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_couponsinfo,  appkey, self.couponsId];
    NSURL *url = [ NSURL URLWithString : detailUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    couponDetail = [Tool readJsonStrToCouponDetail:[request responseString]];
    //图片加载
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loadingpic1.png"]];
    imageView.imageURL = [NSURL URLWithString:couponDetail.thumb];
    imageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 187.0f);
    [self.picIv addSubview:imageView];
    
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    self.webView.delegate = self;
    NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_summaryred'>%@</div><div id='web_body'>%@</div></body>", HTML_Style, couponDetail.summary, couponDetail.content];
    NSString *result = [Tool getHTMLString:html];
    [self.webView loadHTMLString:result baseURL:nil];
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewP
{
    if (hud != nil) {
        [hud hide:YES];
    }
    NSArray *arr = [webViewP subviews];
    UIScrollView *webViewScroll = [arr objectAtIndex:0];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, webViewP.frame.origin.y + [webViewScroll contentSize].height);
    [webViewP setFrame:CGRectMake(webViewP.frame.origin.x, webViewP.frame.origin.y, webViewP.frame.size.width, [webViewScroll contentSize].height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.webView stopLoading];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}

- (IBAction)getAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    NSString *getUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_getcoupons];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:getUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:couponDetail.id forKey:@"coupons_id"];
    [request setPostValue:[[UserModel Instance] getUserValueForKey:@"id"] forKey:@"userid"];
    NSLog([[UserModel Instance] getUserValueForKey:@"id"]);
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestGet:)];
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

- (void)requestGet:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    User *user = [Tool readJsonStrToUser:request.responseString];
    
    int errorCode = [user.status intValue];
    switch (errorCode) {
        case 1:
        {
            [self.getBtn setTitle:@"已领取" forState:UIControlStateNormal];
            self.getBtn.enabled = NO;
            [Tool showCustomHUD:user.info andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:1];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:user.info andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        }
            break;
    }
}

- (void)checkIsGot
{
    if ([[UserModel Instance] isLogin]) {
        NSString *detailUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&coupons_id=%@&userid=%@", api_base_url, api_couponsisget, appkey, self.couponsId, [[UserModel Instance] getUserValueForKey:@"id"]];
        NSURL *url = [ NSURL URLWithString : detailUrl];
        ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
        // 开始同步请求
        [request startSynchronous ];
        NSError *error = [request error ];
        assert (!error);
        NSString *value = (NSString *)[request responseString];
        if ([value isEqualToString:@"1"]) {
            [self.getBtn setTitle:@"已领取" forState:UIControlStateNormal];
            self.getBtn.enabled = NO;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkIsGot];
}

@end
