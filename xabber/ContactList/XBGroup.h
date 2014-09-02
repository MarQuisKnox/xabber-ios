//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBContact;


@interface XBGroup : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, readonly) NSArray *contacts;

- (instancetype)initWithName:(NSString *)name;

- (void)addContact:(XBContact *)contact;

- (void)removeContact:(XBContact *)contact;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToGroup:(XBGroup *)group;

- (NSUInteger)hash;

@end