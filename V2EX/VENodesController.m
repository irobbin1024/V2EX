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
@end

@implementation VENodesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"节点";
    
//    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
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
            initials = [initials subarrayWithRange:NSMakeRange(1, initials.count-1)];
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

- (void)reload:(__unused id)sender {
    NSURLSessionDataTask * task = [VENodesOperator nodeWithBlock:^(NSArray *nodes, NSError *error) {
        self.nodes = nodes;
        NSDictionary *dict = [ICPinyinGroup group:self.nodes key:@"title"];
        self.sortedArrForArrays = [dict objectForKey:LEOPinyinGroupResultKey];
        self.sectionHeadsKeys = [dict objectForKey:LEOPinyinGroupCharKey];
        
        //Data Persistence
        if (self.nodes > 0) {
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
            [self.sectionHeadsKeys insertObject:@"我的节点" atIndex:0];
            [self.sortedArrForArrays insertObject:self.myNodes atIndex:0];
        }
        
        //search bar
        if (self.nodes.count > 0) {
            filteredNodes = [NSMutableArray array];
            self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
            self.searchController.searchResultsUpdater = self;
            self.searchController.dimsBackgroundDuringPresentation = NO;
            self.searchController.hidesNavigationBarDuringPresentation = NO;
            self.searchController.searchBar.frame = CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 44.0);
            self.searchController.searchBar.delegate = self;
            self.tableView.tableHeaderView = self.searchController.searchBar;
        }
        [self.tableView reloadData];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
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
    
    if (self.searchController.active) {
        [self searchBarCancelButtonClicked:nil];
        [self.searchController.searchBar removeFromSuperview];
    }
    topicListController.delegate = self;
    [self.navigationController pushViewController:topicListController animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Heart-Shadow-icon"]];
        imageView.frame = CGRectMake(11, 1, 20, 20);
        [view addSubview:imageView];
        [view setBackgroundColor:[UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f]];
    }
    return view;
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
        [self.tableView reloadData];
    }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

@end
