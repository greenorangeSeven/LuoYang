//
//  CBusinessPublishView.h
//  NanNIng
//
//  Created by mac on 14-9-12.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBusinessPublishView : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *describeField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *selectPhoneBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
- (IBAction)selectPhoneAction:(id)sender;
@end
