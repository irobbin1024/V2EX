//
//  VEMemberTableViewController.m
//  V2EX
//
//  Created by wengjia on 15/9/5.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VEMemberTableViewController.h"
#import "VEMemberOperator.h"
#import "UIAlertView+AFNetworking.h"
#import "UIRefreshControl+AFNetworking.h"
#import "VEMemberTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface VEMemberTableViewController () {
    NSDictionary *memberDictionaryValue;
    NSArray *memberTitleArray;
    NSArray *memberValueArray;
}

@end

@implementation VEMemberTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    
    memberTitleArray = @[@"头像", @"名字", @"v2ex主页", @"个人网站", @"Twitter", @"PSD ID",
                         @"GitHub", @"BTC Address", @"所在地", @"签名", @"个人简介"];
    
    
    memberValueArray = @[@"avatarLarge", @"userName", @"url", @"website", @"twitter", @"psn",
                         @"github", @"btc", @"location", @"tagline", @"bio"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VEMemberTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kVEMemberTableViewCellIdentifier];
    
    [self reload:nil];
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (memberDictionaryValue.count == 0) {
        return 0;
    } else {
        return memberTitleArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VEMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kVEMemberTableViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setupWithTitle:memberTitleArray[indexPath.row] Context:[memberDictionaryValue objectForKey:memberValueArray[indexPath.row]] IsShowImage:YES];
    } else {
        [cell setupWithTitle:memberTitleArray[indexPath.row] Context:[memberDictionaryValue objectForKey:memberValueArray[indexPath.row]] IsShowImage:NO];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:kVEMemberTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(VEMemberTableViewCell * cell) {
        
        if (indexPath.row == 0) {
            [cell setupWithTitle:memberTitleArray[indexPath.row] Context:[memberDictionaryValue objectForKey:memberValueArray[indexPath.row]] IsShowImage:YES];
        } else {
            [cell setupWithTitle:memberTitleArray[indexPath.row] Context:[memberDictionaryValue objectForKey:memberValueArray[indexPath.row]] IsShowImage:NO];
        }
    }];
    NSLog(@"%f", height);
    return height;
}

#pragma mark - Data 

- (void)reload:(__unused id)sender {
    NSURLSessionTask *task = [VEMemberOperator memberDetailWithMember:self.member Block:^(VEMemberModel *member, NSError *error) {
        if (!error) {
            memberDictionaryValue = member.dictionaryValue;
            [self.tableView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
    
}

@end
