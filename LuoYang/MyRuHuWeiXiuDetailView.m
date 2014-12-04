//
//  MyRuHuWeiXiuDetailView.m
//  LuoYang
//
//  Created by Seven on 14-11-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "MyRuHuWeiXiuDetailView.h"

@interface MyRuHuWeiXiuDetailView ()

@end

@implementation MyRuHuWeiXiuDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"入户维修详情";
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
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    
    [self loadData];
}

- (void)loadData
{
    NSString *pic = @"";
    if ([self.complain.thumb length] > 0) {
        pic = [NSString stringWithFormat:@"<div id='web_img'><img src='%@' width='200' hspace='35'/></div>", self.complain.thumb];
    }
    
    NSString *content = [NSString stringWithFormat:@"<span style='color:#249A08; '>维修内容：</span></br>%@</br></br>", self.complain.content];
    
    NSString *reply = @"";
    if ([self.complain.replys length] > 0) {
        reply = [NSString stringWithFormat:@"<hr style='height:0.5px; background-color:#0D6DA8; margin-bottom:5px'/><span style='color:#249A08; '>%@处理结果：</span></br>%@", self.complain.replytimeStr, self.complain.replys];
    }
    
    NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_title'>%@</div>%@%@</body><div id='web_body'>%@%@</div></body>", HTML_Style, self.complain.title, HTML_Splitline, pic,content,reply];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
