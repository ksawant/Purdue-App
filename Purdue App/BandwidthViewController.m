//
//  BandwidthViewController.m
//  Purdue App
//
//  Created by George Lo on 4/11/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "BandwidthViewController.h"

@interface BandwidthViewController ()

@end

@implementation BandwidthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"MYBANDWIDTH", nil);
    
    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.frame];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    MRActivityIndicatorView *indicatorView = [[MRActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 40+44+20, ScreenWidth-40*2, ScreenWidth-40*2)];
    [indicatorView startAnimating];
    [self.view addSubview:indicatorView];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.purdue.edu/apps/account/cas/login?service=https%3A%2F%2Fmy.resnet.purdue.edu%2Flogin%2Fmyresnet_mystats"]]];
    [self.view addSubview:webView];
    webView.delegate = self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView.request.URL.absoluteString isEqualToString:@"https://www.purdue.edu/apps/account/cas/login?service=https%3A%2F%2Fmy.resnet.purdue.edu%2Flogin%2Fmyresnet_mystats"]) {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        NSString *JSUser = [NSString stringWithFormat:@"document.getElementsByName('username')[0].value='%@';",username];
        NSString *JSPass = [NSString stringWithFormat:@"document.getElementsByName('password')[0].value='%@';",password];
        [webView stringByEvaluatingJavaScriptFromString:JSUser];
        [webView stringByEvaluatingJavaScriptFromString:JSPass];
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('submit')[0].click();"];
    } else if ([webView.request.URL.absoluteString isEqualToString:@"https://my.resnet.purdue.edu/mystats"]) {
        self.view = webView;
        [webView stringByEvaluatingJavaScriptFromString:@"var metaElement = document.createElement(\"meta\");metaElement.name = \"viewport\";metaElement.content = \"initial-scale= 0.1 \";var head = document.getElementsByTagName(\"head\")[0];head.appendChild(metaElement)"];
        [webView stringByEvaluatingJavaScriptFromString:@"window.scroll(255,180)"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
