//
//  GoodsDetailView.m
//  BeautyLife
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "GoodsDetailView.h"
#import "ShoppingBuyView.h"

@interface GoodsDetailView ()

@end

@implementation GoodsDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"商品详情";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 27)];
        [rBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"head_share"] forState:UIControlStateNormal];
        UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnSearch;
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
                                self.good.summary, @"title",
                                self.good.summary, @"summary",
                                self.good.thumb, @"thumb",
                                nil];
    [Tool shareAction:sender andShowView:self.view andContent:contentDic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loadingpic4.png"]];
    imageView.imageURL = [NSURL URLWithString:self.good.thumb];
    imageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 213.0f);
    [self.picIv addSubview:imageView];
    
    self.priceLb.text = [NSString stringWithFormat:@"￥%@", self.good.price];
    self.titleLb.text = self.good.title;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    NSString *detailUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_goodsinfo, appkey, self.good.id];
    NSURL *url = [ NSURL URLWithString : detailUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    goodDetail = [Tool readJsonStrToGoodsInfo:[request responseString]];
    
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    self.webView.delegate = self;
    NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_summary'>%@</div><div id='web_column'>%@</div><div id='web_body'>%@</div></body>", HTML_Style, goodDetail.summary, @"商品详情", goodDetail.content];
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

- (IBAction)toShoppingCartAction:(id)sender {
    if ([UserModel Instance].isLogin == NO)
    {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
    if (![database open]) {
        NSLog(@"Open database failed");
        return;
    }
    if (![database tableExists:@"shoppingcart"]) {
        [database executeUpdate:createshoppingcart];
    }
    BOOL addGood;
    FMResultSet* resultSet=[database executeQuery:@"select * from shoppingcart where goodid = ? and user_id = ?", goodDetail.id, [[UserModel Instance] getUserValueForKey:@"id"]];
    if ([resultSet next]) {
        addGood = [database executeUpdate:@"update shoppingcart set number = number + 1 where id= ?", [resultSet stringForColumn:@"id"]];
    }
    else
    {
        addGood = [database executeUpdate:@"insert into shoppingcart (goodid, title, thumb, price, store_name, business_id, number, user_id) values (?, ?, ?, ?, ?, ?, ?, ?)", goodDetail.id, goodDetail.title, goodDetail.thumb, goodDetail.price, goodDetail.store_name, goodDetail.business_id, [NSNumber numberWithInt:1], [[UserModel Instance] getUserValueForKey:@"id"]];
    }
    if (addGood) {
        [Tool showCustomHUD:@"已添加至购物车" andView:self.view andImage:@"37x-Checkmark.png" andAfterDelay:3];
    }
    [database close];
}

- (IBAction)buyAction:(id)sender
{
    ShoppingBuyView *shoppingBuyView = [[ShoppingBuyView alloc] init];
    shoppingBuyView.hidesBottomBarWhenPushed = YES;
    shoppingBuyView.goods = goodDetail;
    [self.navigationController pushViewController:shoppingBuyView animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

@end
