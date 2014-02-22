//
//  SchedulerEventCell.h
//  Albert
//
//  Created by Ricardo Pereira on 22/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import "SchedulerCell.h"

@interface SchedulerEventCell : SchedulerCell

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* url;
@property (nonatomic) NSUInteger numberOfFiles;

@end
