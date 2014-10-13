//
//  VolnInfoView.h
//  NanNIng
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "TQImageCache.h"

@interface VolnInfoView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *volnArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
