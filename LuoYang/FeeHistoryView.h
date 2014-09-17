//
//  FeeHistoryView.h
//  BeautyLife
//
//  Created by mac on 14-8-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeeHistoryView : UIViewController

//是否显示停车费信息
@property bool isShowPark;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
