//
// Created by Dmitry Sobolev on 18/08/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBAccountManager.h"
#import "XBXMPPCoreDataAccount.h"
#import "XBXMPPConnector.h"
#import "XBAccount.h"

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

        [self postNotificationWithName:XBAccountManagerAccountAdded account:account];
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

        [self postNotificationWithName:XBAccountManagerAccountDeleted account:account];
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
        if (account.state == XBConnectionStateOffline) {
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

- (void)postNotificationWithName:(NSString *)notificationName account:(XBAccount *)account {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil
                                                          userInfo:@{@"account": account}];
    });
}

@end