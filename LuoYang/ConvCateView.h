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


@interface ConvCateView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,IconDownloaderDelegate,BMKLocationServiceDelegate>
{
    NSMutableArray *shopCateData;
    MBProgressHUD *hud;
    NSString *catid;
    
    BMKMapPoint myPoint;
    BMKLocationService* _locService;
    
    TQImageCache * _iconCache;
    
}

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property (weak, nonatomic) IBOutlet UICollectionView *cateCollection;


@end