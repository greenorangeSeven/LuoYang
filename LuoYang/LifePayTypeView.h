//
//  LifePayTypeView.h
//  LuoYangSQ
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifePayTypeView : UIViewController

@property (weak, nonatomic) NSString *type;

@property (weak, nonatomic) IBOutlet UIButton *jigouNameBtn;

- (IBAction)wuyeGetAction:(id)sender;
- (IBAction)jigouGetAction:(id)sender;

@end
