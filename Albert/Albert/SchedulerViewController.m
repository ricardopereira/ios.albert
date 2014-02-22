//
//  SchedulerViewController.m
//  Albert
//
//  Created by Ricardo Pereira on 22/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "SchedulerViewController.h"
#import "SchedulerEventCell.h"
#import "SchedulerDetailViewController.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson4.h"
#import "TSMessage.h"
#import "TSMessageView.h"

@interface SchedulerViewController ()

@end

@implementation SchedulerViewController {
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

    [self loadAll];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    // Return the number of rows in the section
    return [jsonArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    SchedulerEventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *current = [jsonArray objectAtIndex:indexPath.row];
    // Data
    cell.textLabel.text = [current objectForKey:@"name"];
    cell.info = [current objectForKey:@"info"];

    NSArray* files = [current objectForKey:@"files"];

    //NSLog(@"%@",[[object class] description]);

    cell.numberOfFiles = [files count];

    return cell;
}

- (IBAction)didTouchLoad:(id)sender
{
    [self loadAll];
}

- (void)loadAll
{
    NSURL *url = [NSURL URLWithString:@"http://env-9374575.jelastic.lunacloud.com/apptest/schedule.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"call" forKey:@"getScheduler"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
    if (request.responseStatusCode == 400) {
        // 400
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Scheduler", nil)
                                    subtitle:NSLocalizedString(@"Invalid code", nil)
                                        type:TSMessageNotificationTypeError];
    }
    else if (request.responseStatusCode == 403) {
        // 403
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Scheduler", nil)
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
            jsonArray = [jsonDictionary objectForKey:@"courses"];
            // When finished:
            [self.tableView reloadData];
        }
    }
    else {
        // Unexpected
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Scheduler", nil)
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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEventDetail"]) {
        // Detail
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SchedulerDetailViewController *detailVC = (SchedulerDetailViewController*)segue.destinationViewController;

        detailVC.info = [jsonArray objectAtIndex:indexPath.row];
    }
}

@end
