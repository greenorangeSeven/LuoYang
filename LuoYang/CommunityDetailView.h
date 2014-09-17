//
//  CommunityDetailView.h
//  NanNIng
//
//  Created by Seven on 14-9-9.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commercial.h"

@interface CommunityDetailView : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) Commercial *commer;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
