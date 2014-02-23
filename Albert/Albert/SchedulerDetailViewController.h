//
//  SchedulerDetailViewController.h
//  Albert
//
//  Created by Ricardo Pereira on 22/02/14.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface SchedulerDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (strong, nonatomic) NSDictionary *info;

@property (strong, nonatomic) IBOutlet UILabel *labelTest;

@property (strong, nonatomic) NSArray * filesArray;
@property (strong, nonatomic) IBOutlet UITableView *filesView;

@property (nonatomic,retain) NSURL *fileURL;
@property (nonatomic,retain) NSURL *cacheURL;

@end
