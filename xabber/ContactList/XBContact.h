//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "XBAccount.h"

@class XBGroup;
@class XMPPUserCoreDataStorageObject;

typedef enum {
    XBContactStatusAvailable,
    XBContactStatusChat,
    XBContactStatusAway,
    XBContactStatusXA,
    XBContactStatusDnD,
    XBContactStatusUnavailable,
} XBContactStatus;

@interface XBContact : NSObject

@property (nonatomic, readonly) NSString *contactName;

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) XBContactStatus status;

@property (nonatomic, readonly) NSString *statusText;

@property (nonatomic, readonly, weak) XBAccount *account;

- (instancetype)initWithXMPPUser:(XMPPUserCoreDataStorageObject *)user;

- (NSSet *)groups;

- (void)updateContactWithXMPPUser:(XMPPUserCoreDataStorageObject *)user;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToContact:(XBContact *)contact;

- (NSUInteger)hash;

@end