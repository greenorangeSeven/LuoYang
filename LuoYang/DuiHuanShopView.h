//
//  DuiHuanShopView.h
//  LuoYangSQ
//
//  Created by Seven on 15/9/2.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuiHuanShopView : UIViewController< EGORefreshTableHeaderDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *goods;
    MBProgressHUD *hud;
    
    //下拉刷新
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL isLoading;
    BOOL isLoadOver;
}

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@property (weak, nonatomic) Shop *shop;
@property (weak, nonatomic) NSString *tjTitle;
@property (weak, nonatomic) NSString *tjCatId;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
