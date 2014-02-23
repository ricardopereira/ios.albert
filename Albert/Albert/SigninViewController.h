//
//  SigninViewController.h
//  Albert
//
//  Created by Ricardo Pereira on 22/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface SigninViewController : UIViewController {
    
}

+ (int) getConnected;
+ (void) setConnected:(int)value;

+ (NSString*)getUser;
+ (void)setUser:(NSString*)newUser;

+ (NSString*)getEmail;
+ (void)setEmail:(NSString*)newEmail;

@property (strong, nonatomic) IBOutlet UINavigationItem *barMain;

@property (strong, nonatomic) IBOutlet UITextField *editUser;
@property (strong, nonatomic) IBOutlet UITextField *editPassword;

@property (strong, nonatomic) IBOutlet UIButton *buttonLogIn;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@end
