//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <XMPPFramework/XMPPUserCoreDataStorageObject.h>
#import <XMPPFramework/XMPPResourceCoreDataStorageObject.h>
#import <XMPPFramework/XMPPGroupCoreDataStorageObject.h>
#import "XBContact.h"
#import "XBAccountManager.h"

@interface XBContact() {
    __weak XBAccount *_account;
}
- (XBContactStatus)contactStatusByUser:(XMPPUserCoreDataStorageObject *)user;

@end


@implementation XBContact
- (instancetype)initWithXMPPUser:(XMPPUserCoreDataStorageObject *)user {
    self = [super init];
    if (self) {
        [self commonInit];
        [self updateContactWithXMPPUser:user];
    }

    return self;
}

- (void)commonInit {

}

#pragma mark Public

- (void)updateContactWithXMPPUser:(XMPPUserCoreDataStorageObject *)user {
    _contactName = user.displayName;
    _isOnline = user.isOnline;
    _status = [self contactStatusByUser:user];
    _statusText = user.primaryResource.status;

    _account = [[XBAccountManager sharedInstance] findAccountByJID:user.streamBareJidStr];
}

#pragma mark Private

- (XBContactStatus)contactStatusByUser:(XMPPUserCoreDataStorageObject *)user {
    if (!user.primaryResource || !user.isOnline) {
        return XBContactStatusUnavailable;
    }

    if ([user.primaryResource.show isEqualToString:@"chat"]) {
        return XBContactStatusChat;
    }

    if ([user.primaryResource.show isEqualToString:@"away"]) {
        return XBContactStatusAway;
    }

    if ([user.primaryResource.show isEqualToString:@"xa"]) {
        return XBContactStatusXA;
    }

    if ([user.primaryResource.show isEqualToString:@"dnd"]) {
        return XBContactStatusDnD;
    }

    return XBContactStatusAvailable;
}

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
    NSUInteger hash = [self.contactName hash];
    hash = hash * 31u + self.isOnline;
    hash = hash * 31u + (NSUInteger) self.status;
    hash = hash * 31u + [self.statusText hash];
    hash = hash * 31u + [self.account hash];
    return hash;
}

@end