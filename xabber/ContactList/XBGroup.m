//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBGroup+Private.h"
#import "XBContact+Private.h"

@interface XBGroup () {
    NSMutableArray *_contacts;
}
@end


@implementation XBGroup

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    _contacts = [NSMutableArray array];
}


- (NSArray *)contacts {
    return _contacts;
}

- (void)addContact:(XBContact *)contact {
    [self addContactToList:contact];

    [contact addGroupToList:self];
}

- (void)removeContact:(XBContact *)contact {
    [self removeContactFromList:contact];

    [contact removeGroupFromList:self];
}

#pragma mark Private

- (void)addContactToList:(XBContact *)contact {
    [_contacts addObject:contact];
}

- (void)removeContactFromList:(XBContact *)contact {
    [_contacts removeObject:contact];
}

#pragma mark Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToGroup:other];
}

- (BOOL)isEqualToGroup:(XBGroup *)group {
    if (self == group)
        return YES;
    if (group == nil)
        return NO;
    if (_contacts != group->_contacts && ![_contacts isEqualToArray:group->_contacts])
        return NO;
    if (self.name != group.name && ![self.name isEqualToString:group.name])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [_contacts hash];
    hash = hash * 31u + [self.name hash];
    return hash;
}

@end