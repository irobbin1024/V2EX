//
//  VEFeedbackTableViewController.m
//  V2EX
//
//  Created by 赖隆斌 on 15/9/18.
//  Copyright © 2015年 owl. All rights reserved.
//

#import "VEFeedbackTableViewController.h"
#import "VEFeedbackContentTableViewCell.h"
#import "VEFeedbackContactTableViewCell.h"
#import "VEFeedbackCommitTableViewCell.h"
#import "VEFeedBackModel.h"
#import "UMFeedback.h"
#import "MBProgressHUD.h"

@interface VEFeedbackTableViewController ()

@property (nonatomic, strong) VEFeedBackModel * feedbackModel;

@end

@implementation VEFeedbackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedbackModel = [VEFeedBackModel new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VEFeedbackContentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kVEFeedbackContentTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"VEFeedbackContactTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kVEFeedbackContactTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"VEFeedbackCommitTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kVEFeedbackCommitTableViewCellIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commitButtonAction:(id)sender {
    
    VEFeedbackContentTableViewCell * contentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    VEFeedbackContactTableViewCell * contactCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if (contentCell) {
        self.feedbackModel.content = contentCell.contentTextView.text;
    }
    
    if (contactCell) {
        self.feedbackModel.contact = contactCell.contactTextField.text;
    }
    
    if (contentCell && [contentCell.contentTextView.text isEqualToString:@""]) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        return;
    }
    
    
    [self commitFeedback];
}

- (void)commitFeedback {
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[UMFeedback sharedInstance]updateUserInfo:@{@"contact" : @{@"contact" : self.feedbackModel.contact}}];
    
    [[UMFeedback sharedInstance]post:@{@"content" : self.feedbackModel.content, @"contact" : self.feedbackModel.contact} completion:^(NSError *error) {
        
        if (error) {
            NSString * errorMessage = [NSString stringWithFormat:@"发生错误：%@", error.localizedDescription];
            [[[UIAlertView alloc]initWithTitle:@"警告" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        } else {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"发送成功";
            
            [hud hide:YES afterDelay:1.5];
            
            [self performSelector:@selector(pop) withObject:nil afterDelay:1.5];
        }
    }];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kVEFeedbackContentTableViewCellIdentifier forIndexPath:indexPath];
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:kVEFeedbackContactTableViewCellIdentifier forIndexPath:indexPath];
    } else if (indexPath.section == 2) {
        VEFeedbackCommitTableViewCell * commitCell = [tableView dequeueReusableCellWithIdentifier:kVEFeedbackCommitTableViewCellIdentifier forIndexPath:indexPath];
        [commitCell.commitButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell = commitCell;
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 182;
    } else if (indexPath.section == 1) {
        return 40;
    } else if (indexPath.section == 2) {
        return 40;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"告诉我们你的联系方式，我们会及时联系你的。";
    } else if (section == 0) {
        return @"请输入内容";
    }
    
    return nil;
}

@end
