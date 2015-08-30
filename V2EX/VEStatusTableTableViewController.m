//
//  VEStatusTableTableViewController.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VEStatusTableTableViewController.h"
#import "UIWebView+Single.h"
#import "VEReplieTableViewCell.h"
#import "VETopicContentTableViewCell.h"
#import "VETopicTableViewCell.h"
#import "MBProgressHUD.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "VEReplieOperator.h"
#import "UIAlertView+AFNetworking.h"
#import "UIRefreshControl+AFNetworking.h"

@interface VEStatusTableTableViewController ()

@property (nonatomic, strong) NSMutableArray * repliesList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation VEStatusTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"话题";
    self.page = 1;
    self.pageSize = 20;
    self.repliesList = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWebViewContentSizeSuccessNitification:) name:kGetWebViewContentSizeSuccessNitification object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VEReplieTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kVEReplieTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"VETopicContentTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kVETopicContentTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"VETopicTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:VETopicTableViewCellIdentifier];
    
    __weak VEStatusTableTableViewController * weakSelf = self;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadRepliesWithPage:weakSelf.page];
    }];
    
    [self.tableView triggerInfiniteScrolling];
    self.tableView.fd_debugLogEnabled = YES;
    
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - Data

- (void)loadRepliesWithPage:(NSInteger)page {
    
    NSURLSessionTask *task = [VEReplieOperator repliesWithPage:page pageSize:self.pageSize topicID:self.topic.topicID block:^(NSArray *replies, NSError *error) {
        [self.tableView.infiniteScrollingView stopAnimating];
        if (!error) {
            self.tableView.infiniteScrollingView.enabled = NO;
            if (replies.count > 0) {
                [self.repliesList addObjectsFromArray:replies];
                [self.tableView reloadData];
                self.page++;
            } else {
                self.tableView.infiniteScrollingView.enabled = NO;
            }
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
//    [self.refreshControl setRefreshingWithStateOfTask:task];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.repliesList.count > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 2;
    } else if (section == 1) {
        return self.repliesList.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = nil;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            VETopicTableViewCell * topicCell = [tableView dequeueReusableCellWithIdentifier:VETopicTableViewCellIdentifier forIndexPath:indexPath];
            [topicCell setupWithTopicModel:self.topic isSimple:NO];
            cell = topicCell;
        } else if (indexPath.row == 1) {
            VETopicContentTableViewCell * topicContentCell = [tableView dequeueReusableCellWithIdentifier:kVETopicContentTableViewCellIdentifier forIndexPath:indexPath];
            [topicContentCell setupWithTopic:self.topic];
            cell = topicContentCell;
        }
    } else if (indexPath.section == 1) {
        VEReplieTableViewCell * topicReplieCell = [tableView dequeueReusableCellWithIdentifier:kVEReplieTableViewCellIdentifier forIndexPath:indexPath];
        
        [topicReplieCell setupWithReplie:self.repliesList[indexPath.row]];
        cell = topicReplieCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 46;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            height = [tableView fd_heightForCellWithIdentifier:VETopicTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(VETopicTableViewCell * cell) {
                
                [cell setupWithTopicModel:self.topic isSimple:YES];
            }];
        } else if (indexPath.row == 1) {
            height = [UIWebView heightFromCacheWithTopicID:self.topic.topicID width:[UIScreen mainScreen].bounds.size.width];
            
            if (height > 0) {
                height += 30;
            }
        }
    } else if (indexPath.section == 1) {
        height = [tableView fd_heightForCellWithIdentifier:kVEReplieTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(VEReplieTableViewCell * cell) {
            
            [cell setupWithReplie:self.repliesList[indexPath.row]];
        }];
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"评论";
    }
    return nil;
}


#pragma mark - Notification

- (void)getWebViewContentSizeSuccessNitification:(NSNotification *)notification {
    [self.tableView reloadData];
}

@end
