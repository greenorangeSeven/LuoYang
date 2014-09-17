//
//  BBSReplyView.m
//  NanNIng
//
//  Created by Seven on 14-9-12.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "BBSReplyView.h"

@interface BBSReplyView ()

@end

@implementation BBSReplyView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Tool roundTextView:self.contentTV andBorderWidth:1 andCornerRadius:3.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
