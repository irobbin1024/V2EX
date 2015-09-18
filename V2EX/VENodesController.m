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
#import "ICPinyinGroup.h"
#import "VENodesOperator.h"
#import "VETopicListController.h"
#import "VETopicListControllerUtil.h"

@interface VENodesController () <VETopicListDelegate>{
    NSMutableArray *filteredNodes;
}

@property (nonatomic, strong) NSArray *nodes;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *myNodes;
@property (nonatomic, strong) UIRefreshControl *nodeRefreshControl;
@end

@implementation VENodesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"节点";

    self.nodeRefreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    self.refreshControl = self.nodeRefreshControl;
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 44.0);
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    
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

- (void)dealloc {
    [self.refreshControl setRefreshingWithStateOfTask:nil];
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
            if (indexPath.section == 0) {
                VENodeModel *node = (VENodeModel *) [self.myNodes objectAtIndex:indexPath.row];
                cell.textLabel.text = node.title;
            }else {
                NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
                if ([arr count] > indexPath.row) {
                    VENodeModel *node = (VENodeModel *) [arr objectAtIndex:indexPath.row];
                    cell.textLabel.text = node.title;
                }
            }
        }
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!self.searchController.active) {
        if (self.sectionHeadsKeys.count > 0) {
            NSMutableArray *index = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
            NSArray *initials = self.sectionHeadsKeys;
            [index addObjectsFromArray:initials];
            return index;
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (!self.searchController.active) {
        if (index > 0) {
            return [self.sectionHeadsKeys indexOfObject:title];
        }else {
            CGRect searchBarFrame = self.searchController.searchBar.frame;
            [self.tableView scrollRectToVisible:searchBarFrame animated:NO];
            return NSNotFound;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VETopicListController * topicListController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"VETopicListController"];
    topicListController.topicListType = VETopicListTypeNodes;
    
    VENodeModel *selectedNodeModel;
    if (self.searchController.active && filteredNodes.count != 0) {
        selectedNodeModel = filteredNodes[indexPath.row];
        [VETopicListControllerUtil setInstanceNodeName:selectedNodeModel.name];
        [VETopicListControllerUtil setInstanceNodeTitle:selectedNodeModel.title];
    }else {
        if ([self.sortedArrForArrays count] > indexPath.section) {
            NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
            
            if ([arr count] > indexPath.row) {
                selectedNodeModel = (VENodeModel *) [arr objectAtIndex:indexPath.row];
                [VETopicListControllerUtil setInstanceNodeName:selectedNodeModel.name];
                [VETopicListControllerUtil setInstanceNodeTitle:selectedNodeModel.title];
            }
        }
    }
    BOOL isShowCollect = YES;
    for (VENodeModel *obj in self.myNodes) {
        if ([obj.name isEqual:selectedNodeModel.name]) {
            isShowCollect = NO;
            break;
        }
    }
    [topicListController rightButtonItemStatusWithIsShowCollect:isShowCollect];
    topicListController.delegate = self;
    [self.navigationController pushViewController:topicListController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    if (section == 0 && !self.searchController.active) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(11, 3, 50, 15)];
        label.text = @"♥️";
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f]];
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]init];
    if (section == 0 && self.myNodes.count == 0) {
        footerView.frame = CGRectMake(0, 0, tableView.frame.size.width, 30);
        footerView.backgroundColor = [UIColor whiteColor];
        return footerView;
    }else {
        footerView.frame = CGRectMake(0, 0, tableView.frame.size.width, 0);
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 && self.myNodes.count == 0 && !self.searchController.active) {
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        return 0;
    }
    return 24;
}

