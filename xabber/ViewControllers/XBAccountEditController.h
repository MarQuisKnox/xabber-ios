//
//  XBAccountEditController.h
//  xabber
//
//  Created by Dmitry Sobolev on 08/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBAccount;

@interface XBAccountEditController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UISwitch *autoLogin;

@property (weak, nonatomic) IBOutlet UITextField *hostname;
@property (weak, nonatomic) IBOutlet UITextField *port;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) XBAccount *account;

- (IBAction)editDone:(UIBarButtonItem *)sender;
- (IBAction)editCancel:(UIBarButtonItem *)sender;

- (IBAction)fieldChanged:(id)sender;
@end
