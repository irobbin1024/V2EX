//
//  VELatestController.m
//  V2EX
//
//  Created by wengjia on 15/8/11.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VELatestController.h"
#import "VEStatusModel.h"
#import "UIAlertView+AFNetworking.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "VEWebViewController.h"
#import "VEStatusTableViewCell.h"

@interface VELatestController ()

@property(nonatomic, strong) NSArray * latests;

@end

@implementation VELatestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最新";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VEStatusTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:VEStatusTableViewCellIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.tableView.rowHeight = 95.0f;
    
    [self reload:nil];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    return [self.latests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VEStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VEStatusTableViewCellIdentifier forIndexPath:indexPath];
    
    [cell setupWithStatusModel:self.latests[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:VEStatusTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(VEStatusTableViewCell * cell) {
        
        [cell setupWithStatusModel:self.latests[indexPath.row]];
    }];
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VEWebViewController * webView = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"VEWebViewController"];
    VEStatusModel * selectedStatusModel = self.latests[[self.tableView indexPathForSelectedRow].row];
    webView.url = selectedStatusModel.url;
    webView.controllerTitle = selectedStatusModel.title;
    
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - Data

- (void)reload:(__unused id)sender {
    NSURLSessionTask *task = [VEStatusModel latestWithBlock:^(NSArray *lastests, NSError *error) {
        self.latests = lastests;
        [self.tableView reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}

@end
