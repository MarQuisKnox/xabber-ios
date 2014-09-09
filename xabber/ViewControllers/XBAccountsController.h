//
//  XBAccountsController.h
//  xabber
//
//  Created by Dmitry Sobolev on 08/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBAccountManager;

@interface XBAccountsController : UITableViewController

@property (nonatomic, strong) XBAccountManager *accountManager;

- (IBAction)closeAccounts:(id)sender;
@end
