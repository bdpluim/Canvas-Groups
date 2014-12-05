//
//  GroupsTableViewController.h
//  Canvas Groups
//
//  Created by Rick Roberts on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CanvasKit.h>

@interface GroupsTableViewController : UITableViewController
@property (nonatomic, strong) CKICourse *course;
@end
