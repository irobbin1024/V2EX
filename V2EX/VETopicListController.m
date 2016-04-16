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
#import "MBProgressHUD.h"

@interface VETopicListController ()<MBProgressHUDDelegate>

@property(nonatomic, strong) NSArray * topicList;
@property(nonatomic, strong) UIBarButtonItem *collectButtonItem;
@property(nonatomic, strong) UIBarButtonItem *cancerCollectButtonItem;

@end

@implementation VETopicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [VETopicListControllerUtil titleWithTopicListType:self.topicListType];
    
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

- (void)dealloc {
    [self.refreshControl setRefreshingWithStateOfTask:nil];
}

#pragma mark - Data

- (void)reload:(__unused id)sender {
    
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

- (void)rightButtonItemStatusWithIsShowCollect:(BOOL)isShowCollect {
    if (self.collectButtonItem == nil) {
        self.collectButtonItem = [[UIBarButtonItem alloc]
                                  initWithTitle:@"收藏"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(collectionAction:)];
    }
    if (self.cancerCollectButtonItem == nil) {
        self.cancerCollectButtonItem = [[UIBarButtonItem alloc]
                                        initWithTitle:@"取消收藏"
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(cancerCollectionAction:)];
    }
    
    if (isShowCollect) {
        self.navigationItem.rightBarButtonItem = self.collectButtonItem;
    }else {
        self.navigationItem.rightBarButtonItem = self.cancerCollectButtonItem;
    }
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

#pragma mark - navigation bar ButtonItem  action
- (void)collectionAction:(id)sender {
    if (self.description && [self.delegate respondsToSelector:@selector(didClickCollectButtonWithName:)]) {
        VETopicListTipType result = [self.delegate didClickCollectButtonWithName:[VETopicListControllerUtil getInstanceNodeName]];
        switch (result) {
            case VETopicListTip_Success: {
//                [MobClick event:@"Collect"];
                self.navigationItem.rightBarButtonItem = self.cancerCollectButtonItem;
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.delegate = self;
                HUD.labelText = @"收藏成功";
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
                }
                break;
            case VETopicListTip_Failure: {
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.delegate = self;
                HUD.labelText = @"收藏失败";
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
                }
                break;
            default:
                break;
        }
    }
}

- (void)cancerCollectionAction:(id)sender {
    if (self.description && [self.delegate respondsToSelector:@selector(didClickCancerCollectButtonWithName:)]) {
        VETopicListTipType result = [self.delegate didClickCancerCollectButtonWithName:[VETopicListControllerUtil getInstanceNodeName]];
        switch (result) {
            case VETopicListTip_Success: {
//                [MobClick event:@"unCollect"];
                self.navigationItem.rightBarButtonItem = self.collectButtonItem;
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.delegate = self;
                HUD.labelText = @"已取消收藏";
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
            }
                break;
            case VETopicListTip_Failure: {
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.delegate = self;
                HUD.labelText = @"取消收藏失败";
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
            }
                break;
            default:
                break;
        }
    }
}
@end

