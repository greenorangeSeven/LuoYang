//
//  DuiHuanClassView.h
//  LuoYangSQ
//
//  Created by Seven on 15/9/2.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "BusinessCateCell.h"
#import "BusinessView.h"
#import "ADVDetailView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface DuiHuanClassView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SGFocusImageFrameDelegate>
{
    NSMutableArray *shopCateData;
    MBProgressHUD *hud;
    NSString *catid;
    
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *advIv;

@property (weak, nonatomic) IBOutlet UICollectionView *cateCollection;

@end
