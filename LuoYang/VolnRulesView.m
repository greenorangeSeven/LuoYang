//
//  VolnRulesView.m
//  LuoYang
//
//  Created by Seven on 14-10-13.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "VolnRulesView.h"

#define volnRules @"<p style=\"font-size:14px;font-family:'Heiti SC Light';\">一、认同洛阳志愿者的服务理念、基本原则以及运作模式；</p><p style=\"font-size:14px;font-family:'Heiti SC Light';\">二、与其他志愿者及时沟通，互相合作，依照洛阳志愿者的要求，尽力完成洛阳志愿者的义务工作；</p><p style=\"font-size:14px;font-family:'Heiti SC Light';\">三、坦诚提出对洛阳志愿者的意见或建议，积极参与志愿者的建设，竭力维护志愿者的名誉；</p><p style=\"font-size:14px;font-family:'Heiti SC Light';\">四、提供志愿者所要求的个人资料，经本人同意，授权洛阳志愿者在必要时公开部分真实资料以及联络方式；</p><p style=\"font-size:14px;font-family:'Heiti SC Light';\">五、接受志愿者委托从事助学有关活动时，所需费用个人自理；活动期间发生的任何纠纷与意外事故均自行负责；</p><p style=\"font-size:14px;font-family:'Heiti SC Light';\">六、不从事任何违背志愿者原则和理念、可能会对造成危害的活动；</p><p style=\"font-size:14px;font-family:'Heiti SC Light';\">七、不参与任何可能对志愿者造成危害的组织，更不得以志愿者的名义进行任何违法犯罪活动；</p><p style=\"font-size:14px;font-family:'Heiti SC Light';\">八、未经洛阳志愿者授权，志愿者不得从事以下活动：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1)、利用志愿者名义进行任何商业活动；<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2)、接受任何来自媒体、官方和其他不属于希望之光范围的邀请、访谈或者采访；泄漏未经洛阳志愿者确认的任何活动或内容；<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3)、以任何名义直接或者间接接受任何给予志愿者的金钱上的资助；<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4)、以任何名义直接或者间接接受任何给予受益人的金钱或者物质上的资助；<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5)、宣称代表志愿者，以任何名义展开和志愿者相关的工作；<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6)、泄露其在从事志愿者工作过程中取得的任何资料，包括其他志愿者的个人资料，及资助个案相关资料和其他资料；&nbsp;</p><p style=\"font-size:14px;font-family:'Heiti SC Light';\">九、志愿者与志愿者的任何纠纷仅限在内部解决，不得泄露于除洛阳志愿者外的其它任何个人或组织；</p><p style=\"font-size:14px;font-family:'Heiti SC Light';\">十、洛阳志愿者保留在特殊情况下即时终止志愿者身份的权力。</p>"

@interface VolnRulesView ()

@end

@implementation VolnRulesView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"志愿者守则";
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
    
    self.view.backgroundColor = [Tool getBackgroundColor];
    
    [self.webView loadHTMLString:volnRules baseURL:nil];
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

@end
