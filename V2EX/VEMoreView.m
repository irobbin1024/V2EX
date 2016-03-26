//
//  VEMoreView.m
//  V2EX
//
//  Created by baiyang on 16/3/26.
//  Copyright © 2016年 owl. All rights reserved.
//

#import "VEMoreView.h"
#import "Masonry.h"

@interface VEMoreView ()

@property (nonatomic, assign) UIView * containerView;

@end

@implementation VEMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGesture:)]];
    
    UIView * containerView = [UIView new];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    containerView.layer.shadowOpacity = .3f;
    containerView.layer.shadowRadius = 4.f;
    containerView.layer.shadowOffset = CGSizeMake(0, 3);
    
    [self addSubview:containerView];
    self.containerView = containerView;
    
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:shareButton];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(containerView);
        make.height.mas_equalTo(35);
    }];
    
    UIButton * collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [containerView addSubview:collectButton];
    [collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareButton.mas_bottom);
        make.left.right.equalTo(containerView);
        make.height.mas_equalTo(35);
    }];
    
    UIButton * reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportButton setTitle:@"举报" forState:UIControlStateNormal];
    [reportButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [containerView addSubview:reportButton];
    [reportButton addTarget:self action:@selector(reportButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectButton.mas_bottom);
        make.left.right.equalTo(containerView);
        make.height.mas_equalTo(35);
    }];
    
    UIView * shareLineView = [UIView new];
    shareLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    
    [shareButton addSubview:shareLineView];
    
    [shareLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(shareButton);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView * collectLineView = [UIView new];
    collectLineView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.6];
    
    [collectButton addSubview:collectLineView];
    
    [collectLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(collectButton);
        make.height.mas_equalTo(0.5);
    }];
    
    UIImageView * triangleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Arrowhead-01-32"]];
    triangleView.contentMode = UIViewContentModeScaleAspectFill;
    [containerView addSubview:triangleView];
    
    [triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(containerView.mas_top).offset(4);
        make.right.equalTo(containerView).offset(-15);
    }];
    
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(reportButton.mas_bottom);
    }];
 
    containerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
}

- (void)shareButtonAction:(id)sender {
    [self dismiss];
    
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(shareAction)]) {
        [self.actionDelegate shareAction];
    }
}

- (void)collectButtonAction:(id)sender {
    [self dismiss];
    
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(collection)]) {
        [self.actionDelegate collectAction];
    }
}

- (void)reportButtonAction:(id)sender {
    [self dismiss];
    
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(reportAction)]) {
        [self.actionDelegate reportAction];
    }
}

- (void)show {
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    }];
    
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:0 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(1.00, 1.00);
    } completion:nil];
}

- (void)dismiss {
    self.containerView.hidden = YES;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)viewTapGesture:(id)sender {
    [self dismiss];
}

@end
