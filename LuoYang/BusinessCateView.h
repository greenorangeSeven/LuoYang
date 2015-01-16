//
//  BusinessCateView.h
//  LuoYang
//
//  Created by Seven on 14-10-27.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "BusinessCateCell.h"
#import "TQImageCache.h"
#import "BusinessView.h"
#import "ADVDetailView.h"

@interface BusinessCateView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,IconDownloaderDelegate,BMKLocationServiceDelegate>
{
    NSMutableArray *shopCateData;
    MBProgressHUD *hud;
    NSString *catid;
    
    BMKMapPoint myPoint;
    CLLocationCoordinate2D coord;
    BMKLocationService* _locService;
    
    TQImageCache * _iconCache;
    
}

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property (weak, nonatomic) IBOutlet UICollectionView *cateCollection;


@end
