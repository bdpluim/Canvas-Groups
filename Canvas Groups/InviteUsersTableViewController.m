//
//  InviteUsersTableViewController.m
//  Canvas Groups
//
//  Created by Rick Roberts on 12/4/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "InviteUsersTableViewController.h"
#import <CanvasKit.h>
#import "CanvasKitManager.h"

@interface InviteUsersTableViewController ()
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSMutableArray *groupUsers;
@property (nonatomic, strong) NSMutableDictionary *usersDictionary;
@end

@implementation InviteUsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.users = [NSMutableArray array];
    self.groupUsers = [NSMutableArray array];
    self.usersDictionary = [NSMutableDictionary dictionary];
    
    [[[[CanvasKitManager sharedInstance] client] fetchGroupUsersForContext:self.group] subscribeNext:^(NSArray *users) {
        
        [users enumerateObjectsUsingBlock:^(CKIUser *user, NSUInteger idx, BOOL *stop) {
            [self.groupUsers addObject:user.id];
        }];
        
        [[[[CanvasKitManager sharedInstance] client] fetchCoursesForCurrentUser] subscribeNext:^(NSArray *courses) {
            
            [courses enumerateObjectsUsingBlock:^(CKICourse *course, NSUInteger idx, BOOL *stop) {
                [[[[CanvasKitManager sharedInstance] client] fetchUsersForContext:course] subscribeNext:^(NSArray *users) {
                    [users enumerateObjectsUsingBlock:^(CKIUser *user, NSUInteger idx, BOOL *stop) {
                        if (!self.usersDictionary[user.id]) {
                            self.usersDictionary[user.id] = user;
                            self.users = [self.usersDictionary.allValues mutableCopy];
                            [self.tableView reloadData];
                        } else {
                            NSLog(@"We have that user already: %@", user.name);
                        }
                    }];
                }];
            }];
            
        }];
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    // Configure the cell...
    CKIUser *user = self.users[indexPath.row];
    cell.textLabel.text = user.name;
    
    if ([self.groupUsers containsObject:user.id]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CKIUser *user = self.users[indexPath.row];
    [[[[CanvasKitManager sharedInstance] client] createGroupMemebershipForUser:user.id inGroup:self.group] subscribeNext:^(id x) {
        NSLog(@"Done");
    } error:^(NSError *error) {
        NSLog(@"ERROR: %@", error.localizedDescription);
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
