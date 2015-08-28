//
//  VEWebViewController.m
//  
//
//  Created by baiyang on 15/7/27.
//
//

#import "VEWebViewController.h"
#import "MBProgressHUD.h"

@interface VEWebViewController ()<UIWebViewDelegate> {
    UIActivityIndicatorView *activityView;
    UIBarButtonItem *shareButtonItem;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation VEWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    self.title = self.controllerTitle;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    
    NSMutableArray* btns = [[NSMutableArray alloc] init];
    
    shareButtonItem = self.navigationItem.rightBarButtonItem;
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20,20)];
    [activityView sizeToFit];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *activityButtonItem = [[UIBarButtonItem alloc]initWithCustomView:activityView];
    [btns addObject:activityButtonItem];
    
    [self.navigationItem setRightBarButtonItems:btns];
    [activityView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareAction:(id)sender {
    UIActivityViewController * shareController = [[UIActivityViewController alloc]initWithActivityItems:@[self.controllerTitle, self.url] applicationActivities:nil];
    [self.navigationController presentViewController:shareController animated:YES completion:nil];
}

#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityView stopAnimating];
    self.navigationItem.rightBarButtonItem = shareButtonItem;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [activityView stopAnimating];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"出现错误了";
    hud.detailsLabelText = error.localizedDescription;
    
    [hud hide:YES afterDelay:3];
}
@end
