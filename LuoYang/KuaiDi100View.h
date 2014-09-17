//
//  KuaiDi100View.h
//  BeautyLife
//
//  Created by Seven on 14-8-26.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KuaiDi100View : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) NSString *expcom;
@property (weak, nonatomic) NSString *expnum;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
