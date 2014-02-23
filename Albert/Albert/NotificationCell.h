//
//  NotificationCell.h
//  Albert
//
//  Created by Ricardo Pereira on 23/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell

@property (nonatomic, strong) NSNumber* type;
@property (nonatomic, strong) NSString* user;
@property (nonatomic, strong) NSString* course;
@property (nonatomic, strong) NSString* datetime;
@property (nonatomic, strong) NSString* filename;
@property (nonatomic, strong) NSString* info;

@end
