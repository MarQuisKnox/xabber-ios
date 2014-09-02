//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBContact+Private.h"
#import "XBGroup+Private.h"

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
    [self addGroupToList:group];

    [group addContactToList:self];
}

- (void)removeGroup:(XBGroup *)group {
    [self removeGroupFromList:group];

    [group removeContactFromList:self];
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
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [_groups hash];
    hash = hash * 31u + [self.contactID hash];
    return hash;
}

#pragma mark Private

- (void)addGroupToList:(XBGroup *)group {
    [_groups addObject:group];
}

- (void)removeGroupFromList:(XBGroup *)group {
    [_groups removeObject:group];
}
@end