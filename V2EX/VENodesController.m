//
//  VENodesController.m
//  V2EX
//
//  Created by 翁佳 on 15-8-13.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VENodesController.h"
#import "VENodeModel.h"
#import "UIAlertView+AFNetworking.h"
#import "UIRefreshControl+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "VEWebViewController.h"
#import "ICPinyinGroup.h"

@interface VENodesController () {
    NSMutableArray *filteredNodes;
}

@property (nonatomic, strong) NSArray *nodes;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation VENodesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"节点";
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [filteredNodes count];
    }else {
        return  [[self.sortedArrForArrays objectAtIndex:section] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return 1;
    }else {
        return [self.sortedArrForArrays count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return nil;
    }else {
        return [self.sectionHeadsKeys objectAtIndex:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *nodeIdentifier = @"VENodeIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nodeIdentifier forIndexPath:indexPath];
    if (self.searchController.active) {
        VENodeModel *node = filteredNodes[indexPath.row];
        cell.textLabel.text = node.title;
    }else {
        if ([self.sortedArrForArrays count] > indexPath.section) {
            NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
            if ([arr count] > indexPath.row) {
                VENodeModel *node = (VENodeModel *) [arr objectAtIndex:indexPath.row];
                cell.textLabel.text = node.title;
            }
        }
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return nil;
    }else {
        return self.sectionHeadsKeys;
    }
}

- (void)reload:(__unused id)sender {
    NSURLSessionDataTask * task = [VENodeModel nodeWithBlock:^(NSArray *nodes, NSError *error) {
        self.nodes = nodes;
        NSDictionary *dict = [ICPinyinGroup group:self.nodes key:@"title"];
        self.sortedArrForArrays = [dict objectForKey:LEOPinyinGroupResultKey];
        self.sectionHeadsKeys = [dict objectForKey:LEOPinyinGroupCharKey];
        
        //search bar
        filteredNodes = [NSMutableArray array];
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchResultsUpdater = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        self.searchController.hidesNavigationBarDuringPresentation = NO;
        self.searchController.searchBar.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 44.0);
        self.searchController.searchBar.delegate = self;
        self.tableView.tableHeaderView = self.searchController.searchBar;
        
        [self.tableView reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushNodeVEWebViewController"]) {

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        VEWebViewController * webView = segue.destinationViewController;
        
        if (self.searchController.active) {
            VENodeModel *selectedNodeModel = filteredNodes[indexPath.row];
            webView.url = selectedNodeModel.url;
            webView.controllerTitle = selectedNodeModel.title;
        }else {
            if ([self.sortedArrForArrays count] > indexPath.section) {
                NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
                
                if ([arr count] > indexPath.row) {
                    VENodeModel *selectedNodeModel = (VENodeModel *) [arr objectAtIndex:indexPath.row];
                    webView.url = selectedNodeModel.url;
                    webView.controllerTitle = selectedNodeModel.title;
                }
            }
        }
    }
}

#pragma mark - SearchBar Search Results

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    [filteredNodes removeAllObjects];
    if (searchString.length > 0) {
        NSPredicate *predicate =
        [NSPredicate predicateWithBlock:^BOOL(VENodeModel *node, NSDictionary *b) {
             NSRange range = [node.title rangeOfString:searchString options:NSCaseInsensitiveSearch];
             return range.location != NSNotFound;
         }];
        for (NSString *key in self.sectionHeadsKeys) {
            NSInteger keyIndex = [self.sectionHeadsKeys indexOfObject:key];
            NSArray *matches = [[self.sortedArrForArrays objectAtIndex:keyIndex] filteredArrayUsingPredicate: predicate];
            [filteredNodes addObjectsFromArray:matches];
        }
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.tableView reloadData];
    }
}

@end
