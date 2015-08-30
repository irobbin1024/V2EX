//
//  VEOpenComponentsController.m
//  V2EX
//
//  Created by wengjia on 15/8/31.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VEOpenComponentsController.h"
#import "VEOpenComponentLicenseController.h"

@interface VEOpenComponentsController () {
    NSArray *componentsName;
    NSArray *componentsDetail;
}

@end

@implementation VEOpenComponentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第三方开源类库";
    
    componentsName = [self.openComponentsInfo allKeys];
    componentsDetail = [self.openComponentsInfo allValues];
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
    return componentsName.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"VEComponentNameIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = componentsName[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VEOpenComponentLicenseController *componentLicense = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"VEOpenComponentLicenseController"];
    componentLicense.lisenceContext = componentsDetail[indexPath.row];
    [self.navigationController pushViewController:componentLicense animated:YES];
}
@end
