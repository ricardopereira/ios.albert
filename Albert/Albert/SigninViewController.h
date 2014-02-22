//
//  SigninViewController.h
//  Albert
//
//  Created by Ricardo Pereira on 22/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationItem *barMain;

@property (strong, nonatomic) IBOutlet UITextField *editUser;
@property (strong, nonatomic) IBOutlet UITextField *editPassword;

@property (strong, nonatomic) IBOutlet UIButton *buttonLogIn;

@end
