//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBAccount;
@class XBGroup;
@class XBContact;


@interface XBContactList : NSObject

- (NSArray *)contacts;

- (NSArray *)contactsForAccount:(XBAccount *)account;

- (NSArray *)contactsForGroupWithName:(NSString *)groupName;

- (NSArray *)contactsForGroup:(XBGroup *)group;

- (void)addContact:(XBContact *)contact;

- (void)removeContact:(XBContact *)contact;

- (NSArray *)groups;

- (XBGroup *)groupByName:(NSString *)groupName;

- (void)addGroup:(XBGroup *)group;

- (void)removeGroup:(XBGroup *)group;
@end