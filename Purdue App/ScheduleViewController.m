//
//  ScheduleViewController.m
//  Purdue App
//
//  Created by George Lo on 4/7/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "ScheduleViewController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController {
    UIWebView *sdWebView;
    MRProgressOverlayView *progressView;
    NSInteger currentOption;
    NSMutableArray *courseArray;
    NSMutableArray *examArray;
    UISegmentedControl *segmentedControl;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)segChanged:(id)sender {
    currentOption = segmentedControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Class", @"Exam", nil]];
    [segmentedControl addTarget:self action:@selector(segChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    courseArray = [NSMutableArray new];
    examArray = [NSMutableArray new];
    progressView = [MRProgressOverlayView showOverlayAddedTo:self.parentViewController.view animated:YES];
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    progressView.titleLabelText = @"Loading schedule";
    sdWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    sdWebView.delegate = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [sdWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://roomschedule.mypurdue.purdue.edu/Timetabling/exams.do"]]];
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [courseArray removeAllObjects];
    [examArray removeAllObjects];
    if( [webView.request.URL.absoluteString isEqualToString:@"https://roomschedule.mypurdue.purdue.edu/Timetabling/personalSchedule.do"] ) {
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        if ([html rangeOfString:@"Page generated"].location != NSNotFound) {
            html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            html = [html stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            // Retrieve Class Schedule and Exam Schedule tables
            NSMutableArray *tableArray = [NSMutableArray arrayWithArray:[ApplicationDelegate getContentWithData:html usingPattern:@"<TABLE.*?Webtab.*?</TABLE>" withFIndex:0 andBIndex:0]];
            for (int i=0; i<tableArray.count; i++) {
                NSString *string = [tableArray objectAtIndex:i];
                if ([string rangeOfString:@"Class Schedule"].location==NSNotFound && [string rangeOfString:@"Examination Schedule"].location==NSNotFound) {
                    [tableArray removeObjectAtIndex:i];
                    i--;
                }
            }
            
            // Parse out courses and exams
            for (NSString *htmlString in tableArray) {
                if ([htmlString rangeOfString:@"Class Schedule"].location!=NSNotFound) {
                    NSRegularExpression *nameExpression = [NSRegularExpression regularExpressionWithPattern:@"<tr valign=\"top\" .*?left\">(.*?)<.*?left\">(.*?)<.*?left\">(.*?)<.*?left\">(.*?)<.*?;\">(.*?)<.*?colspan=\"1\">(.*?)</td></tr>" options:NSRegularExpressionCaseInsensitive error:nil];
                    NSArray *matches = [nameExpression matchesInString:htmlString
                                                               options:0
                                                                 range:NSMakeRange(0, [htmlString length])];
                    NSString *courseTemp;
                    for (NSTextCheckingResult *match in matches) {
                        CourseInfo *course = [CourseInfo new];
                        course.course = [htmlString substringWithRange:[match rangeAtIndex:1]];
                        course.type = [htmlString substringWithRange:[match rangeAtIndex:2]];
                        course.section =  [htmlString substringWithRange:[match rangeAtIndex:3]];
                        course.time = [htmlString substringWithRange:[match rangeAtIndex:4]];
                        if (course.time.length==0) {
                            course.time = course.section;
                            course.section = course.type;
                            course.type = course.course;
                            course.course = courseTemp;
                        } else {
                            courseTemp = [htmlString substringWithRange:[match rangeAtIndex:1]];
                        }
                        course.room = [htmlString substringWithRange:[match rangeAtIndex:5]];
                        course.instructor = [htmlString substringWithRange:[match rangeAtIndex:6]];
                        [courseArray addObject:course];
                    }
                } else {
                    NSRegularExpression *nameExpression = [NSRegularExpression regularExpressionWithPattern:@"<tr valign=\"top\" on.*?left\">(.*?)<.*?left\">(.*?)<.*?left\">(.*?)<.*?left\">(.*?)<.*?;\">(.*?)</span></td></tr>" options:NSRegularExpressionCaseInsensitive error:nil];
                    NSArray *matches = [nameExpression matchesInString:htmlString
                                                               options:0
                                                                 range:NSMakeRange(0, [htmlString length])];
                    for (NSTextCheckingResult *match in matches) {
                        ExamInfo *info = [ExamInfo new];
                        info.course = [htmlString substringWithRange:[match rangeAtIndex:1]];
                        info.meetTime = [htmlString substringWithRange:[match rangeAtIndex:2]];
                        info.date = [htmlString substringWithRange:[match rangeAtIndex:3]];
                        info.time = [htmlString substringWithRange:[match rangeAtIndex:4]];
                        info.room = [htmlString substringWithRange:[match rangeAtIndex:5]];
                        [examArray addObject:info];
                    }
                }
            }
            
            // Notify the user
            dispatch_async(dispatch_get_main_queue(), ^{
                segmentedControl.selectedSegmentIndex = 0;
                [self.tableView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    progressView.mode = MRProgressOverlayViewModeCheckmark;
                    progressView.titleLabelText = @"Done";
                    [progressView dismiss:YES];
                });
            });
        }
    }
    // Trigger Javascript
    else if( [webView.request.URL.absoluteString isEqualToString:@"https://roomschedule.mypurdue.purdue.edu/Timetabling/exams.do"] ) {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        NSString *JSUser = [NSString stringWithFormat:@"document.getElementsByName('username')[0].value='%@';",username];
        NSString *JSPass = [NSString stringWithFormat:@"document.getElementsByName('password')[0].value='%@';",password];
        [webView stringByEvaluatingJavaScriptFromString:JSUser];
        [webView stringByEvaluatingJavaScriptFromString:JSPass];
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('s2').click()"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (currentOption == 0) {
        return courseArray.count;
    } else {
        return examArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (currentOption == 0) {
        CourseInfo *course = [courseArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ by %@", course.course, course.type, course.instructor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ in %@ (%@)", course.time, course.room, course.section];
    } else {
        ExamInfo *exam = [examArray objectAtIndex:indexPath.row];
        cell.textLabel.text = exam.course;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ in %@", exam.date, exam.time, exam.room];
    }
    
    return cell;
}

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
