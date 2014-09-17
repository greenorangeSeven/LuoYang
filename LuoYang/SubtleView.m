//
//  SubtleView.m
//  BeautyLife
//
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "SubtleView.h"
#import "SubtleCell.h"

@interface SubtleView () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation SubtleView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"精选特价";
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
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    [self initRecommend];
}

- (void)initRecommend
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_getrecommendgoods, appkey];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           goods = [Tool readJsonStrToGoodsArray:operation.responseString];
                                           int length = [goods count];
                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                           if (length > 1)
                                           {
                                               Goods *good = [goods objectAtIndex:length-1];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:good.thumb tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           for (int i = 0; i < length; i++)
                                           {
                                               Goods *good = [goods objectAtIndex:i];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:good.thumb tag:-1];
                                               [itemArray addObject:item];
                                               
                                           }
                                           //添加第一张图 用于循环
                                           if (length >1)
                                           {
                                               Goods *good = [goods objectAtIndex:0];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:good.thumb tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 246) delegate:self imageItems:itemArray isAuto:NO];
                                           [bannerView scrollToIndex:0];
                                           [self.recommendIv addSubview:bannerView];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
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
    Goods *good = (Goods *)[goods objectAtIndex:goodIndex];
    if (good) {
        GoodsDetailView *goodsDetail = [[GoodsDetailView alloc] init];
        goodsDetail.good = good;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
    goodIndex = index;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newProductAction:(id)sender {
    BusinessDetailView *businessDetailView = [[BusinessDetailView alloc] init];
    businessDetailView.tjTitle = @"新品首发";
    businessDetailView.tjCatId = @"2";
    businessDetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:businessDetailView animated:YES];
}

- (IBAction)saleProductAction:(id)sender {
    BusinessDetailView *businessDetailView = [[BusinessDetailView alloc] init];
    businessDetailView.tjTitle = @"每日最惠";
    businessDetailView.tjCatId = @"3";
    businessDetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:businessDetailView animated:YES];
}

- (IBAction)hotProductAction:(id)sender {
    BusinessDetailView *businessDetailView = [[BusinessDetailView alloc] init];
    businessDetailView.tjTitle = @"热门商品";
    businessDetailView.tjCatId = @"4";
    businessDetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:businessDetailView animated:YES];
}

- (IBAction)allProductAction:(id)sender {
    BusinessDetailView *businessDetailView = [[BusinessDetailView alloc] init];
    businessDetailView.tjTitle = @"特价超市区";
    businessDetailView.tjCatId = @"0";
    businessDetailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:businessDetailView animated:YES];
}

@end
