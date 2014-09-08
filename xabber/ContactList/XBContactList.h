//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBAccount;
@class XBGroup;
@class XBContact;
@class XMPPRosterCoreDataStorage;


@interface XBContactList : NSObject

@property(nonatomic, weak) XMPPRosterCoreDataStorage *storage;

- (instancetype)initWithStorage:(XMPPRosterCoreDataStorage *)storage;

- (NSArray *)contacts;

- (NSArray *)groups;

+ (instancetype)contactListWithStorage:(XMPPRosterCoreDataStorage *)storage;

@end