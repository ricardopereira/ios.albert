//
//  NotificationsViewController.m
//  Albert
//
//  Created by Ricardo Pereira on 22/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationCell.h"
#import "SigninViewController.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson4.h"
#import "TSMessage.h"
#import "TSMessageView.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController {
    // Private
    NSArray *jsonArray;
}

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

    [TSMessage setDefaultViewController:self];

    jsonArray = nil;

    // Show login
    if ([SigninViewController getConnected] == 0)
        [self performSegueWithIdentifier:@"showLogin" sender:self];

    [self loadAll];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    return [jsonArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemNotificationCell";
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *current = [jsonArray objectAtIndex:indexPath.row];
    // Data
    cell.textLabel.text = [current objectForKey:@"user"];
    cell.info = [current objectForKey:@"info"];
    cell.course = [current objectForKey:@"course"];
    cell.filename = [current objectForKey:@"filename"];
    cell.datetime = [current objectForKey:@"datetime"];

    return cell;
}

- (void)loadAll
{
    NSURL *url = [NSURL URLWithString:@"http://env-9374575.jelastic.lunacloud.com/apptest/notifications.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
    if (request.responseStatusCode == 400) {
        // 400
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Notification", nil)
                                    subtitle:NSLocalizedString(@"Invalid code", nil)
                                        type:TSMessageNotificationTypeError];
    }
    else if (request.responseStatusCode == 403) {
        // 403
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Notification", nil)
                                    subtitle:NSLocalizedString(@"Code already used", nil)
                                        type:TSMessageNotificationTypeError];
    }
    else if (request.responseStatusCode == 200) {
        // OK
        NSData *responseData = [request responseData];
        // JSON
        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];

        if ([jsonObject isKindOfClass:[NSArray class]]) {
            // Type: array
            jsonArray = (NSArray *)jsonObject;
        } else {
            // Type: dictionary
            NSDictionary *jsonDictionary = (NSDictionary*)jsonObject;
            // Type: array
            jsonArray = [jsonDictionary objectForKey:@"notifications"];
            // When finished:
            [self.tableView reloadData];
        }
    }
    else {
        // Unexpected
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Notification", nil)
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
