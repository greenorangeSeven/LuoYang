//
//  RepairsFrameView.m
//  BeautyLife
//
//  Created by Seven on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "RepairsFrameView.h"

@interface RepairsFrameView ()

@end

@implementation RepairsFrameView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"物业报修";
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
    //下属控件初始化
    self.repairsView = [[RepairsFormView alloc] init];
    self.repairsView.parentView = self.view;
    self.myRepairsView = [[MyRepairsView alloc] init];
    self.myRepairsView.view.hidden = YES;
    [self addChildViewController:self.repairsView];
    [self addChildViewController:self.myRepairsView];
    [self.mainView addSubview:self.repairsView.view];
    [self.mainView addSubview:self.myRepairsView.view];
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (IBAction)repairsAction:(id)sender
{
    [self.repairsBtn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
    [self.myRepairsBtn setTitleColor:[UIColor scrollViewTexturedBackgroundColor] forState:UIControlStateNormal];
    self.repairsView.view.hidden = NO;
    self.myRepairsView.view.hidden = YES;
}

- (IBAction)myRepairsAction:(id)sender
{
    [self.repairsBtn setTitleColor:[UIColor scrollViewTexturedBackgroundColor] forState:UIControlStateNormal];
    [self.myRepairsBtn setTitleColor:[Tool getColorForGreen] forState:UIControlStateNormal];
    self.repairsView.view.hidden = YES;
    self.myRepairsView.view.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
