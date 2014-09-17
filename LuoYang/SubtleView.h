//
//  SubtleView.h
//  BeautyLife
//  精选特价
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessDetailView.h"

@interface SubtleView : UIViewController<SGFocusImageFrameDelegate>
{
    MBProgressHUD *hud;
    NSMutableArray *goods;
    SGFocusImageFrame *bannerView;
    int goodIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *recommendIv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)newProductAction:(id)sender;
- (IBAction)saleProductAction:(id)sender;
- (IBAction)hotProductAction:(id)sender;
- (IBAction)allProductAction:(id)sender;

@end
