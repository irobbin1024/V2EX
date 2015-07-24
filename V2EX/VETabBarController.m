//
//  VETabBarController.m
//  
//
//  Created by baiyang on 15/7/24.
//
//

#import "VETabBarController.h"

@interface VETabBarController () <UITabBarControllerDelegate>

@end

@implementation VETabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UITabBarItem * item = obj;
        
        switch (idx) {
            case 0:
                [item setValue:@"最热" forKeyPath:@"_view._label._content"];
                break;
            case 1:
                [item setValue:@"最新" forKeyPath:@"_view._label._content"];
                break;
            case 2:
                [item setValue:@"节点" forKeyPath:@"_view._label._content"];
                break;
            case 3:
                [item setValue:@"关于" forKeyPath:@"_view._label._content"];
                break;
            default:
                break;
        }
    }];
}


@end
