//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBGroup;


@interface XBContact : NSObject

@property (nonatomic, strong) NSString *contactID;

@property (nonatomic, readonly) NSArray *groups;

- (void)addGroup:(XBGroup *)group;

- (void)removeGroup:(XBGroup *)group;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToContact:(XBContact *)contact;

- (NSUInteger)hash;

@end