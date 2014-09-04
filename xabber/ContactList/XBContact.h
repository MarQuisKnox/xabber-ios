//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "XBAccount.h"

@class XBGroup;


@interface XBContact : NSObject

@property (nonatomic, strong) NSString *contactID;

@property (nonatomic, strong) NSString *contactName;

@property (nonatomic, assign) BOOL isOnline;

@property (nonatomic, assign) XBAccountStatus status;

@property (nonatomic, strong) NSString *statusText;

@property (nonatomic, strong) XBAccount *account;

@property (nonatomic, readonly) NSArray *groups;

- (void)addGroup:(XBGroup *)group;

- (void)removeGroup:(XBGroup *)group;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToContact:(XBContact *)contact;

- (NSUInteger)hash;

@end