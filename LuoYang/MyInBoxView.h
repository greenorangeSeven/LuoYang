//
//  MyInBoxView.h
//  BeautyLife
//
//  Created by Seven on 14-8-20.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddInboxView.h"
#import "MySendExpressCell.h"
#import "KuaiDi100View.h"

@interface MyInBoxView : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UserModel *usermodel;
    
    NSArray *myInExpressData;
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *inboxNumLb;
@property (weak, nonatomic) IBOutlet UITableView *myInboxTable;
- (IBAction)addMyInBoxAciton:(id)sender;

@end
