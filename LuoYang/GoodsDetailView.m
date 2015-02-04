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
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [rBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"head_shopcar"] forState:UIControlStateNormal];
        UIBarButtonItem *btnShopCar = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnShopCar;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction:(id)sender
{
    ShoppingCartView *shopCarPage = [[ShoppingCartView alloc] init];
    shopCarPage.type = @"detail";
    [self.navigationController pushViewController:shopCarPage animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    NSString *detailUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_goodsinfo, appkey, self.goodId];
    NSURL *url = [ NSURL URLWithString : detailUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    goodDetail = [Tool readJsonStrToGoodsInfo:[request responseString]];
    
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loadingpic4.png"]];
    imageView.imageURL = [NSURL URLWithString:goodDetail.thumb];
    imageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 213.0f);
    [self.picIv addSubview:imageView];
    
    self.numberTf.text = @"1";
    self.priceLb.text = [NSString stringWithFormat:@"￥%@", goodDetail.price];
    self.titleLb.text = goodDetail.title;
    self.stocksLb.text = [NSString stringWithFormat:@"库存:%@", goodDetail.stocks];
    
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    self.webView.delegate = self;
    NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_summary'>%@</div><div id='web_column'>%@</div><div id='web_body'>%@</div></body>", HTML_Style, goodDetail.summary, @"商品详情", goodDetail.content];
    NSString *result = [Tool getHTMLString:html];
    [self.webView loadHTMLString:result baseURL:nil];
    
    [self initGoodsAttrsNew];
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (hud != nil) {
        [hud hide:YES];
    }
}

- (void)getDetail
{
    NSString *detailUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_goodsinfo, appkey, self.goodId];
    NSURL *url = [ NSURL URLWithString : detailUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    goodDetail = [Tool readJsonStrToGoodsInfo:[request responseString]];
    self.stocksLb.text = [NSString stringWithFormat:@"库存:%@", goodDetail.stocks];
}

- (void)initGoodsAttrsNew
{
    attrsKeyArray = [[NSMutableArray alloc] init];
    attrsValArray = [[NSMutableArray alloc] init];
    int currentY = 5;
    if (goodDetail.attrsArray != nil && [goodDetail.attrsArray count] > 0) {
        for (int i = 0; i < [goodDetail.attrsArray count]; i++) {
            self.attrs0View.hidden = NO;
            GoodsAttrs *attrs = [goodDetail.attrsArray objectAtIndex:i];
            
            //属性标题
            UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, currentY, 180, 20)];
            keyLabel.backgroundColor = [UIColor clearColor];
            keyLabel.font = [UIFont boldSystemFontOfSize:14.0];
            keyLabel.textColor = [UIColor blackColor];
            keyLabel.text = attrs.name;
            [self.attrs0View addSubview:keyLabel];
            [attrsKeyArray addObject:attrs.name];
            
            currentY = currentY + 15;
            
            UIView *attrValView = [[UIView alloc] initWithFrame:CGRectMake(5, currentY, 310, 20)];
            attrValView.tag = i;
            [self.attrs0View addSubview:attrValView];
            
            int attrValViewY = 0;
            for (int l = 0; l < [attrs.val count]; l++) {
                NSString *attrVal = (NSString *)[attrs.val objectAtIndex:l];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(10 + l % 3 * 100 , 10 + l / 3 * 32, 90, 22);
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitle:attrVal forState:UIControlStateNormal];
                if (l == 0) {
                    [button setBackgroundImage:[UIImage imageNamed:@"attrs_g"] forState:UIControlStateNormal];
                    [attrsValArray addObject:attrVal];
                }
                else
                {
                    [button setBackgroundImage:[UIImage imageNamed:@"attrs_w"] forState:UIControlStateNormal];
                }
                
                button.tag = l;
                [button addTarget:self action:@selector(attrs0SelectAction:) forControlEvents:UIControlEventTouchUpInside];
                [attrValView addSubview:button];
                attrValViewY = button.frame.origin.y;
            }
            attrValView.frame = CGRectMake(attrValView.frame.origin.x, attrValView.frame.origin.y, attrValView.frame.size.width, attrValViewY + 22 + 5);
            currentY = currentY + attrValViewY + 22 + 5;
        }
        self.attrs0View.frame = CGRectMake(self.attrs0View.frame.origin.x, self.attrs0View.frame.origin.y, self.attrs0View.frame.size.width, currentY + 10);
        self.scrollView.contentSize = CGSizeMake(320, self.attrs0View.frame.origin.y + self.attrs0View.frame.size.height);
        
    }

}

