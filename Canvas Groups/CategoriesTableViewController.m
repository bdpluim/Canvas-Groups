//
//  CategoriesTableViewController.m
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/8/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "CategoriesTableViewController.h"

#import <CanvasKit/CanvasKit.h>

#import "CanvasKitManager.h"
#import "GroupsTableViewController.h"


@interface CategoriesTableViewController ()

@property (nonatomic, strong) NSArray *categories;

@end

@implementation CategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", NSStringFromClass(self.class));
    
    [[[[CanvasKitManager sharedInstance] client] fetchGroupCategoriesForCourse:self.course] subscribeNext:^(NSArray *categories) {
        NSLog(@"Fetched a Single Page of Categories");
        
        self.categories = [categories mutableCopy];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [self showAlertWithTitle:@"ERROR FETCHING CATEGORIES" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
    } completed:^{
        NSLog(@"Finished Fetching Categories");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];

    CKIGroupCategory *course = self.categories[indexPath.row];
    cell.textLabel.text = course.name;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CKIGroupCategory *category = self.categories[[self.tableView indexPathForSelectedRow].row];
    
    GroupsTableViewController *controller = segue.destinationViewController;
    controller.course = self.course;
    controller.category = category;
}

#pragma mark - Alerts

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
