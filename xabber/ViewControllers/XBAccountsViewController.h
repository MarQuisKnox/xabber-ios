//
//  XBAccountsViewController.h
//  xabber
//
//  Created by Dmitry Sobolev on 08/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBAccountManager;
@class XBAccountsController;

@interface XBAccountsViewController : UITableViewController

@property (nonatomic, strong) XBAccountsController *accountsController;

- (IBAction)closeAccounts:(id)sender;
@end
