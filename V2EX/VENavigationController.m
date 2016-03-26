//
//  VENavigationController.m
//  
//
//  Created by baiyang on 15/7/24.
//
//

#import "VENavigationController.h"

@interface VENavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation VENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    id target = self.interactivePopGestureRecognizer.delegate;
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    pan.delegate = self;
//    [self.view addGestureRecognizer:pan];
//    self.interactivePopGestureRecognizer.enabled = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}


@end
