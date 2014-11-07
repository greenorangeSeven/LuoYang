//
//  RechargeView.h
//  BeautyLife
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeDetailView.h"
#import "TQImageCache.h"
#import "RechargeCell.h"
#import "OnlineLink.h"

@interface RechargeView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, IconDownloaderDelegate>
{
    NSMutableArray *links;
    TQImageCache * _iconCache;
}

@property (weak, nonatomic) IBOutlet UILabel *bgLb;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
- (void)startIconDownload:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath;

@end
