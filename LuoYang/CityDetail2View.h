//
//  CityDetail2View.h
//  LuoYang
//
//  Created by Seven on 14-10-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityDetail2View : UIViewController

@property (weak, nonatomic) Citys *art;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)submitAction:(id)sender;

@end
