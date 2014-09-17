//
//  MyRepairsView.h
//  BeautyLife
//
//  Created by Seven on 14-8-4.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRepairsCell.h"
#import "RepairsList.h"
#import "AMRatingControl.h"
#import "RepairsItemView.h"
#import "RepairsRateView.h"

@interface MyRepairsView : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *myRepairsData;
}

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITableView *myRepairsTable;

@end
