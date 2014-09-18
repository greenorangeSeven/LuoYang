//
//  SettingView.h
//  oschina
//
//  Created by wangjun on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"
#import "UserModel.h"
#import "RegisterView.h"
#import "UserInfoView.h"
#import "ChooseAreaView.h"
#import "LoginView.h"
#import "ShoppingCartView.h"
#import "FeeHistoryView.h"
#import "ExpressView.h"
#import "MyOrderView.h"
#import "ChangPWDView.h"

@interface SettingView : UIViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
    UIWebView *phoneCallWebView;
    NSArray * settings;
    NSMutableDictionary * settingsInSection;
}

@property (strong, nonatomic) NSString *typeView;
@property (strong, nonatomic) IBOutlet UITableView *tableSettings;
@property (retain,nonatomic) NSArray * settings;
@property (retain,nonatomic) NSMutableDictionary * settingsInSection;

@end
