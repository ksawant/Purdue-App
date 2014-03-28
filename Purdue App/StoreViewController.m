//
//  StoreViewController.m
//  Purdue App
//
//  Created by George Lo on 3/25/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

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
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.navigationItem.title = NSLocalizedString(@"STORE", nil);
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.purdueofficialstore.com/"]]];
    webView.delegate = self;
    self.view = webView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

# pragma mark Web View Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
