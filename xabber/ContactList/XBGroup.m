//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBGroup.h"
#import "XBContact.h"

@interface XBGroup () {
}
@end


@implementation XBGroup

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }

    return self;
}

#pragma mark Equality

- (void)addToContact:(XBContact *)contact {
    [contact addGroup:self];
}

- (void)removeFromContact:(XBContact *)contact {
    [contact removeGroup:self];
}


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
    if (self.name != group.name && ![self.name isEqualToString:group.name])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return [self.name hash];
}

@end