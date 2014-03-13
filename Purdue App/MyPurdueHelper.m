//
//  MyPurdueHelper.m
//  Purdue App
//
//  Created by George Lo on 2/25/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "MyPurdueHelper.h"

@implementation MyPurdueHelper {
    UIWebView *purdueWebView;
    NSString *user;
    NSString *pass;
    BOOL loggedIn;
}

@synthesize delegate;

- (id)initWithUser:(NSString *)username AndPassword:(NSString *)password {
    if( (self=[super init]) ) {
        user = username;
        pass = password;
        
        purdueWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        purdueWebView.delegate = self;
        [purdueWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://wl.mypurdue.purdue.edu/cp/home/displaylogin"]]];
    }
    
    return self;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
#if DEBUG_MyPurdueHelper
    NSLog(@"[MyPurdueHelper]webViewDidFailLoad:%@ WithError: %@",
          webView.request.URL.absoluteString,
          error.localizedDescription);
#endif
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
#if DEBUG_MyPurdueHelper
    NSLog(@"[MyPurdueHelper]webViewDidStartLoad: %@",
          webView.request.URL.absoluteString);
#endif
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
#if DEBUG_MyPurdueHelper
    NSLog(@"[MyPurdueHelper]webViewDidFinishLoad: %@",
          webView.request.URL.absoluteString);
#endif
    
    if( !loggedIn ) {
        // MAIN_URL = https://wl.mypurdue.purdue.edu/render.userLayoutRootNode.uP?uP_root=root
        if( [webView.request.URL.absoluteString isEqualToString:@"https://wl.mypurdue.purdue.edu/render.userLayoutRootNode.uP?uP_root=root"] ) {
            loggedIn = YES;
        }
        // Trigger Javascript
        else {
            NSString *JSUser = [NSString stringWithFormat:@"document.getElementsByName('user')[0].value='%@';",user];
            NSString *JSPass = [NSString stringWithFormat:@"document.getElementsByName('pass')[0].value='%@';",pass];
            [webView stringByEvaluatingJavaScriptFromString:JSUser];
            [webView stringByEvaluatingJavaScriptFromString:JSPass];
            [webView stringByEvaluatingJavaScriptFromString:@"login()"];
        }
    }
}

- (void)scheduleProcessing {
    
}

// if (self.delegate && [self.delegate respondsToSelector:@selector(optionalDelegateMethodOne)]) {
//    [self.delegate completeSchedule];
//}

@end
