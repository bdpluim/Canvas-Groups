//
//  NewGroupViewController.h
//  Canvas Groups
//
//  Created by Rick Roberts on 12/4/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKIGroup;
@class CKICourse;
@class CKIGroupCategory;

@protocol NewGroupViewControllerDelegate;

@interface NewGroupViewController : UIViewController

@property (nonatomic, weak) id<NewGroupViewControllerDelegate> delegate;
@property (nonatomic, strong) CKIGroup *group;
@property (nonatomic, strong) CKIGroupCategory *category;

@end

@protocol NewGroupViewControllerDelegate <NSObject>

- (void)newGroupCreated:(CKIGroup *)group;

@end
