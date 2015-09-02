//
//  VEWebViewController.m
//
//
//  Created by baiyang on 15/7/27.
//
//

#import "VEWebViewController.h"
#import "MBProgressHUD.h"
#import "UIViewController+BackButtonHandler.h"

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
    self.title = @"话题";
    
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
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                           style:UIBarButtonItemStylePlain target:nil
                                                           action:nil];
    self.navigationController.navigationBar.backItem.backBarButtonItem = backbutton;
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
    NSLog(@"share url:%@", self.webView.request.URL.absoluteString);
    UIActivityViewController * shareController = [[UIActivityViewController alloc]
                                                  initWithActivityItems:@[self.controllerTitle, self.webView.request.URL]
                                                  applicationActivities:nil];
    [self.navigationController presentViewController:shareController animated:YES completion:nil];
}

- (IBAction)refreshAction:(id)sender {
    NSLog(@"refresh url:%@", self.webView.request.URL.absoluteString);
    [self.webView reload];
}

- (IBAction)closeAction:(id)sender {
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (BOOL)navigationShouldPopOnBackButton {
    if (![self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItem = nil;
        return YES;
    }else {
        [self.webView goBack];
        self.navigationItem.leftBarButtonItem = self.closeButtonItem;
        return NO;
    }
}
@end
