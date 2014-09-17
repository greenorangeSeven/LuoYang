//
//  RepairsRateView.m
//  BeautyLife
//
//  Created by Seven on 14-8-17.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "RepairsRateView.h"

@interface RepairsRateView ()

@end

@implementation RepairsRateView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"报修评价";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [Tool getColorForGreen];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 21)];
        [rBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setTitle:@"完成" forState:UIControlStateNormal];
        [rBtn setFont:[UIFont systemFontOfSize:16.0]];
        UIBarButtonItem *btnFinish = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnFinish;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitAction
{
    NSString *commentStr = self.commentTv.text;
    if (commentStr == nil || [commentStr length] == 0) {
        [Tool showCustomHUD:@"请填写评论" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    NSString *commentUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_commentbaoxiu];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:commentUrl]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:[[UserModel Instance] getUserValueForKey:@"id"] forKey:@"userid"];
    NSLog([[UserModel Instance] getUserValueForKey:@"id"]);
    NSLog(appkey);
    [request setPostValue:self.repair.order_no forKey:@"order_no"];
    NSLog(self.repair.order_no);
    [request setPostValue:commentStr forKey:@"comment"];
    [request setPostValue:rateValue forKey:@"rate"];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"评价提交" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}

- (void)requestSubmit:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(request.responseString);
    if (!json) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:request.responseString
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    User *user = [Tool readJsonStrToUser:request.responseString];
    int errorCode = [user.status intValue];
    NSString *errorMessage = user.info;
    switch (errorCode) {
        case 1:
        {
            [Tool showCustomHUD:@"评价成功" andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];
            self.commentTv.text = @"";
            //通知刷新我的保修单
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RefreshMyRepairs object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        }
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Tool roundView:self.bgView andCornerRadius:3.0];
    [Tool roundTextView:self.commentTv andBorderWidth:1 andCornerRadius:4.0];
    self.scollView.contentSize = CGSizeMake(self.scollView.bounds.size.width, self.view.frame.size.height);
    
    //星级评价
    AMRatingControl *gradeControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0)
                                                                   emptyColor:[UIColor colorWithRed:245.0/255 green:130.0/255 blue:33.0/255 alpha:1.0]
                                                                   solidColor:[UIColor colorWithRed:245.0/255 green:130.0/255 blue:33.0/255 alpha:1.0]
                                                                 andMaxRating:5  andStarSize:40 andStarWidthAndHeight:40];
    
    [gradeControl setRating:4];
    rateValue = @"4";
    [gradeControl addTarget:self action:@selector(updateEndRating:) forControlEvents:UIControlEventEditingDidEnd];
    [self.rateLb addSubview:gradeControl];
    self.orderNoLb.text = [NSString stringWithFormat:@"%@详情", self.repair.order_no];
    self.typeLb.text = self.repair.type_text;
    self.summaryTv.text = self.repair.summary;
    self.weixiuNameLb.text = self.repair.weixiu_name;
    
    EGOImageView *picEGOIV = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"repairspic.png"]];
    picEGOIV.imageURL = [NSURL URLWithString:self.repair.thumb];
    picEGOIV.frame = CGRectMake(0.0f, 0.0f, 60.0f, 51.0f);
    [self.picIv addSubview:picEGOIV];
    
    self.startLb.text = [Tool TimestampToDateStr:self.repair.accept_time andFormatterStr:@"YYYY年MM月dd日 HH:mm"];
    self.endLb.text = [Tool TimestampToDateStr:self.repair.weixiu_time andFormatterStr:@"YYYY年MM月dd日 HH:mm"];
    
    //适配iOS7  scrollView计算uinavigationbar高度的问题
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

- (void)updateEndRating:(id)sender
{
    NSLog(@"End Rating: %d", [(AMRatingControl *)sender rating]);
    rateValue = [NSString stringWithFormat:@"%d", [(AMRatingControl *)sender rating]];
//	[endLabel setText:[NSString stringWithFormat:@"%d", [(AMRatingControl *)sender rating]]];
}

@end
