//
// Created by Dmitry Sobolev on 22/08/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>
#import <XMPPFramework/XMPPStream.h>
#import "XBAccount.h"
#import "XBXMPPCoreDataAccount.h"
#import "XBXMPPConnector.h"


static NSString *const XBKeychainServiceName = @"xabberService";

@interface XBAccount() {
    XBXMPPConnector *_connector;
}
- (BOOL)validateAccountJID:(id *)value error:(NSError *__autoreleasing *)error;

- (BOOL)validatePassword:(id *)value error:(NSError *__autoreleasing *)error;

- (BOOL)validateAutoLogin:(id *)value error:(NSError *__autoreleasing *)error;

- (BOOL)validateStatus:(id *)value error:(NSError *__autoreleasing *)error;

- (BOOL)validateHost:(id *)value error:(NSError *__autoreleasing *)error;

- (BOOL)validatePort:(id *)value error:(NSError *__autoreleasing *)error;
@end

@implementation XBAccount

- (XMPPStream *)stream {
    return _connector.xmppStream;
}

- (instancetype)initWithConnector:(XBXMPPConnector *)connector coreDataAccount:(XBXMPPCoreDataAccount *)account {
    self = [super init];
    if (self) {
        _connector = connector;
        _connector.account = self;
        if (account) {
            [self loadFromCoreDataAccount:account];
            [self loadPasswordWithAccountID:self.accountJID];
            _isNew = NO;
        }
        else {
            [self setDefaults];
            _isNew = YES;
        }
        _isDeleted = NO;
    }

    return self;
}

+ (instancetype)accountWithConnector:(XBXMPPConnector *)connector coreDataAccount:(XBXMPPCoreDataAccount *)account {
    return [[self alloc] initWithConnector:connector coreDataAccount:account];
}

- (instancetype)initWithConnector:(XBXMPPConnector *)connector {
    return [self initWithConnector:connector coreDataAccount:nil];
}

+ (instancetype)accountWithConnector:(XBXMPPConnector *)connector {
    return [[self alloc] initWithConnector:connector];
}

#pragma mark Save

- (BOOL)save {
    if(![self saveCoreData]){
        return NO;
    }

    if(![self savePassword]){
        return NO;
    }

    _isNew = NO;

    return YES;
}

- (BOOL)saveCoreData {
    __block XBXMPPCoreDataAccount *account;

    if (_isNew) {
        account = [XBXMPPCoreDataAccount MR_findFirstByAttribute:@"accountID" withValue:self.accountJID];

        if (account) {
            return NO;
        }
    }

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        account = [XBXMPPCoreDataAccount MR_importFromObject:self.dumpToDictionary inContext:localContext];
    }];

    return account != nil;
}

- (BOOL)savePassword {
    if (!self.password) {
        NSString *oldPassword = [SSKeychain passwordForService:XBKeychainServiceName account:self.accountJID];

        if (!oldPassword) {
            return YES;
        }

        return [SSKeychain deletePasswordForService:XBKeychainServiceName account:self.accountJID];
    }

    return [SSKeychain setPassword:self.password forService:XBKeychainServiceName account:self.accountJID];
}

#pragma mark Load

- (BOOL)loadFromCoreDataAccount:(XBXMPPCoreDataAccount *)account {
    if (!account) {
        return NO;
    }

    self.accountJID = account.accountID;
    self.autoLogin = [account.autoLogin boolValue];
    self.status = (XBAccountStatus) [account.status integerValue];
    self.host = account.host;
    self.port = (UInt16) [account.port integerValue];

    return YES;
}

- (BOOL)loadPasswordWithAccountID:(NSString *)accountID {
    if (!accountID) {
        return NO;
    }

    self.password = [SSKeychain passwordForService:XBKeychainServiceName account:accountID];

    return self.password != nil;
}

#pragma mark Delete

- (BOOL)delete {
    if (![self deleteCoreData]) {
        return NO;
    }

    if (![self deletePassword]) {
        return NO;
    }

    _isDeleted = YES;

    return YES;
}

- (BOOL)deleteCoreData {
    XBXMPPCoreDataAccount *account = [XBXMPPCoreDataAccount MR_findFirstByAttribute:@"accountID" withValue:self.accountJID];

    if (account) {
        return [account MR_deleteEntity];
    }

    return NO;
}

- (BOOL)deletePassword {
    if (self.password) {
        return [SSKeychain deletePasswordForService:XBKeychainServiceName account:self.accountJID];
    }

    return YES;
}

#pragma mark Connection

