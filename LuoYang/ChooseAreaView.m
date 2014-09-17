//
//  ChooseAreaView.m
//  BeautyLife
//
//  Created by Seven on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ChooseAreaView.h"

@interface ChooseAreaView ()

@end

@implementation ChooseAreaView
@synthesize communityLb;
@synthesize regionLb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"住址选择";
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UserModel *usermodel = [UserModel Instance];
    NSString *provinceStr = [usermodel getUserValueForKey:@"selectProvinceStr"];
    NSString *cityStr = [usermodel getUserValueForKey:@"selectCityStr"];
    NSString *regionStr = [usermodel getUserValueForKey:@"selectRegionStr"];
    NSString *communityStr = [usermodel getUserValueForKey:@"selectCommunityStr"];
    if (regionStr != nil && [regionStr length] > 0)
    {
        self.regionLb.text = [NSString stringWithFormat:@"%@%@%@", provinceStr, cityStr, regionStr];
        self.communityLb.text = communityStr;
    }
    
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

- (IBAction)selectHomeAddressForCityAction:(id)sender {
    SelectHomeAddressView *selectForCityView = [[SelectHomeAddressView alloc] init];
    selectForCityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectForCityView animated:YES];
}

- (IBAction)searchAddressAction:(id)sender {
    SearchAdderssView *searchView = [[SearchAdderssView alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

@end
