//
//  KuaiDi100View.m
//  BeautyLife
//
//  Created by Seven on 14-8-26.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "KuaiDi100View.h"

@interface KuaiDi100View ()

@end

@implementation KuaiDi100View

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
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    [self.webView sizeToFit];
    self.webView.delegate = self;
    NSString *urlStr = [[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@&callbackurl=back", self.expcom, self.expnum] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 浏览器链接处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString isEqualToString:@"http://m.kuaidi100.com/back"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

@end
