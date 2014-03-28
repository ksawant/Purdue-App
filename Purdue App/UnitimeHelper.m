//
//  UnitimeHelper.m
//  Purdue App
//
//  Created by George Lo on 2/25/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "UnitimeHelper.h"

@implementation UnitimeHelper {
    UIWebView *timeWebView;
    NSString *user;
    NSString *pass;
}

@synthesize delegate;

- (id)initWithUser:(NSString *)username AndPassword:(NSString *)password {
    if( (self=[super init]) ) {
        user = username;
        pass = password;
        
        timeWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        timeWebView.delegate = self;
        [timeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://roomschedule.mypurdue.purdue.edu/Timetabling/exams.do"]]];
    }
    
    return self;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
#if DEBUG_UnitimeHelper
    NSLog(@"[UnitimeHelper]webViewDidFailLoad:%@ WithError: %@",
          webView.request.URL.absoluteString,
          error.localizedDescription);
#endif
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
#if DEBUG_UnitimeHelper
    NSLog(@"[UnitimeHelper]webViewDidStartLoad: %@",
          webView.request.URL.absoluteString);
#endif
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
#if DEBUG_UnitimeHelper
    NSLog(@"[UnitimeHelper]webViewDidFinishLoad: %@",
          webView.request.URL.absoluteString);
#endif
    
    // MAIN_URL = https://wl.Unitime.purdue.edu/render.userLayoutRootNode.uP?uP_root=root
    if( [webView.request.URL.absoluteString isEqualToString:@"https://roomschedule.mypurdue.purdue.edu/Timetabling/personalSchedule.do"] ) {
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        NSLog(@"%@",html);
    }
    // Trigger Javascript
    else {
        NSString *JSUser = [NSString stringWithFormat:@"document.getElementsByName('username')[0].value='%@';",user];
        NSString *JSPass = [NSString stringWithFormat:@"document.getElementsByName('password')[0].value='%@';",pass];
        [webView stringByEvaluatingJavaScriptFromString:JSUser];
        [webView stringByEvaluatingJavaScriptFromString:JSPass];
        [webView stringByEvaluatingJavaScriptFromString:@"login()"];
    }
}

- (void)scheduleProcessing {
    
}

// if (self.delegate && [self.delegate respondsToSelector:@selector(optionalDelegateMethodOne)]) {
//    [self.delegate completeSchedule];
//}

@end
