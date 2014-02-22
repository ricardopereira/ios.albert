//
//  ViewController.m
//  Albert
//
//  Created by Ricardo Pereira on 14/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "DashboardViewController.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson4.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Init
    self.labelStatus.text = NSLocalizedString(@"Welcome",nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didButtonSend:(id)sender {
    // Connecting
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.65/~ricardopereira/albert/"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"call" forKey:@"app_id"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 400) {
        self.labelStatus.text = @"Invalid code";
    } else if (request.responseStatusCode == 403) {
        self.labelStatus.text = @"Code already used";
    } else if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
        NSLog(@"%@",responseString);
        self.labelStatus.text = responseString;
    } else {
        self.labelStatus.text = @"Unexpected error";
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    self.labelStatus.text = error.localizedDescription;
}

@end
