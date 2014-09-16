//
// Created by Dmitry Sobolev on 22/08/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "XBTypes.h"

@class XBXMPPCoreDataAccount;
@class XBXMPPConnector;
@class XMPPStream;

@protocol XBXMPPConnectorDelegate;


static NSString *const XBAccountFieldValueChanged = @"XBAccountFieldValueChanged";
static NSString *const XBAccountSaved = @"XBAccountSaved";
static NSString *const XBAccountConnectionStateChanged = @"XBAccountConnectionStateChanged";

@interface XBAccount : NSObject <XBXMPPConnectorDelegate>

@property (nonatomic, strong) NSString *accountJID;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL autoLogin;
@property (nonatomic, assign) XBAccountStatus status;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) NSUInteger port;

@property (nonatomic, readonly) BOOL isNew;
@property (nonatomic, readonly) BOOL isDeleted;

@property (nonatomic, readonly) XMPPStream *stream;

- (instancetype)initWithConnector:(XBXMPPConnector *)connector coreDataAccount:(XBXMPPCoreDataAccount *)account;

- (instancetype)initWithConnector:(XBXMPPConnector *)connector;

+ (instancetype)accountWithConnector:(XBXMPPConnector *)connector;

+ (instancetype)accountWithConnector:(XBXMPPConnector *)connector coreDataAccount:(XBXMPPCoreDataAccount *)account;

- (BOOL)save;

- (BOOL)delete;

- (void)login;

- (void)logout;

- (BOOL)isValid;

- (XBConnectionState)state;

#pragma mark Equality

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToAccount:(XBAccount *)account;

- (NSUInteger)hash;

@end
