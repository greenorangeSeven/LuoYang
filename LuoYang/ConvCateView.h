//
//  ConvCateView.h
//  LuoYang
//
//  Created by Seven on 14-11-6.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "BusinessCateCell.h"
#import "TQImageCache.h"
#import "ConvView.h"
#import "ADVDetailView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface ConvCateView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,IconDownloaderDelegate,BMKLocationServiceDelegate, SGFocusImageFrameDelegate>
{
    NSMutableArray *shopCateData;
    MBProgressHUD *hud;
    NSString *catid;
    
    BMKMapPoint myPoint;
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