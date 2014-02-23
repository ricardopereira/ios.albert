//
//  AccountViewController.m
//  Albert
//
//  Created by Ricardo Pereira on 22/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "AccountViewController.h"

#import "SigninViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

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

    UIColor *colorAlbert = [UIColor colorWithRed:101/255.0 green:44/255.0 blue:144/255.0 alpha:1.0];

    self.view.backgroundColor = colorAlbert;
    self.viewUser.backgroundColor = colorAlbert;
    self.labelUser.backgroundColor = colorAlbert;
    self.labelUser.textColor = [UIColor whiteColor];
    self.labelUser.text = [SigninViewController getUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
