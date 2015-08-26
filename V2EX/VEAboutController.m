//
//  VEAboutController.m
//  V2EX
//
//  Created by 翁佳 on 15-8-17.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VEAboutController.h"
#import "VESiteModel.h"
#import "UIAlertView+AFNetworking.h"

@interface VEAboutController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *decriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *domainLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicmaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;

@end

@implementation VEAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self reload:nil];
}

- (void)reload:(__unused id)sender {
    NSURLSessionDataTask *task;
    task = [VESiteInfoModel siteInfoWithBlock:^(id siteInfo, NSError *error) {
    VESiteInfoModel *siteInfoMdoel = siteInfo;
    self.titleLabel.text = siteInfoMdoel.title == nil ? self.titleLabel.text : siteInfoMdoel.title;
    self.decriptionLabel.text = siteInfoMdoel.describe == nil ? self.decriptionLabel.text : siteInfoMdoel.describe;
    self.domainLabel.text = siteInfoMdoel.domain == nil ? self.domainLabel.text : siteInfoMdoel.domain;
    }];
    
    task = [VESiteStatsModel siteStatsWithBlock:^(id siteStats, NSError *error) {
    VESiteStatsModel *siteStatsModel = siteStats;
        self.topicmaxLabel.text = siteStatsModel.topic_max == nil ? @"未知" : siteStatsModel.topic_max;
        self.memberLabel.text = siteStatsModel.member_max == nil ? @"未知" : siteStatsModel.member_max;
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

@end
