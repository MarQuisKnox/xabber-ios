//
// Created by Dmitry Sobolev on 12/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBAccountManager;
@class XBAccount;
@protocol XBAccountsControllerDelegate;


@interface XBAccountsController : NSObject

@property (nonatomic, strong) XBAccountManager *accountManager;
@property (nonatomic, weak) id <XBAccountsControllerDelegate> delegate;

- (instancetype)initWithAccountManager:(XBAccountManager *)accountManager;

+ (instancetype)controllerWithAccountManager:(XBAccountManager *)accountManager;

- (NSUInteger)numberOfAccounts;

- (BOOL)isAccountIndexPath:(NSIndexPath *)indexPath;

- (XBAccount *)accountWithIndexPath:(NSIndexPath *)indexPath;

- (BOOL)deleteAccountInIndexPath:(NSIndexPath *)indexPath;

@end

@protocol XBAccountsControllerDelegate <NSObject>

- (void)controllerDidChange:(XBAccountsController *)controller;

@end