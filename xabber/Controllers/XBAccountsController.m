//
// Created by Dmitry Sobolev on 12/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBAccountsController.h"
#import "XBAccountManager.h"
#import "XBAccount.h"


@implementation XBAccountsController

- (instancetype)initWithAccountManager:(XBAccountManager *)accountManager {
    self = [super init];
    if (self) {
        self.accountManager = accountManager;
        [self setObservers];
    }

    return self;
}

+ (instancetype)controllerWithAccountManager:(XBAccountManager *)accountManager {
    return [[self alloc] initWithAccountManager:accountManager];
}

- (NSUInteger)numberOfAccounts {
    return self.accountManager.accounts.count;
}

- (BOOL)isAccountIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 && indexPath.row < self.numberOfAccounts;
}

- (XBAccount *)accountWithIndexPath:(NSIndexPath *)indexPath {
    if ([self isAccountIndexPath:indexPath]) {
        return self.accountManager.accounts[(NSUInteger)indexPath.row];
    }

    return nil;
}

- (BOOL)deleteAccountInIndexPath:(NSIndexPath *)indexPath {
    XBAccount *account = [self accountWithIndexPath:indexPath];

    if (account) {
        [self.accountManager deleteAccount:account];
        return YES;
    }

    return NO;
}

#pragma mark Observers

- (void)setObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanges:) name:XBAccountFieldValueChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanges:) name:XBAccountConnectionStateChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanges:) name:XBAccountSaved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanges:) name:XBAccountManagerAccountAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanges:) name:XBAccountManagerAccountDeleted object:nil];
}

- (void)accountChanges:(NSNotification *)notification {
    if ([self.delegate respondsToSelector:@selector(controllerDidChange:)]) {
        [self.delegate controllerDidChange:self];
    }
}


@end