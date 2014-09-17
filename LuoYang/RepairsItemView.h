//
//  RepairsItemView.h
//  BeautyLife
//
//  Created by Seven on 14-8-16.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepairsItem.h"
#import "RepairsItemCell.h"

@interface RepairsItemView : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *repairsItemData;
}

@property (weak, nonatomic) RepairsList *repair;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *repairItemTable;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@end
