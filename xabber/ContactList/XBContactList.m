//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBContactList.h"
#import "XBAccount.h"
#import "XBGroup.h"
#import "XBContact.h"


@interface XBContactList () {
    NSMutableArray *_contacts;
    NSMutableArray *_groups;
}
@end

@implementation XBContactList
- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }

    return self;
}


- (void)commonInit {
    _contacts = [NSMutableArray array];
    _groups = [NSMutableArray array];
}

- (NSArray *)contacts {
    return _contacts;
}

- (NSArray *)contactsForAccount:(XBAccount *)account {
    NSPredicate *contactsForAccount = [NSPredicate predicateWithFormat:@"account = %@", account];

    return [self.contacts filteredArrayUsingPredicate:contactsForAccount];
}

- (XBContact *)contactForAccount:(XBAccount *)account withID:(NSString *)contactID {
    NSPredicate *contactsForAccountAndID = [NSPredicate predicateWithFormat:@"account = %@ AND contactID = %@", account, contactID];

    NSArray *filteredContacts = [self.contacts filteredArrayUsingPredicate:contactsForAccountAndID];

    if (filteredContacts.count != 0) {
        return filteredContacts.firstObject;
    }

    return nil;
}

- (NSArray *)contactsForGroupWithName:(NSString *)groupName {
    XBGroup *group = [self groupByName:groupName];

    return [self contactsForGroup:group];
}

- (NSArray *)contactsForGroup:(XBGroup *)group {
    if ([self.groups containsObject:group]) {
        NSPredicate *filterContactsInGroup = [NSPredicate predicateWithFormat:@"%@ IN groups", group];

        return [self.contacts filteredArrayUsingPredicate:filterContactsInGroup];
    }

    return nil;
}

- (void)addContact:(XBContact *)contact {
    if (![self.contacts containsObject:contact]) {
        [_contacts addObject:contact];
    }
}

- (void)removeContact:(XBContact *)contact {
    if ([self.contacts containsObject:contact]) {
        [_contacts removeObject:contact];
    }
}

- (NSArray *)groups {
    return _groups;
}

- (XBGroup *)groupByName:(NSString *)groupName {
    NSPredicate *filterGroupsByName = [NSPredicate predicateWithFormat:@"name = %@", groupName];

    NSArray *filteredGroups = [_groups filteredArrayUsingPredicate:filterGroupsByName];

    if (filteredGroups.count != 0) {
        return filteredGroups.firstObject;
    }

    return nil;
}

- (void)addGroup:(XBGroup *)group {
    if (![self.groups containsObject:group]) {
        [_groups addObject:group];
    }
}

- (void)removeGroup:(XBGroup *)group {
    NSArray *contacts = [self contactsForGroupWithName:group.name];

    if (contacts) {
        for (XBContact *contact in contacts) {
            [contact removeGroup:group];
        }
    }

    [_groups removeObject:group];
}


@end