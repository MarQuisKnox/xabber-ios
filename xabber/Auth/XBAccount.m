//
// Created by Dmitry Sobolev on 22/08/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>
#import <XMPPFramework/XMPPStream.h>
#import "XBAccount.h"
#import "XBXMPPCoreDataAccount.h"
#import "XBEmailValidator.h"
#import "XBStringLengthValidator.h"
#import "XBMinValueValidator.h"
#import "XBMaxValueValidator.h"
#import "XBXMPPConnector.h"


static NSString *const XBKeychainServiceName = @"xabberService";

@interface XBAccount() {
    XBXMPPConnector *_connector;

    NSString *_accountJID;
    NSString *_password;
    BOOL _autoLogin;
    XBAccountStatus _status;
    NSString *_host;
    NSUInteger _port;

}
- (BOOL)validateAccountJID:(id *)value error:(NSError *__autoreleasing *)error;

- (BOOL)validatePassword:(id *)value error:(NSError *__autoreleasing *)error;

- (BOOL)validateAutoLogin:(id *)value error:(NSError *__autoreleasing *)error;

- (BOOL)validateStatus:(id *)value error:(NSError *__autoreleasing *)error;

- (BOOL)validateHost:(id *)value error:(NSError *__autoreleasing *)error;

- (BOOL)validatePort:(id *)value error:(NSError *__autoreleasing *)error;
@end

@implementation XBAccount

- (NSString *)accountJID {
    return _accountJID;
}

- (void)setAccountJID:(NSString *)accountJID {
    _accountJID = accountJID;

    [self postNotificationWithName:XBAccountFieldValueChanged additionalInfo:@{@"fieldName" : @"accountJID"}];
}

- (NSString *)password {
    return _password;
}

- (void)setPassword:(NSString *)password {
    _password = password;

    [self postNotificationWithName:XBAccountFieldValueChanged additionalInfo:@{@"fieldName" : @"password"}];
}

- (BOOL)autoLogin {
    return _autoLogin;
}

- (void)setAutoLogin:(BOOL)autoLogin {
    _autoLogin = autoLogin;

    [self postNotificationWithName:XBAccountFieldValueChanged additionalInfo:@{@"fieldName" : @"autoLogin"}];
}

- (XBAccountStatus)status {
    return _status;
}

- (void)setStatus:(XBAccountStatus)status {
    _status = status;

    [self postNotificationWithName:XBAccountFieldValueChanged additionalInfo:@{@"fieldName" : @"status"}];
}

- (NSString *)host {
    return _host;
}

- (void)setHost:(NSString *)host {
    _host = host;

    [self postNotificationWithName:XBAccountFieldValueChanged additionalInfo:@{@"fieldName" : @"host"}];
}

- (NSUInteger)port {
    return _port;
}

- (void)setPort:(NSUInteger)port {
    _port = port;

    [self postNotificationWithName:XBAccountFieldValueChanged additionalInfo:@{@"fieldName" : @"port"}];
}

- (XMPPStream *)stream {
    return _connector.xmppStream;
}

- (instancetype)initWithConnector:(XBXMPPConnector *)connector coreDataAccount:(XBXMPPCoreDataAccount *)account {
    self = [super init];
    if (self) {
        _connector = connector;
        _connector.delegate = self;
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

    [self postNotificationWithName:XBAccountSaved additionalInfo:nil];

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
    BOOL success = NO;

    if (account) {
        success = [account MR_deleteEntity];
        if (success) {
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
    }

    return success;
}

- (BOOL)deletePassword {
    if (self.password) {
        return [SSKeychain deletePasswordForService:XBKeychainServiceName account:self.accountJID];
    }

    return YES;
}

#pragma mark Connection

- (void)login {
    NSError *error = nil;

    if ([_connector loginToAccount:self error:&error]) {
        DDLogError(@"Not logged in with error: %@", error);
    }
}

- (void)logout {

    NSError *error = nil;
    if (![_connector logout:&error]) {
        DDLogError(@"Not logged out with error: %@", error);
    }
}

#pragma mark Validation

- (BOOL)isValid {
    NSArray *validatingProperties = @[@"accountJID", @"password", @"autoLogin", @"status", @"host", @"port"];

    NSError *error = nil;

    for (NSString *propertyKeyPath in validatingProperties) {
        id value = [self valueForKeyPath:propertyKeyPath];
        if (![self validateValue:&value forKeyPath:propertyKeyPath error:&error]) {
            return NO;
        }
    }

    return YES;
}

- (XBConnectionState)state {
    return _connector.state;
}


- (BOOL)validateAccountJID:(id *)value error:(NSError * __autoreleasing *)error {
    XBEmailValidator *emailValidator = [[XBEmailValidator alloc] init];

    return [emailValidator validateData:value error:error];
}

- (BOOL)validatePassword:(id *)value error:(NSError * __autoreleasing *)error {
    XBStringLengthValidator *lengthValidator = [XBStringLengthValidator validatorWithMinLength:1];

    return [lengthValidator validateData:value error:error];
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
    if (*value == nil) {
        *value = @0;
    }

    NSArray *validators = @[
            [XBMinValueValidator validatorWithMinValue:1],
            [XBMaxValueValidator validatorWithMaxValue:65536]
    ];

    for (id <XBValidator> validator in validators) {
        if (![validator validateData:value error:error]) {
            return NO;
        }
    }

    return YES;
}

#pragma mark XBXMPPConnectorDelegate

- (void)connector:(XBXMPPConnector *)connector willGoOnlineWithStatus:(XBAccountStatus *)status {
    if ([connector isEqualToConnector:_connector]) {
        *status = self.status;
    }
}

- (void)connectorDidLoginSuccessfully:(XBXMPPConnector *)connector {
    [self postNotificationWithName:XBAccountConnectionStateChanged additionalInfo:nil];
}

- (void)connector:(XBXMPPConnector *)connector didNotLoginWithError:(NSError *)error {
    [self postNotificationWithName:XBAccountConnectionStateChanged additionalInfo:nil];
}

- (void)connector:(XBXMPPConnector *)connector didLogoutWithError:(NSError *)error {
    [self postNotificationWithName:XBAccountConnectionStateChanged additionalInfo:nil];
}


- (void)connector:(XBXMPPConnector *)connector willAuthorizeWithPassword:(NSString **)password {
    if ([connector isEqualToConnector:_connector]) {
        *password = self.password;
    }
}

#pragma mark Private

- (void)setDefaults {
    _status = XBAccountStatusAvailable;
    _autoLogin = YES;
    _port = 5222;
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

- (void)postNotificationWithName:(NSString *)name additionalInfo:(NSDictionary *)additionalInfo {
    NSMutableDictionary *userInfo = [@{@"account" : self} mutableCopy];

    if (additionalInfo) {
        [userInfo addEntriesFromDictionary:additionalInfo];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
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