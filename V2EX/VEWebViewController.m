//
//  VEWebViewController.m
//  
//
//  Created by baiyang on 15/7/27.
//
//

#import "VEWebViewController.h"
#import "MBProgressHUD.h"

@interface VEWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation VEWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    self.title = self.controllerTitle;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareAction:(id)sender {
    UIActivityViewController * shareController = [[UIActivityViewController alloc]initWithActivityItems:@[self.controllerTitle, self.url] applicationActivities:nil];
    [self.navigationController presentViewController:shareController animated:YES completion:nil];
}
#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"出现错误了";
    hud.detailsLabelText = error.localizedDescription;
    
    [hud hide:YES afterDelay:3];
}

@end
