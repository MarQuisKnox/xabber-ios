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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountUpdated:) name:XBAccountFieldValueChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountUpdated:) name:XBAccountConnectionStateChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountUpdated:) name:XBAccountSaved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountAdded:) name:XBAccountManagerAccountAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountRemoved:) name:XBAccountManagerAccountDeleted object:nil];
}

- (void)accountAdded:(NSNotification *)notification {
    XBAccount *account = notification.userInfo[@"account"];

    NSUInteger position = [self.accountManager.accounts indexOfObject:account];

    if (position != NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];

        [self accountChanged:account atIndexPath:indexPath type:XBAccountAdded];
    }
}

- (void)accountUpdated:(NSNotification *)notification {
    XBAccount *account = notification.userInfo[@"account"];

    NSUInteger position = [self.accountManager.accounts indexOfObject:account];

    if (position != NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];

        [self accountChanged:account atIndexPath:indexPath type:XBAccountUpdated];
    }
}

- (void)accountRemoved:(NSNotification *)notification {
    XBAccount *account = notification.userInfo[@"account"];

    NSNumber *position = notification.userInfo[@"index"];

    if (position) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position.unsignedIntegerValue inSection:0];

        [self accountChanged:account atIndexPath:indexPath type:XBAccountRemoved];
    }
}

- (void)accountChanged:(XBAccount *)account atIndexPath:(NSIndexPath *)indexPath type:(XBAccountChangeType)changeType {
    if ([self.delegate respondsToSelector:@selector(controllerWillChange:)]) {
        [self.delegate controllerWillChange:self];
    }

    if ([self.delegate respondsToSelector:@selector(controller:didChangeAccountAtIndexPath:withType:)]) {
        [self.delegate controller:self didChangeAccountAtIndexPath:indexPath withType:changeType];
    }

    if ([self.delegate respondsToSelector:@selector(controllerDidChange:)]) {
        [self.delegate controllerDidChange:self];
    }
}

@end