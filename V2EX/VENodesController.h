//
//  VENodesController.h
//  V2EX
//
//  Created by 翁佳 on 15-8-13.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENodesController : UITableViewController <UISearchBarDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) NSMutableArray *sortedArrForArrays;
@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys;
@end
