//
//  NewGroupViewController.h
//  Canvas Groups
//
//  Created by Rick Roberts on 12/4/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CanvasKit.h>

@protocol NewGroupViewControllerDelegate;

@interface NewGroupViewController : UIViewController
@property (nonatomic, strong) CKIGroup *group;
@property (nonatomic, weak) id <NewGroupViewControllerDelegate> delegate;
@end

@protocol NewGroupViewControllerDelegate <NSObject>

- (void)shouldSaveNewGroup:(CKIGroup *)group;

@end
