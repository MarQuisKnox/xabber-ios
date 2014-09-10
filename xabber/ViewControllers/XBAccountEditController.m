//
//  XBAccountEditController.m
//  xabber
//
//  Created by Dmitry Sobolev on 08/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBAccountEditController.h"
#import "XBAccount.h"
#import "XBAccountManager.h"

@interface XBAccountEditController ()

@end

@implementation XBAccountEditController

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

    if (self.account.isNew) {
        self.title = NSLocalizedString(@"ui: new account", @"New account");
    }

    self.doneButton.enabled = self.account.isValid;

    [self loadFromAccount];
}

- (void)dealloc {
    self.account = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editDone:(UIBarButtonItem *)sender {
    BOOL isNewAccount = self.account.isNew;

    [self.account save];

    if (isNewAccount) {
        [[XBAccountManager sharedInstance] addAccount:self.account];
    }

    [self dismiss];
}

- (IBAction)editCancel:(UIBarButtonItem *)sender {
    [self dismiss];
}

- (IBAction)fieldChanged:(id)sender {
    if (sender == self.username) {
        self.account.accountJID = self.username.text;
    }

    if (sender == self.password) {
        self.account.password = self.password.text;
    }

    if (sender == self.autoLogin) {
        self.account.autoLogin = self.autoLogin.isOn;
    }

    if (sender == self.hostname) {
        self.account.host = self.hostname.text;
    }

    if (sender == self.port) {
        self.account.port = (UInt16) [self.port.text intValue];
    }

    self.doneButton.enabled = self.account.isValid;
}

#pragma mark Private

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadFromAccount {
    self.username.text = self.account.accountJID;
    self.password.text = self.account.password;
    self.autoLogin.on = self.account.autoLogin;
    self.hostname.text = self.account.host;
    self.port.text = [NSString stringWithFormat:@"%d", self.account.port];
}

@end
