//
//  CityPageView.m
//  NanNIng
//
//  Created by Seven on 14-8-9.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "CityPageView.h"
#import "CityView.h"
#import "VolnView.h"
#import "HelperView.h"

@interface CityPageView ()

@end

@implementation CityPageView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"智慧中原";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 31, 28)];
        [lBtn addTarget:self action:@selector(myAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"navi_my"] forState:UIControlStateNormal];
        UIBarButtonItem *btnMy = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnMy;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 31, 28)];
        [rBtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"navi_setting"] forState:UIControlStateNormal];
        UIBarButtonItem *btnSetting = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnSetting;
    }
    return self;
}

- (void)myAction
{
    
}

- (void)settingAction
{
    [Tool pushToSettingView:self.navigationController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    [Tool roundView:self.telBg andCornerRadius:3.0];
    [self initMainADV];
}

- (void)initMainADV
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //        [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&spaceid=6", api_base_url, api_getadv, appkey];
        NSString *cid = [[UserModel Instance] getUserValueForKey:@"cid"];
        if (cid != nil && [cid length] > 0) {
            [tempUrl appendString:[NSString stringWithFormat:@"&cid=%@", cid]];
        }
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           advDatas = [Tool readJsonStrToADV:operation.responseString];
                                           
                                           int length = [advDatas count];
                                           
                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                           if (length > 1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:length-1];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           for (int i = 0; i < length; i++)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:i];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                               
                                           }
                                           //添加第一张图 用于循环
                                           if (length >1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:0];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:adv.title image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 145) delegate:self imageItems:itemArray isAuto:YES];
                                           [bannerView scrollToIndex:0];
                                           [self.advIv addSubview:bannerView];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           //                                           if (hud != nil) {
                                           //                                               [hud hide:YES];
                                           //                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

//顶部图片滑动点击委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    if (adv)
    {
        if ([adv.redirecturl length] > 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:adv.redirecturl]];
        }
        else
        {
            ADVDetailView *advDetail = [[ADVDetailView alloc] init];
            advDetail.hidesBottomBarWhenPushed = YES;
            advDetail.adv = adv;
            [self.navigationController pushViewController:advDetail animated:YES];
        }
    }
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
    advIndex = index;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bannerView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    bannerView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickCity:(UIButton *)sender
{
    CityView *cityView = [[CityView alloc] init];
    cityView.typeStr = @"2";
    cityView.typeNameStr = @"城市文化";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}

- (IBAction)clickDongmeng:(UIButton *)sender
{
    CityView *cityView = [[CityView alloc] init];
    cityView.typeStr = @"1";
    cityView.typeNameStr = @"神都风采";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}

- (IBAction)clickZhiyuan:(UIButton *)sender
{
    VolnView *volnView = [[VolnView alloc] init];
    volnView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:volnView animated:YES];
}
- (IBAction)clickHelp:(UIButton *)sender
{
    
    HelperView *helperView = [[HelperView alloc] init];
    helperView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:helperView animated:YES];
}

- (IBAction)telAction:(id)sender{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", servicephone]];
    if (!phoneCallWebView) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

- (IBAction)sqzsAction:(id)sender {
    CityView *cityView = [[CityView alloc] init];
    cityView.typeStr = @"4";
    cityView.typeNameStr = @"社区招商";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}

- (IBAction)ptzsAction:(id)sender {
    CityView *cityView = [[CityView alloc] init];
    cityView.typeStr = @"5";
    cityView.typeNameStr = @"平台招商";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}

- (IBAction)zxlsAction:(id)sender {
    CityView *cityView = [[CityView alloc] init];
    cityView.typeStr = @"6";
    cityView.typeNameStr = @"为聚英台";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}

- (IBAction)fwdjAction:(id)sender {
    CityView *cityView = [[CityView alloc] init];
    cityView.typeStr = @"7";
    cityView.typeNameStr = @"服务到家";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}

- (IBAction)mlhnAction:(id)sender {
    CityView *cityView = [[CityView alloc] init];
    cityView.typeStr = @"8";
    cityView.typeNameStr = @"魅力中原";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}

- (IBAction)mqhjjAction:(id)sender {
    CityView *cityView = [[CityView alloc] init];
    cityView.typeStr = @"9";
    cityView.typeNameStr = @"母亲河基金";
    cityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityView animated:YES];
}

@end
