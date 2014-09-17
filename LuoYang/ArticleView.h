//
//  ArticleView.h
//  NanNIng
//
//  Created by Seven on 14-9-3.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "Article.h"
#import "ArticleCell.h"
#import "ArticleDetailView.h"

@interface ArticleView : UIViewController<SGFocusImageFrameDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    NSMutableArray *advs;
    
    NSMutableArray *articles;
    SGFocusImageFrame *bannerView;
    int advIndex;
    
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UIImageView *topIV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
