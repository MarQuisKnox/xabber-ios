//
//  XBAccountsViewController.m
//  xabber
//
//  Created by Dmitry Sobolev on 08/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBAccountsViewController.h"
#import "XBAccountEditViewController.h"
#import "XBAccount.h"
#import "XBXMPPConnector.h"
#import "XBAccountManager.h"
#import "XBAccountsController.h"

@interface XBAccountsViewController ()

@end

@implementation XBAccountsViewController

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
    
    self.accountsController = [XBAccountsController controllerWithAccountManager:[XBAccountManager sharedInstance]];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountManagerChanged:)
                                                 name:XBAccountManagerAccountAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountManagerChanged:)
                                                 name:XBAccountManagerAccountChanged object:nil];
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
    return self.accountsController.numberOfAccounts + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellReusableIdentifier:indexPath]
                                                            forIndexPath:indexPath];

    if ([self.accountsController isAccountIndexPath:indexPath]) {
        XBAccount *account = [self.accountsController accountWithIndexPath:indexPath];
        cell.textLabel.text = account.accountJID;
        cell.detailTextLabel.text = [self stateLabelByAccount:account];
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.accountsController isAccountIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.accountsController isAccountIndexPath:indexPath]) {
            [self removeAccountFromTableView:tableView indexPath:indexPath];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing && [self.accountsController isAccountIndexPath:indexPath]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"edit_account" sender:cell];
        self.tableView.editing = NO;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"new_account"]) {
        UINavigationController *controller = segue.destinationViewController;
        XBAccountEditViewController *editController = (XBAccountEditViewController *) controller.topViewController;
        editController.account = [XBAccount accountWithConnector:[[XBXMPPConnector alloc] init]];
    }

    if ([segue.identifier isEqualToString:@"edit_account"]) {
        UINavigationController *controller = segue.destinationViewController;
        XBAccountEditViewController *editController = (XBAccountEditViewController *) controller.topViewController;

        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        XBAccount *account = [self.accountsController accountWithIndexPath:indexPath];

        editController.account = account;
    }
}

#pragma mark Actions

- (IBAction)closeAccounts:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)accountManagerChanged:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark Private

- (void)removeAccountFromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [self.accountsController deleteAccountInIndexPath:indexPath];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSString *)cellReusableIdentifier:(NSIndexPath *)indexPath {
    if ([self.accountsController isAccountIndexPath:indexPath]) {
        return @"accountCell";
    }

    return @"newAccountCell";
}

- (NSString *)stateLabelByAccount:(XBAccount *)account {
    NSString *labelText = nil;

    switch (account.state) {
        case XBConnectionStateOffline:
            labelText = @"Offline";
            break;
        case XBConnectionStateConnecting:
            labelText = @"Connecting...";
            break;
        case XBConnectionStateOnline:
            labelText = @"Online";
            break;
        case XBConnectionStateDisconnecting:
            labelText = @"Disconnecting...";
            break;
        default:
            labelText = @"";
    }

    return labelText;
}

@end
