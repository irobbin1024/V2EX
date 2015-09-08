//
//  VETopicListController.m
//  V2EX
//
//  Created by 翁佳 on 15-9-1.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VETopicListController.h"
#import "VETopicTableViewCell.h"
#import "VETopicListOperator.h"
#import "UIAlertView+AFNetworking.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "VETopicTableViewController.h"

@interface VETopicListController ()

@property(nonatomic, strong) NSArray * topicList;
@end

@implementation VETopicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [VETopicListControllerUtil titleWithTopicListType:self.topicListType];
    
    if (self.topicListType == VETopicListTypeNodes) [self configBarButton];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VETopicTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:VETopicTableViewCellIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    self.tableView.rowHeight = 95.0f;
    
    [self reload:nil];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data

- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSURLSessionTask *task = [VETopicListOperator topicListWithType:self.topicListType Block:^(NSArray *topicList, NSError *error) {
        if (!error) {
            self.topicList = topicList;
            [self.tableView reloadData];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VETopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VETopicTableViewCellIdentifier forIndexPath:indexPath];
    
    [cell setupWithTopicModel:self.topicList[indexPath.row] isSimple:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:VETopicTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(VETopicTableViewCell * cell) {
        
        [cell setupWithTopicModel:self.topicList[indexPath.row] isSimple:YES];
    }];
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VETopicTableViewController * topicController = [[VETopicTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    topicController.topic = self.topicList[[self.tableView indexPathForSelectedRow].row];
    
    [self.navigationController pushViewController:topicController animated:YES];
}

#pragma mark - navigation bar item 

- (void)configBarButton {
    UIBarButtonItem *collectButtonItem = [[UIBarButtonItem alloc]
                              initWithTitle:@"收藏"
                              style:UIBarButtonItemStylePlain
                              target:self
                              action:@selector(collectionAction:)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItem = collectButtonItem;
}

#pragma mark - navigation bar ButtonItem  action
- (void)collectionAction:(id)sender {
    if (self.description && [self.delegate respondsToSelector:@selector(didClickCollectButtonWithName:)]) {
        [self.delegate didClickCollectButtonWithName:[VETopicListControllerUtil getInstanceNodeName]];
    }
}

@end

