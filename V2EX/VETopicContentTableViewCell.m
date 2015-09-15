//
//  VETopicContentTableViewCell.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VETopicContentTableViewCell.h"
#import "UIWebView+Single.h"
#import "VEWebViewController.h"

@interface VETopicContentTableViewCell ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation VETopicContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.webView.scrollView.scrollEnabled = NO;
//    self.webView.scrollView.bounces = NO;
    
    self.webView.scrollView.alwaysBounceVertical = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)heightWithTopic:(VETopicModel *)topic {
    CGFloat height = [UIWebView heightFromCacheWithTopicID:topic.topicID width:[UIScreen mainScreen].bounds.size.width];
    if (height < 0) {
        height = kReplieTableViewCellDefaultHeight;
    }
    
    return height;
}

- (void)setupWithTopic:(VETopicModel *)topic {
    self.topic = topic;
    [self.webView loadHTMLString:topic.contentRendered baseURL:[NSURL URLWithString:@"http://www.v2ex.com"]];
}

#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType != UIWebViewNavigationTypeLinkClicked) {
        return YES;
    }
    
    VEWebViewController * webViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VEWebViewController"];
    webViewController.url = request.URL;
    webViewController.controllerTitle = @"浏览";
    
    if (self.viewController && self.viewController.navigationController) {
        [self.viewController.navigationController pushViewController:webViewController animated:YES];
    }
    
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height = [UIWebView heightFromCacheWithTopicID:self.topic.topicID width:[UIScreen mainScreen].bounds.size.width];
    if (height < 0) {
        CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
        
        [UIWebView writeHeight:webViewHeight withTopicID:self.topic.topicID width:[UIScreen mainScreen].bounds.size.width];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kGetWebViewContentSizeSuccessNitification object:self];
    } else {
        self.webView.scrollView.contentSize = CGSizeMake(self.webView.scrollView.contentSize.width, height);
    }
}


@end
