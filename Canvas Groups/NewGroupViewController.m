//
//  NewGroupViewController.m
//  Canvas Groups
//
//  Created by Rick Roberts on 12/4/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "NewGroupViewController.h"

@interface NewGroupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isPublicSwitch;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@end

@implementation NewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.group = [[CKIGroup alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveTouched:(id)sender {
    self.group.name = self.nameTextField.text;
    self.group.isPublic = self.isPublicSwitch.isOn;
    self.group.groupDescription = self.descriptionTextView.text;
    [self.delegate shouldSaveNewGroup:self.group];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
