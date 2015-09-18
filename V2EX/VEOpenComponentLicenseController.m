//
//  VEOpenComponentLicenseController.m
//  V2EX
//
//  Created by wengjia on 15/8/31.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VEOpenComponentLicenseController.h"
#import "MobClick.h"

@interface VEOpenComponentLicenseController ()
@property (weak, nonatomic) IBOutlet UITextView *lisenceTextView;

@end

@implementation VEOpenComponentLicenseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"checkout_License"];
    self.navigationItem.title = @"License";
    self.lisenceTextView.text = self.lisenceContext;
    self.lisenceTextView.editable = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.lisenceTextView scrollRangeToVisible:NSMakeRange(0, 1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
