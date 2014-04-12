//
//  SignInViewController.m
//  Purdue App
//
//  Created by George Lo on 4/11/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController {
    UIView *whiteView;
    UIImageView *logoIV;
    UITextField *userField;
    UITextField *passField;
    BOOL editActive;
}

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
    
    logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PurdueLogo"]];
    logoIV.frame = CGRectMake(20, 65, ScreenWidth-40, 75);
    logoIV.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage *bgImage = [UIImage imageNamed:@"PurdueBackground2"];
    bgImage = [bgImage blurredImageWithRadius:10 iterations:30 tintColor:[UIColor blackColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:bgImage];
    imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(20, 180, ScreenWidth-20*2, 220)];
    whiteView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    whiteView.layer.cornerRadius = 2;
    whiteView.layer.masksToBounds = YES;
    
    userField = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, ScreenWidth-40*2, 44)];
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    UIImageView *userIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Username"]];
    userIV.frame = CGRectMake(10, 7, 30, 30);
    userIV.contentMode = UIViewContentModeCenter;
    [userView addSubview:userIV];
    userField.leftView = userView;
    userField.leftViewMode = UITextFieldViewModeAlways;
    userField.textColor = [UIColor whiteColor];
    userField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.9 alpha:0.9]}];
    userField.layer.cornerRadius = 2;
    userField.layer.masksToBounds = YES;
    userField.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    userField.returnKeyType = UIReturnKeyDone;
    userField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userField.autocorrectionType = UITextAutocorrectionTypeNo;
    userField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userField.delegate = self;
    [whiteView addSubview:userField];
    
    passField = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, ScreenWidth-40*2, 44)];
    UIView *passView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    UIImageView *passIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Password"]];
    passIV.frame = CGRectMake(10, 7, 30, 30);
    passIV.contentMode = UIViewContentModeCenter;
    [passView addSubview:passIV];
    passField.leftView = passView;
    passField.leftViewMode = UITextFieldViewModeAlways;
    passField.textColor = [UIColor whiteColor];
    passField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.9 alpha:0.9]}];
    passField.layer.cornerRadius = 2;
    passField.layer.masksToBounds = YES;
    passField.secureTextEntry = YES;
    passField.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    passField.returnKeyType = UIReturnKeyDone;
    passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passField.delegate = self;
    [whiteView addSubview:passField];
    
    UIButton *signinBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 220-60, ScreenWidth-20*2, 60)];
    signinBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [signinBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    signinBtn.layer.cornerRadius = 2;
    signinBtn.layer.masksToBounds = YES;
    [signinBtn setTitle:@"Sign In" forState:UIControlStateNormal];
    [signinBtn setTintColor:[UIColor whiteColor]];
    [signinBtn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:signinBtn];
    
    UIImageView *peteIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PurduePete"]];
    peteIV.frame = CGRectMake(20, 415, ScreenWidth-40, 140);
    peteIV.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:imageView];
    [self.view addSubview:logoIV];
    [self.view addSubview:whiteView];
    [self.view addSubview:peteIV];
}

- (IBAction)signIn:(id)sender {
    [self performSegueWithIdentifier:@"toMain" sender:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    editActive = YES;
    if (whiteView.frame.origin.y == 180) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect newFrame = whiteView.frame;
            newFrame.origin.y = 65;
            whiteView.frame = newFrame;
            newFrame = logoIV.frame;
            newFrame.origin.y = -80;
            logoIV.frame = newFrame;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (whiteView.frame.origin.y == 65 && !editActive ) {
        
    }
    if ([textField.placeholder isEqualToString:@"Username"]) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"username"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"password"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect newFrame = whiteView.frame;
        newFrame.origin.y = 180;
        whiteView.frame = newFrame;
        newFrame = logoIV.frame;
        newFrame.origin.y = 65;
        logoIV.frame = newFrame;
    }];
    return YES;
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
