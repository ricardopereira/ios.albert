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
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    switch (section)
    {
        case 0:
            return [jsonArray count];
            break;
        case 1:
            return [jsonArray count];
            break;
        case 2:
            return [jsonArray count];
            break;
        case 3:
            return [jsonArray count];
            break;
        case 4:
            return [jsonArray count];
            break;
        case 5:
            return 0;
            break;
        case 6:
            return 0;
            break;
            // ...
        default:
            return [jsonArray count];
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    SchedulerEventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *current = [jsonArray objectAtIndex:indexPath.row];
    // Data
    //cell.textLabel.text = [current objectForKey:@"name"];
    UILabel *innerName = (UILabel *)[cell.contentView viewWithTag:10];
    [innerName setText:[current objectForKey:@"name"]];

    UIColor *colorAlbert = [UIColor colorWithRed:101/255.0 green:44/255.0 blue:144/255.0 alpha:1.0];

    UILabel *innerInfo = (UILabel *)[cell.contentView viewWithTag:11];
    [innerInfo setText:[current objectForKey:@"info"]];
    innerInfo.textColor = colorAlbert;

    UILabel *innerTime = (UILabel *)[cell.contentView viewWithTag:12];
    [innerTime setText:[current objectForKey:@"time"]];

    cell.info = [current objectForKey:@"info"];

    NSArray* files = [current objectForKey:@"files"];

    //NSLog(@"%@",[[object class] description]);

    cell.numberOfFiles = [files count];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Segunda";
            break;
        case 1:
            sectionName = @"Terça";
            break;
        case 2:
            sectionName = @"Quarta";
            break;
        case 3:
            sectionName = @"Quinta";
            break;
        case 4:
            sectionName = @"Sexta";
            break;
        case 5:
            sectionName = @"Sábado";
            break;
        case 6:
            sectionName = @"Domingo";
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
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
