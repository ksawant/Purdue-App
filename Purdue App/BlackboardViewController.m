//
//  BlackboardViewController.m
//  Purdue App
//
//  Created by George Lo on 4/11/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "BlackboardViewController.h"

@interface BlackboardViewController ()

@end

@implementation BlackboardViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"BLACKBOARD", nil);
    
    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.frame];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    MRActivityIndicatorView *indicatorView = [[MRActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 40+44+20, ScreenWidth-40*2, ScreenWidth-40*2)];
    [indicatorView startAnimating];
    [self.view addSubview:indicatorView];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mycourses.purdue.edu/"]]];
    //[self.view addSubview:webView];
    self.view = webView;
    webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView.request.URL.absoluteString isEqualToString:@"https://mycourses.purdue.edu/"]) {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        NSString *JSUser = [NSString stringWithFormat:@"document.getElementsByName('user_id')[0].value='%@';",username];
        NSString *JSPass = [NSString stringWithFormat:@"document.getElementsByName('password')[0].value='%@';",password];
        [webView stringByEvaluatingJavaScriptFromString:JSUser];
        [webView stringByEvaluatingJavaScriptFromString:JSPass];
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('login')[0].click();"];
    } else if ([webView.request.URL.absoluteString isEqualToString:@"https://mycourses.purdue.edu/webapps/portal/frameset.jsp"]) {
        self.view = webView;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
