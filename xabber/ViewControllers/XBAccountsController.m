//
//  XBAccountsController.m
//  xabber
//
//  Created by Dmitry Sobolev on 08/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBAccountsController.h"
#import "XBAccountEditController.h"
#import "XBAccount.h"
#import "XBXMPPConnector.h"
#import "XBAccountManager.h"

@interface XBAccountsController ()

@end

@implementation XBAccountsController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.accountManager = [XBAccountManager sharedInstance];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accountManager.accounts.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"accountCell";

    if (indexPath.row == self.accountManager.accounts.count) {
        cellIdentifier = @"newAccountCell";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    if (indexPath.row < self.accountManager.accounts.count) {
        XBAccount *account = self.accountManager.accounts[(NSUInteger) indexPath.row];
        cell.textLabel.text = account.accountJID;
        cell.detailTextLabel.text = account.isLoggedIn ? @"Online": @"Offline";
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.accountManager.accounts.count) {
        return NO;
    }
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing && indexPath.row < self.accountManager.accounts.count) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"edit_account" sender:cell];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"new_account"]) {
        UINavigationController *controller = segue.destinationViewController;
        XBAccountEditController *editController = (XBAccountEditController *) controller.topViewController;
        editController.account = [XBAccount accountWithConnector:[[XBXMPPConnector alloc] init]];
    }

    if ([segue.identifier isEqualToString:@"edit_account"]) {
        UINavigationController *controller = segue.destinationViewController;
        XBAccountEditController *editController = (XBAccountEditController *) controller.topViewController;

        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        XBAccount *account = self.accountManager.accounts[(NSUInteger) indexPath.row];

        editController.account = account;
    }
}

#pragma mark Actions

- (IBAction)closeAccounts:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
