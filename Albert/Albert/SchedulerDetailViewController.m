//
//  SchedulerDetailViewController.m
//  Albert
//
//  Created by Ricardo Pereira on 22/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "SchedulerDetailViewController.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson4.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "MBProgressHUD.h"

#import "FileCell.h"

@interface SchedulerDetailViewController ()

@end

@implementation SchedulerDetailViewController

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
    // Info
    [self.filesView setDelegate: self];
    [self.filesView setDataSource: self];

    id object = [self.info objectForKey:@"filesCount"];

    //NSLog(@"%@",[[object class] description]);

    if (object != [NSNull null]) {
        self.labelTest.text = [NSString stringWithFormat:@"Files count: %@",(NSNumber*)[self.info objectForKey:@"filesCount"]];

        self.filesArray = [self.info objectForKey:@"files"];
        [self.filesView reloadData];
    }
    else
        self.labelTest.text = @"No data";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"fileCell";
    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSArray *current = [self.filesArray objectAtIndex:indexPath.row];
    // Data
    cell.textLabel.text = [current valueForKey:@"name"];
    cell.info = [current valueForKey:@"name"];
    cell.url = [current valueForKey:@"url"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // File
    NSArray *current = [self.filesArray objectAtIndex:indexPath.row];

    self.fileURL = [NSURL URLWithString:[current valueForKey:@"url"]];

    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    // Here you'll _probably_ want to use a filename that's got the correct extension...but YMMV
    self.cacheURL = [NSURL fileURLWithPath:[[paths objectAtIndex:0] stringByAppendingPathComponent: @"current.pdf"]];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:self.fileURL];
    [request setDownloadDestinationPath:[self.cacheURL path]];
    // Yup. You could optimize here if needed...
    //[request startSynchronous];

    [request setDelegate:self];
    [request startAsynchronous];

    // Add right before return TRUE in textFieldShouldReturn
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Downloading...";
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Add at start of requestFinished AND requestFailed
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    // Use when fetching text data
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
        //NSString *responseString = [request responseString];

        //creating the object of the QLPreviewController
        QLPreviewController *previewController = [[QLPreviewController alloc] init];

        //settnig the datasource property to self
        previewController.dataSource = self;

        //pusing the QLPreviewController to the navigation stack
        [[self navigationController] pushViewController:previewController animated:YES];
    }
    else {
        // Unexpected
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Scheduler", nil)
                                    subtitle:NSLocalizedString(@"Unexpected error", nil)
                                        type:TSMessageNotificationTypeError];
    }

    // Use when fetching binary data
    //NSData *responseData = [request responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [TSMessage showNotificationWithTitle:NSLocalizedString(@"Connection", nil)
                                subtitle:NSLocalizedString(error.description, nil)
                                    type:TSMessageNotificationTypeError];
}

#pragma mark QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController*)previewController previewItemAtIndex:(NSInteger)idx
{
    return self.cacheURL;
}

@end
