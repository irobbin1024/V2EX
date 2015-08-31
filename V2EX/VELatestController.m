//
//  VELatestController.m
//  V2EX
//
//  Created by wengjia on 15/8/11.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VELatestController.h"
#import "UIAlertView+AFNetworking.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "VEWebViewController.h"
#import "VETopicModel.h"
#import "VELatestOperator.h"
#import "VETopicTableViewCell.h"

@interface VELatestController ()

@property(nonatomic, strong) NSArray * latests;

@end

@implementation VELatestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最新";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VETopicTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:VETopicTableViewCellIdentifier];
    
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
    VETopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VETopicTableViewCellIdentifier forIndexPath:indexPath];
    
    [cell setupWithTopicModel:self.latests[indexPath.row] isSimple:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:VETopicTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(VETopicTableViewCell * cell) {
        
        [cell setupWithTopicModel:self.latests[indexPath.row] isSimple:YES];
    }];
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VEWebViewController * webViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"VEWebViewController"];
    VETopicModel * selectedStatusModel = self.latests[[self.tableView indexPathForSelectedRow].row];
    webViewController.url = selectedStatusModel.url;
    webViewController.controllerTitle = selectedStatusModel.title;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一页" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - Data

- (void)reload:(__unused id)sender {
    NSURLSessionTask *task = [VELatestOperator latestWithBlock:^(NSArray *lastests, NSError *error) {
        self.latests = lastests;
        [self.tableView reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}

@end
