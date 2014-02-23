//
//  SigninViewController.m
//  Albert
//
//  Created by Ricardo Pereira on 22/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "SigninViewController.h"
#import "NotificationsViewController.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson4.h"
#import "TSMessage.h"
#import "TSMessageView.h"

@interface SigninViewController ()

@end

@implementation SigninViewController {
    // Private
    NSArray *jsonArray;
}

static int connected = 0;
static NSString* username;
static NSString* email;

+ (int) getConnected
{
    return connected;
}

+ (void) setConnected:(int)value
{
    connected = value;
}

+ (NSString*)getUser {
    return username;
}

+ (void)setUser:(NSString*)newUser {
    if (username != newUser) {
    	username = [newUser copy];
    }
}

+ (NSString*)getEmail {
    return email;
}

+ (void)setEmail:(NSString*)newEmail {
    if (email != newEmail) {
    	email = [newEmail copy];
    }
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
    // Init
    [self.barMain setHidesBackButton:YES animated:NO];

    [TSMessage setDefaultViewController:self];

    self.scrollView.scrollEnabled = NO;

    // Show keyboard event
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    // Hide keyboard event
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)onKeyboardShow:(NSNotification *)notification
{
    [self.scrollView setContentOffset:CGPointMake(0, 10) animated:YES];
}

- (void)onKeyboardHide:(NSNotification *)notification
{
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (IBAction)didTouchLogin:(id)sender
{
    if ([self.editUser.text isEqualToString:@""]) {
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Login", nil)
                                    subtitle:NSLocalizedString(@"Username is empty", nil)
                                        type:TSMessageNotificationTypeError];
        return;
    }

    // ToDo - Trim
    [SigninViewController setUser:self.editUser.text];

    [self signIn];
}

- (void)signIn
{
    NSURL *url = [NSURL URLWithString:@"http://env-9374575.jelastic.lunacloud.com/apptest/login.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:self.editUser.text forKey:@"user"];
    [request setPostValue:self.editPassword.text forKey:@"pass"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
    if (request.responseStatusCode == 400) {
        // 400
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Login", nil)
                                    subtitle:NSLocalizedString(@"Invalid code", nil)
                                        type:TSMessageNotificationTypeError];
    }
    else if (request.responseStatusCode == 403) {
        // 403
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Login", nil)
                                    subtitle:NSLocalizedString(@"Code already used", nil)
                                        type:TSMessageNotificationTypeError];
    }
    else if (request.responseStatusCode == 200) {
        // OK
        NSData *responseData = [request responseData];
        // JSON
        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];

        if (jsonObject == nil || [jsonObject count] == 0) {
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"Login", nil)
                                        subtitle:NSLocalizedString(@"Not invalid", nil)
                                            type:TSMessageNotificationTypeError];
            return;
        }

        NSArray *accountInfo = [jsonObject objectForKey:@"account"];

        [SigninViewController setUser:[accountInfo valueForKey:@"name"]];
        [SigninViewController setEmail:[accountInfo valueForKey:@"email"]];

        // Success
        [SigninViewController setConnected:1];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        // Unexpected
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Login", nil)
                                    subtitle:NSLocalizedString(@"Unexpected error", nil)
                                        type:TSMessageNotificationTypeError];
    }
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
    NSError *error = [request error];
    // Connection problem
    [TSMessage showNotificationWithTitle:NSLocalizedString(@"Connection", nil)
                                subtitle:NSLocalizedString(error.description, nil)
                                    type:TSMessageNotificationTypeError];
}

@end
