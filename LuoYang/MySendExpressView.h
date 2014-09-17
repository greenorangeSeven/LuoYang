//
//  MySendExpressView.h
//  BeautyLife
//
//  Created by Seven on 14-8-6.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySendExpressCell.h"
#import "MyInBoxView.h"
#import "KuaiDi100View.h"

@interface MySendExpressView : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *myOutExpressData;
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UILabel *inboxNumLb;
@property (weak, nonatomic) IBOutlet UILabel *inboxBtnLb;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *myExpressTable;

@end
