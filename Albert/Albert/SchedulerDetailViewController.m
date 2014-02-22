//
//  SchedulerDetailViewController.m
//  Albert
//
//  Created by Ricardo Pereira on 22/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "SchedulerDetailViewController.h"

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
    id object = [self.info objectForKey:@"thumbnail"];
    if (object != [NSNull null])
        self.labelTest.text = [self.info objectForKey:@"thumbnail"];
    else
        self.labelTest.text = @"No data";
}

@end
