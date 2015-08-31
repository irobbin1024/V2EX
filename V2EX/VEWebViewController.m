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
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *shareButtonItem;
@property (nonatomic, strong) UIBarButtonItem *activityButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
@end

@implementation VEWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    self.title = @"论坛";
    
    NSURLRequest * request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    
    [self configBarButtons];
}

- (void)configBarButtons {
    self.shareButtonItem = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                            target:self
                            action:@selector(shareAction:)];
    
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20,20)];
    [activityView sizeToFit];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    self.activityButtonItem = [[UIBarButtonItem alloc]initWithCustomView:activityView];
    
    self.refreshButtonItem = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                              target:self
                              action:@selector(refreshAction:)];
    
    [self.navigationItem setRightBarButtonItem:self.activityButtonItem];
    [activityView startAnimating];
    
    self.closeButtonItem = [[UIBarButtonItem alloc]
                            initWithTitle:@"关闭"  style:UIBarButtonItemStylePlain
                            target:self
                            action:@selector(closeAction:)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:self.closeButtonItem];
//    self.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityView stopAnimating];
    self.navigationItem.rightBarButtonItem = self.shareButtonItem;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [activityView stopAnimating];
    self.navigationItem.rightBarButtonItem = self.refreshButtonItem;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"出现错误了";
    hud.detailsLabelText = error.localizedDescription;
    
    [hud hide:YES afterDelay:3];
}

#pragma mark - BarItemButton Action

- (IBAction)shareAction:(id)sender {
    UIActivityViewController * shareController = [[UIActivityViewController alloc]
                                                  initWithActivityItems:@[self.controllerTitle, self.url]applicationActivities:nil];
    [self.navigationController presentViewController:shareController animated:YES completion:nil];
}

- (IBAction)refreshAction:(id)sender {
    NSURLRequest * request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (IBAction)backButtonAction:(id)sender {
    if (![self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItem = nil;
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }else {
        [self.webView goBack];
    }
}
- (void)backToRootView {
    if (![self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItem = nil;
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }else {
        [self.webView goBack];
    }
}

- (IBAction)closeAction:(id)sender {
    [[self navigationController] popToRootViewControllerAnimated:YES];
}
@end
