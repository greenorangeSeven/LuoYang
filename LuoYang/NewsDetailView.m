//
//  NewsDetailView.m
//  BeautyLife
//
//  Created by Seven on 14-8-15.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "NewsDetailView.h"

@interface NewsDetailView ()

@end

@implementation NewsDetailView
@synthesize news;
@synthesize webView;
@synthesize menuView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 58, 26)];
        [rBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"conv_order_share"] forState:UIControlStateNormal];
        UIBarButtonItem *btnShare = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnShare;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction:(id)sender
{
    NSDictionary *contentDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.news.title, @"title",
                                self.news.summary, @"summary",
                                nil, @"thumb",
                                nil];
    [Tool shareAction:sender andShowView:self.view andContent:contentDic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    if (self.catalog == 1) {
        self.webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height);
        self.menuView.hidden = YES;
        titleLabel.text = @"通知详情";
    }
    else if (self.catalog == 2)
    {
        titleLabel.text = @"活动详情";
    }
    [self.pointsBtn setTitle:[NSString stringWithFormat:@"点赞( %@ )", self.news.points] forState:UIControlStateNormal];
    
    NSString *detailUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_getnoticeinfo, appkey, news.id];
    NSURL *url = [ NSURL URLWithString : detailUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    // 如果请求成功，返回 Response
    NSString *response = [request responseString ];
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSString *content;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    if (json) {
        content = [json objectForKey:@"content"];
    }
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    
    NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_title'>%@</div>%@<div id='web_body'>%@</div></body>", HTML_Style, news.title, HTML_Splitline, content];
    NSString *result = [Tool getHTMLString:html];
    [self.webView loadHTMLString:result baseURL:nil];
    
    self.webView.opaque = YES;
    for (UIView *subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)subView).bounces = YES;
        }
    }
    
    self.view.backgroundColor = [Tool getBackgroundColor];
    //适配iOS7uinavigationbar遮挡的问题
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

- (IBAction)pointsAction:(id)sender {
    NSString *pointslUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&model=news&id=%@", api_base_url, api_points, appkey, self.news.id];
    NSURL *url = [ NSURL URLWithString : pointslUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    // 如果请求成功，返回 Response
    NSString *response = [request responseString ];
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSString *status = @"0";
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    if (json) {
        status = [json objectForKey:@"status"];
        if ([status isEqualToString:@"1"]) {
            [self.pointsBtn setTitle:[NSString stringWithFormat:@"点赞( %d )", [self.news.points intValue] + 1] forState:UIControlStateNormal];
            [self.pointsBtn setEnabled:NO];
        }
    }
}

- (IBAction)baoming:(id)sender {
    if ([UserModel Instance].isLogin == NO)
    {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    NSString *baominglUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&activities_id=%@&userid=%@", api_base_url, api_baoming, appkey, self.news.id, [[UserModel Instance] getUserValueForKey:@"id"]];
    NSURL *url = [ NSURL URLWithString : baominglUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    // 如果请求成功，返回 Response
    NSString *response = [request responseString ];
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSString *status = @"0";
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    if (json) {
        status = [json objectForKey:@"status"];
        if ([status intValue] == 1) {
            [Tool showCustomHUD:@"报名成功" andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];
            [self.baomingBtn setEnabled:NO];
        }
        else
        {
            [Tool showCustomHUD:[json objectForKey:@"info"] andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
            [self.baomingBtn setEnabled:NO];
        }
    }
}

- (IBAction)telAction:(id)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", servicephone]];
    if (!phoneCallWebView) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

@end
