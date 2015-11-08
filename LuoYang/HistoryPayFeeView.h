//
//  HistoryPayFeeView.h
//  LuoYangSQ
//
//  Created by Seven on 15/10/28.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryPayFeeView : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *bills;
}

@property (weak, nonatomic) NSString *type;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
