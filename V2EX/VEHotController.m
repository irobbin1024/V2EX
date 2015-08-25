//
//  VEHotController.m
//  
//
//  Created by baiyang on 15/7/24.
//
//

#import "VEHotController.h"
#import "VEStatusModel.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "VEWebViewController.h"
#import "VEStatusTableViewCell.h"

@interface VEHotController ()

@property (nonatomic, strong) NSArray * hots;

@end

@implementation VEHotController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最热";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VEStatusTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:VEStatusTableViewCellIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
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

#pragma mark - Data

- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSURLSessionTask *task = [VEStatusModel hotsWithBlock:^(NSArray *hots, NSError *error) {
        if (!error) {
            self.hots = hots;
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
    return self.hots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VEStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VEStatusTableViewCellIdentifier forIndexPath:indexPath];
    
    [cell setupWithStatusModel:self.hots[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:VEStatusTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(VEStatusTableViewCell * cell) {
        
        [cell setupWithStatusModel:self.hots[indexPath.row]];
    }];
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VEWebViewController * webView = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"VEWebViewController"];
    VEStatusModel * selectedStatusModel = self.hots[[self.tableView indexPathForSelectedRow].row];
    webView.url = selectedStatusModel.url;
    webView.controllerTitle = selectedStatusModel.title;
    
    [self.navigationController pushViewController:webView animated:YES];
}
@end
