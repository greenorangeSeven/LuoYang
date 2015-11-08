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
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface BusinessCateView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,IconDownloaderDelegate,BMKLocationServiceDelegate,SGFocusImageFrameDelegate>
{
    NSMutableArray *shopCateData;
    MBProgressHUD *hud;
    NSString *catid;
    
    BMKMapPoint myPoint;
    CLLocationCoordinate2D coord;
    BMKLocationService* _locService;
    
    TQImageCache * _iconCache;
    
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *advIv;

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property (weak, nonatomic) IBOutlet UICollectionView *cateCollection;


@end
