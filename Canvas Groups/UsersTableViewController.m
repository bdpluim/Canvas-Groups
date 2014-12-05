//
//  UsersTableViewController.m
//  Canvas Groups
//
//  Created by Rick Roberts on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "UsersTableViewController.h"
#import "CanvasKitManager.h"
#import "InviteUsersTableViewController.h"

@interface UsersTableViewController ()
@property (nonatomic, strong) NSArray *users;
@end

@implementation UsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[[[CanvasKitManager sharedInstance] client] fetchGroupUsersForContext:self.group] subscribeNext:^(id users) {
        self.users = users;
        [self.tableView reloadData];
    }];
    
    self.title = self.group.name;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCellIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    CKIUser *user = self.users[indexPath.row];
    cell.textLabel.text = user.name;
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (IBAction)addUserButtonTouched:(id)sender {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:@"Enter the email for the person you would like to invite." preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"example@email.com";
    }];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Send Invite" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        UITextField *emailField = controller.textFields[0];
        [[[[CanvasKitManager sharedInstance] client] inviteUser:emailField.text toGroup:self.group] subscribeNext:^(id x) {
            NSLog(@"Success");
        } error:^(NSError *error) {
            NSLog(@"Failure");
        }];
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    InviteUsersTableViewController *inviteController = segue.destinationViewController;
    inviteController.group = self.group;
}


@end
