//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBContact.h"
#import "XBGroup.h"

@interface XBContact() {
    NSMutableArray *_groups;
}
@end


@implementation XBContact
- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }

    return self;
}


- (void)commonInit {
    _groups = [NSMutableArray array];
}

- (NSArray *)groups {
    return _groups;
}

- (void)addGroup:(XBGroup *)group {
    if (![self.groups containsObject:group]) {
        [_groups addObject:group];
    }
}

- (void)removeGroup:(XBGroup *)group {
    if ([self.groups containsObject:group]) {
        [_groups removeObject:group];
    }
}

#pragma mark Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToContact:other];
}

- (BOOL)isEqualToContact:(XBContact *)contact {
    if (self == contact)
        return YES;
    if (contact == nil)
        return NO;
    if (self.contactID != contact.contactID && ![self.contactID isEqualToString:contact.contactID])
        return NO;
    if (self.contactName != contact.contactName && ![self.contactName isEqualToString:contact.contactName])
        return NO;
    if (self.isOnline != contact.isOnline)
        return NO;
    if (self.status != contact.status)
        return NO;
    if (self.statusText != contact.statusText && ![self.statusText isEqualToString:contact.statusText])
        return NO;
    if (self.account != contact.account && ![self.account isEqualToAccount:contact.account])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.contactID hash];
    hash = hash * 31u + [self.contactName hash];
    hash = hash * 31u + self.isOnline;
    hash = hash * 31u + (NSUInteger) self.status;
    hash = hash * 31u + [self.statusText hash];
    hash = hash * 31u + [self.account hash];
    return hash;
}

@end