- (void)login {
    if ([self.delegate respondsToSelector:@selector(accountWillLogin:)]) {
        [self.delegate accountWillLogin:self];
    }

    [_connector loginWithCompletion:^(NSError *error) {
        if (error) {
            if ([self.delegate respondsToSelector:@selector(account:didNotLoginWithError:)]) {
                [self.delegate account:self didNotLoginWithError:error];
            }

            return;
        }

        if ([self.delegate respondsToSelector:@selector(accountDidLoginSuccessfully:)]) {
            [self.delegate accountDidLoginSuccessfully:self];
        }
    }];
}

- (void)logout {
    if ([self.delegate respondsToSelector:@selector(accountWillLogout:)]) {
        [self.delegate accountWillLogout:self];
    }

    if (!_connector.isLoggedIn) {
        [self.delegate account:self
         didNotLogoutWithError:[NSError errorWithDomain:@"xabberErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Account already logged out"}]];
    }

    [_connector logoutWithCompletion:^(NSError *error) {
        if (error) {
            if ([self.delegate respondsToSelector:@selector(account:didNotLogoutWithError:)]) {
                [self.delegate account:self didNotLogoutWithError:error];
            }

            return;
        }

        if ([self.delegate respondsToSelector:@selector(accountDidLogoutSuccessfully:)]) {
            [self.delegate accountDidLogoutSuccessfully:self];
        }
    }];
}

- (BOOL)isLoggedIn {
    return _connector.isLoggedIn;
}

#pragma mark Validation

- (BOOL)isValid {
    NSArray *validatingProperties = @[@"accountJID", @"password", @"autoLogin", @"status", @"host", @"port"];

    for (NSString *propertyKeyPath in validatingProperties) {
        id value = [self valueForKeyPath:propertyKeyPath];
        if (![self validateValue:&value forKeyPath:propertyKeyPath error:nil]) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)validateAccountJID:(id *)value error:(NSError * __autoreleasing *)error {
    if (value == NULL) {
        return NO;
    }

    if (![*value isKindOfClass:[NSString class]]) {
        return NO;
    }

    if ([*value length] == 0) {
        return NO;
    }

    return YES;
}

- (BOOL)validatePassword:(id *)value error:(NSError * __autoreleasing *)error {
    if (value == NULL) {
        return NO;
    }

    if (![*value isKindOfClass:[NSString class]]) {
        return NO;
    }

    if ([*value length] == 0) {
        return NO;
    }

    return YES;
}

- (BOOL)validateAutoLogin:(id *)value error:(NSError * __autoreleasing *)error {
    return YES;
}

- (BOOL)validateStatus:(id *)value error:(NSError * __autoreleasing *)error {
    return YES;
}

- (BOOL)validateHost:(id *)value error:(NSError * __autoreleasing *)error {
    return YES;
}

- (BOOL)validatePort:(id *)value error:(NSError * __autoreleasing *)error {
    return YES;
}

#pragma mark Private

- (void)setDefaults {
    self.status = XBAccountStatusAvailable;
    self.autoLogin = YES;
    self.port = 5222;
}

- (NSDictionary *)dumpToDictionary {
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:5];

    if (self.accountJID) {
        data[@"accountID"] = self.accountJID;
    }

    if (self.autoLogin) {
        data[@"autoLogin"] = @(self.autoLogin);
    }

    if (self.status) {
        data[@"status"] = @(self.status);
    }

    if (self.host) {
        data[@"host"] = self.host;
    }

    if (self.port) {
        data[@"port"] = @(self.port);
    }

    return data;
}

#pragma mark Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToAccount:other];
}

- (BOOL)isEqualToAccount:(XBAccount *)account {
    if (self == account)
        return YES;
    if (account == nil)
        return NO;
    if (self.accountJID != account.accountJID && ![self.accountJID isEqualToString:account.accountJID])
        return NO;
    if (self.password != account.password && ![self.password isEqualToString:account.password])
        return NO;
    if (self.autoLogin != account.autoLogin)
        return NO;
    if (self.status != account.status)
        return NO;
    if (self.host != account.host && ![self.host isEqualToString:account.host])
        return NO;
    if (self.port != account.port)
        return NO;
    if (self.isNew != account.isNew)
        return NO;
    if (self.isDeleted != account.isDeleted)
        return NO;
    if (_connector && account->_connector && ![_connector isEqual:account->_connector])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.accountJID hash];
    hash = hash * 31u + [self.password hash];
    hash = hash * 31u + self.autoLogin;
    hash = hash * 31u + (NSUInteger) self.status;
    hash = hash * 31u + [self.host hash];
    hash = hash * 31u + self.port;
    return hash;
}


@end