//
// Created by Dmitry Sobolev on 18/08/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBAccountManager.h"
#import "XBXMPPCoreDataAccount.h"
#import "XBAccount.h"
#import "XBXMPPConnector.h"

@interface XBAccountManager() {
    NSMutableArray *_accounts;
}
@end

@implementation XBAccountManager
- (id)init {
    self = [super init];
    if (self) {
        _accounts = [NSMutableArray array];
        [self loadCachedAccounts];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(accountDidSaved:) name:XBAccountSaved
                                                   object:nil];
    }

    return self;
}

+ (XBAccountManager *)sharedInstance {
    static XBAccountManager *sharedManager = nil;
    static dispatch_once_t once_token;

    dispatch_once(&once_token, ^{
        sharedManager = [[self alloc] init];
    });

    return sharedManager;
}


- (void)addAccount:(XBAccount *)account {
    if (account && !account.isNew) {
        [_accounts addObject:account];

        [self postNotificationWithName:XBAccountManagerAccountAdded];
    }
}

- (void)deleteAccountWithID:(NSString *)accountID {
    XBAccount *account = [self findAccountByJID:accountID];

    [self deleteAccount:account];
}

- (void)deleteAccount:(XBAccount *)account {
    if ([_accounts containsObject:account]) {
        [account delete];
        [_accounts removeObject:account];

        [self postNotificationWithName:XBAccountManagerAccountDeleted];
    }
}

- (NSArray *)accounts {
    return _accounts.copy;
}

- (XBAccount *)findAccountByJID:(NSString *)accountJID {
    return [[_accounts filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(XBAccount *account, NSDictionary *bindings){
        return [account.accountJID isEqualToString:accountJID];
    }]] firstObject];
}

- (void)loginToEnabledAccounts {
    NSPredicate *enabledAccountsPredicate = [NSPredicate predicateWithFormat:@"autoLogin = YES"];

    NSArray *enabledAccounts = [self.accounts filteredArrayUsingPredicate:enabledAccountsPredicate];

    for (XBAccount *account in enabledAccounts) {
        if (!account.isLoggedIn) {
            [account login];
        }
    }
}

#pragma mark Private

- (void)loadCachedAccounts {
    NSArray *coreDataAccounts = [XBXMPPCoreDataAccount MR_findAll];

    [coreDataAccounts enumerateObjectsUsingBlock:^(XBXMPPCoreDataAccount *coreDataAccount, NSUInteger idx, BOOL *stop){
        [self addAccount:[XBAccount accountWithConnector:[[XBXMPPConnector alloc] init]
                                         coreDataAccount:coreDataAccount]];
    }];
}

- (void)accountDidSaved:(NSNotification *)notification {
     XBAccount *account = notification.userInfo[@"account"];

    if ([self.accounts containsObject:account]) {
        [self postNotificationWithName:XBAccountManagerAccountChanged];
    }
}

- (void)postNotificationWithName:(NSString *)notificationName {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
}

@end