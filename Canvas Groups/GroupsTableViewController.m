//
//  GroupsTableViewController.m
//  Canvas Groups
//
//  Created by Rick Roberts on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "GroupsTableViewController.h"
#import "CanvasKitManager.h"
#import "UsersTableViewController.h"
#import "NewGroupViewController.h"

@interface GroupsTableViewController () <NewGroupViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation GroupsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[[[CanvasKitManager sharedInstance] client] fetchGroupsForContext:self.course] subscribeNext:^(NSArray *groups) {
        self.groups = [groups mutableCopy];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"Error finding groups for course");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Input

- (IBAction)addGroupButtonTouched:(UIButton *)sender {
    // Show add group UI
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCellIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    CKIGroup *group = self.groups[indexPath.row];
    cell.textLabel.text = group.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CKIGroup *group = self.groups[indexPath.row];
    [[[[CanvasKitManager sharedInstance] client] deleteGroup:group] subscribeNext:^(id x) {
        NSLog(@"Success");
        [self showAlertWithTitle:@"Success!" message:@"Groups was deleted."];
    } error:^(NSError *error) {
        NSLog(@"Failure");
        [self showAlertWithTitle:@"Failure :(" message:@"Could not delete the group"];
    }];
    
    [self.tableView beginUpdates];
    [self.groups removeObject:group];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
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

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)shouldSaveNewGroup:(CKIGroup *)group {
    group.joinLevel = CKIGroupJoinLevelInvitationOnly;
    [[[[CanvasKitManager sharedInstance] client] createGroup:group] subscribeNext:^(CKIGroup *newGroup) {
        [self.groups addObject:newGroup];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [self showAlertWithTitle:@"Error!" message:@"Something happened and I don't think your group was created :("];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GroupSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CKIGroup *selectedGroup = self.groups[indexPath.row];
        UsersTableViewController *usersController = segue.destinationViewController;
        usersController.group = selectedGroup;
    } else {
        UINavigationController *navController = segue.destinationViewController;
        NewGroupViewController *controller = navController.viewControllers[0];
        controller.delegate = self;
    }
}


@end