#pragma mark - SearchBar Search Delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    [filteredNodes removeAllObjects];
    if (searchString.length > 0) {
        NSPredicate *predicate =
        [NSPredicate predicateWithBlock:^BOOL(VENodeModel *node, NSDictionary *b) {
             NSRange range = [node.title rangeOfString:searchString options:NSCaseInsensitiveSearch];
             return range.location != NSNotFound;
         }];
        
        for (NSString *key in [self.sectionHeadsKeys subarrayWithRange:NSMakeRange(1, self.sectionHeadsKeys.count-1)]) {
            NSInteger keyIndex = [self.sectionHeadsKeys indexOfObject:key];
            NSArray *matches = [[self.sortedArrForArrays objectAtIndex:keyIndex] filteredArrayUsingPredicate: predicate];
            [filteredNodes addObjectsFromArray:matches];
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (self.searchController.active) {
        self.searchController.active = NO;
        //Restore refresh control
        self.refreshControl = self.nodeRefreshControl;
        [self.tableView reloadData];
    }
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    // Disable refresh control
    self.refreshControl = nil;
    return YES;
}

#pragma mark - VETopicListDelegate

- (VETopicListTipType)didClickCollectButtonWithName:(NSString *)name {
    NSMutableArray *nodeName = [self readDataWithFilePath:[self dataFilePath]];
    for (VENodeModel *obj in self.nodes) {
        if ([obj.name isEqual:name]) {
            [nodeName addObject:obj.name];
            BOOL result = [nodeName writeToFile:[self dataFilePath] atomically:YES];
            if (result) {
                [self.myNodes addObject:obj];
                [self.tableView reloadData];
                return VETopicListTip_Success;
            }
            break;
        }
    }
    return VETopicListTip_Failure;
}

- (VETopicListTipType)didClickCancerCollectButtonWithName:(NSString *)name {
    NSMutableArray *nodeName = [self readDataWithFilePath:[self dataFilePath]];
    for (VENodeModel *obj in self.myNodes) {
        if (obj.name == name) {
            [nodeName removeObject:obj.name];
            BOOL result = [nodeName writeToFile:[self dataFilePath] atomically:YES];
            if (result) {
                [self.myNodes removeObject:obj];
                [self.tableView reloadData];
                return VETopicListTip_Success;
            }
        }
    }
    return VETopicListTip_Failure;
}

#pragma mark - Data persistence

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"Documents Path:%@", documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
}

- (NSMutableArray *)readDataWithFilePath:(NSString *)filePath {
    NSLog(@"read Documents Path:%@", filePath);

    NSMutableArray *array;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        array = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    if (array == nil) {
        array = [NSMutableArray array];
    }
    return array;
}

#pragma mark - Data Source

- (void)reload:(__unused id)sender {
    NSURLSessionDataTask * task = [VENodesOperator nodeWithBlock:^(NSArray *nodes, NSError *error) {
        if (!error) {
            if (self.sortedArrForArrays != nil) [self.sortedArrForArrays removeAllObjects];
            if (self.sectionHeadsKeys != nil) [self.sectionHeadsKeys removeAllObjects];
            self.nodes = nodes;
            if (self.nodes.count > 0) {
                NSDictionary *dict = [ICPinyinGroup group:self.nodes key:@"title"];
                self.sortedArrForArrays = [dict objectForKey:LEOPinyinGroupResultKey];
                self.sectionHeadsKeys = [dict objectForKey:LEOPinyinGroupCharKey];
            }
            
            //Data Persistence
            if (self.nodes.count > 0) {
                if (self.myNodes == nil) {
                    self.myNodes = [[NSMutableArray alloc] init];
                }else {
                    [self.myNodes removeAllObjects];
                }
                NSArray *nodeName = [self readDataWithFilePath:[self dataFilePath]];
                for (NSString *name in nodeName) {
                    [self.nodes enumerateObjectsUsingBlock:^(VENodeModel *obj, NSUInteger idx, BOOL *stop) {
                        if ([obj.name isEqual:name]) {
                            [self.myNodes addObject:obj];
                        }
                    }];
                }
                [self.sectionHeadsKeys insertObject:@"藏" atIndex:0];
                [self.sortedArrForArrays insertObject:self.myNodes atIndex:0];
            }
            
            //search bar
            if (self.nodes.count > 0) {
                filteredNodes = [NSMutableArray array];
                self.tableView.tableHeaderView = self.searchController.searchBar;
                
            }
            [self.tableView reloadData];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}
@end
