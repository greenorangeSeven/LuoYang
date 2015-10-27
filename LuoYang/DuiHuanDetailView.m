//
//  DuiHuanDetailView.m
//  LuoYangSQ
//
//  Created by Seven on 15/9/2.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import "DuiHuanDetailView.h"
#import "DuiHuanBuyView.h"

@interface DuiHuanDetailView ()
{
    NSString *keys;
}

@end

@implementation DuiHuanDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"商品详情";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [Tool getColorForGreen];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    
    if ([self.goodDetail.keys isEqualToString:@"1"])
    {
        keys = @"1";
    }
    else
    {
        keys = @"0";
    }
    
    UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    [self.picIv sd_setImageWithURL:[NSURL URLWithString:self.goodDetail.thumb] placeholderImage:[UIImage imageNamed:@"loadpic2"]];
    
    if ([self.goodDetail.keys isEqualToString:@"0"]) {
        [self.scheme1Btn setTitle:[NSString stringWithFormat:@"%@深盟券", self.goodDetail.duihuan_quan] forState:UIControlStateNormal];
        self.scheme2Btn.hidden = YES;
    }
    if ([self.goodDetail.keys isEqualToString:@"1"]) {
        [self.scheme1Btn setTitle:[NSString stringWithFormat:@"%@深盟券+%@现金", self.goodDetail.duihuan_quan02, self.goodDetail.duihuan_xianjin] forState:UIControlStateNormal];
        self.scheme2Btn.hidden = YES;
    }
    if ([self.goodDetail.keys isEqualToString:@"2"]) {
        [self.scheme1Btn setTitle:[NSString stringWithFormat:@"%@深盟券", self.goodDetail.duihuan_quan] forState:UIControlStateNormal];
        [self.scheme2Btn setTitle:[NSString stringWithFormat:@"%@深盟券+%@现金", self.goodDetail.duihuan_quan02, self.goodDetail.duihuan_xianjin] forState:UIControlStateNormal];
    }
    
    self.titleLb.text = self.goodDetail.title;
    
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    self.webView.delegate = self;
    NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_summary'>%@</div><div id='web_column'>%@</div><div id='web_body'>%@</div></body>", HTML_Style, self.goodDetail.summary, @"商品详情", self.goodDetail.content];
    NSString *result = [Tool getHTMLString:html];
    [self.webView loadHTMLString:result baseURL:nil];
    
    [self initGoodsAttrsNew];
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initGoodsAttrsNew
{
    attrsKeyArray = [[NSMutableArray alloc] init];
    attrsValArray = [[NSMutableArray alloc] init];
    int currentY = 5;
    if (self.goodDetail.attrsArray != nil && [self.goodDetail.attrsArray count] > 0) {
        for (int i = 0; i < [self.goodDetail.attrsArray count]; i++) {
            self.attrs0View.hidden = NO;
            GoodsAttrs *attrs = [self.goodDetail.attrsArray objectAtIndex:i];
            
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

- (IBAction)scheme1Action:(id)sender {
    [self.scheme1Btn setImage:[UIImage imageNamed:@"cb_green_on.png"] forState:UIControlStateNormal];
    [self.scheme2Btn setImage:[UIImage imageNamed:@"cb_green_off.png"] forState:UIControlStateNormal];
    if ([self.goodDetail.keys isEqualToString:@"1"])
    {
        keys = @"1";
    }
    else
    {
        keys = @"0";
    }
}

- (IBAction)scheme2Action:(id)sender {
    [self.scheme1Btn setImage:[UIImage imageNamed:@"cb_green_off.png"] forState:UIControlStateNormal];
    [self.scheme2Btn setImage:[UIImage imageNamed:@"cb_green_on.png"] forState:UIControlStateNormal];
    keys = @"1";
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewP
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.webView stopLoading];
}

- (IBAction)buyAction:(id)sender
{
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    if([keys isEqualToString:@"0"])
    {
        [self jfdhAction];
    }
    else if([keys isEqualToString:@"1"])
    {
        [self jfxjAction];
    }
}
         
- (void)jfxjAction
{
    NSMutableString *attrsStr = [[NSMutableString alloc] init];

    for (int i = 0; i < [attrsKeyArray count]; i++) {
        [attrsStr appendString:[NSString stringWithFormat:@"%@:%@  ", [attrsKeyArray objectAtIndex:i], [attrsValArray objectAtIndex:i]]];
    }
    self.goodDetail.attrsStr = [NSString stringWithString:attrsStr];
    self.goodDetail.number = [NSNumber numberWithInt:1];
    
    DuiHuanBuyView *buyView = [[DuiHuanBuyView alloc] init];
    buyView.hidesBottomBarWhenPushed = YES;
    buyView.goods = self.goodDetail;
    buyView.amountStr = [NSString stringWithFormat:@"%.2f", [self.goodDetail.duihuan_xianjin floatValue]];
    [self.navigationController pushViewController:buyView animated:YES];
}

- (void)jfdhAction
{
    self.buyBtn.enabled = NO;
    UserModel *userModel = [UserModel Instance];
    NSString *regUrl = [NSString stringWithFormat:@"%@/duihuanXiaofei", api_base_url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:keys forKey:@"keys"];
    [request setPostValue:self.goodDetail.id forKey:@"goods_id"];
    [request setPostValue:[userModel getUserValueForKey:@"id"]forKey:@"customer_id"];
    [request setPostValue:self.goodDetail.duihuan_quan forKey:@"duihuan_quan"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestDuiHuan:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"兑换中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}

- (void)requestDuiHuan:(ASIHTTPRequest *)request
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
    NSLog(@"%@", request.responseString);
    int flag = [[json objectForKey:@"flag"] intValue];
    NSString *msg = [json objectForKey:@"msg"];
    if (flag == 0) {
        [Tool showCustomHUD:msg andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];
        [self performSelector:@selector(back) withObject:self afterDelay:1.2f];
    }
    else
    {
        [Tool showCustomHUD:msg andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        self.buyBtn.enabled = YES;
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

@end
