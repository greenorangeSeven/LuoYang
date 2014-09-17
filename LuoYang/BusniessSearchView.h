//
//  BusniessSearchView.h
//  BeautyLife
//
//  Created by Seven on 14-8-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMapKit.h"
#import "Shop.h"
#import "EGOImageView.h"
#import "BusinessCell.h"
#import "ConvCell.h"
#import "BusinessDetailView.h"
#import "ConvOrderView.h"

@interface BusniessSearchView : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>
{
    NSMutableArray *shopData;
    MBProgressHUD *hud;
    NSString *searchKey;
    UILabel *noDataLabel;
}

@property BMKMapPoint myPoint;
@property (strong, nonatomic) NSString *viewType;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