- (void)attrs0SelectAction:(id)sender
{
    UIButton *selectBtn = (UIButton *)sender;
    
    UIView *parentView = [selectBtn superview];
    int viewIndex = parentView.tag;
    
    NSArray * btnArray = [parentView subviews];
    for (int i = 0; i < [btnArray count]; i++) {
        
        UIButton *btn = (UIButton *)[btnArray objectAtIndex:i];
        if (selectBtn.tag == i) {
            [btn setBackgroundImage:[UIImage imageNamed:@"attrs_g"] forState:UIControlStateNormal];
            [attrsValArray replaceObjectAtIndex:viewIndex withObject:btn.titleLabel.text];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"attrs_w"] forState:UIControlStateNormal];
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewP
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.webView stopLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDetail];
//    if ([goodDetail.stocks intValue] <= 0) {
//        self.buyBtn.enabled = NO;
//        self.toShoppingCarBtn.enabled = NO;
//    }
//    else
//    {
//        self.buyBtn.enabled = YES;
//        self.toShoppingCarBtn.enabled = YES;
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}

- (IBAction)toShoppingCartAction:(id)sender {
    if ( [goodDetail.stocks intValue] - [self.numberTf.text intValue] < 0) {
        [Tool showCustomHUD:@"所购商品缺货" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:3];
        return;
    }
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
    
    NSMutableString *attrsStr = [[NSMutableString alloc] init];

    for (int i = 0; i < [attrsKeyArray count]; i++) {
        [attrsStr appendString:[NSString stringWithFormat:@"%@:%@  ", [attrsKeyArray objectAtIndex:i], [attrsValArray objectAtIndex:i]]];
    }
    goodDetail.attrsStr = [NSString stringWithString:attrsStr];
    
    BOOL addGood;
    FMResultSet* resultSet=[database executeQuery:@"select * from shoppingcart where goodid = ? and user_id = ? and attrs = ?", goodDetail.id, [[UserModel Instance] getUserValueForKey:@"id"], attrsStr];
    if ([resultSet next]) {
        addGood = [database executeUpdate:@"update shoppingcart set number = number + ? where id= ?" , [NSNumber numberWithInt:[self.numberTf.text intValue]], [resultSet stringForColumn:@"id"]];
    }
    else
    {
        addGood = [database executeUpdate:@"insert into shoppingcart (goodid, title, attrs, thumb, price, store_name, business_id, number, user_id, ischeck) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", goodDetail.id, goodDetail.title, goodDetail.attrsStr, goodDetail.thumb, goodDetail.price, goodDetail.store_name, goodDetail.business_id, [NSNumber numberWithInt:[self.numberTf.text intValue]], [[UserModel Instance] getUserValueForKey:@"id"], @"0"];
    }
    if (addGood) {
        [Tool showCustomHUD:@"已添加至购物车" andView:self.view andImage:@"37x-Checkmark.png" andAfterDelay:3];
    }
    [database close];
}

- (IBAction)buyAction:(id)sender
{
    if ([goodDetail.stocks intValue] - [self.numberTf.text intValue] < 0) {
        [Tool showCustomHUD:@"所购商品缺货" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:3];
        return;
    }
    NSMutableString *attrsStr = [[NSMutableString alloc] init];
//    if (attrs0Str != nil && [attrs0Str length] > 0) {
//        [attrsStr appendString:[NSString stringWithFormat:@"%@:%@", self.attrs0KeyLb.text, attrs0Str]];
//    }
//    if (attrs1Str != nil && [attrs1Str length] > 0) {
//        [attrsStr appendString:[NSString stringWithFormat:@"  %@:%@", self.attrs1KeyLb.text, attrs1Str]];
//    }
    for (int i = 0; i < [attrsKeyArray count]; i++) {
        [attrsStr appendString:[NSString stringWithFormat:@"%@:%@  ", [attrsKeyArray objectAtIndex:i], [attrsValArray objectAtIndex:i]]];
    }
    goodDetail.attrsStr = [NSString stringWithString:attrsStr];
    goodDetail.number = [NSNumber numberWithInt:[self.numberTf.text intValue]];
    
    ShoppingBuyView *shoppingBuyView = [[ShoppingBuyView alloc] init];
    shoppingBuyView.hidesBottomBarWhenPushed = YES;
    shoppingBuyView.goods = goodDetail;
    shoppingBuyView.amountStr = [NSString stringWithFormat:@"%.2f", [goodDetail.price floatValue] * [goodDetail.number intValue]];
    [self.navigationController pushViewController:shoppingBuyView animated:YES];
}

- (IBAction)selectTabAction:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            self.baseInfoView.hidden = NO;
            self.webView.hidden = YES;
            break;
        case 1:
            self.baseInfoView.hidden = YES;
            self.webView.hidden = NO;
            break;
        default:
            break;
    }
}

- (IBAction)minusAction:(id)sender {
    int number = [self.numberTf.text intValue];
    if (number > 1) {
        number -= 1;
        self.numberTf.text = [NSString stringWithFormat:@"%d", number];
    }
}

- (IBAction)addAction:(id)sender {
    int number = [self.numberTf.text intValue];

        number += 1;
        self.numberTf.text = [NSString stringWithFormat:@"%d", number];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

@end
