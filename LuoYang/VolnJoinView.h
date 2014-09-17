//
//  VolnJoinView.h
//  NanNIng
//
//  Created by mac on 14-9-10.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolnJoinView : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *idField;
@property (weak, nonatomic) IBOutlet UITextView *joinField;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

- (IBAction)joinAction:(UIButton *)sender;

@end
