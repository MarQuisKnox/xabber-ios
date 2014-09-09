//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <XMPPFramework/XMPPRosterCoreDataStorage.h>
#import "XBContactList.h"
#import "XBContact.h"


@interface XBContactList () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *usersController;
    NSFetchedResultsController *groupsController;
}
@end

@implementation XBContactList

- (instancetype)initWithStorage:(XMPPRosterCoreDataStorage *)storage {
    self = [super init];
    if (self) {
        self.storage = storage;
        [self commonInit];
    }

    return self;
}

+ (instancetype)contactListWithStorage:(XMPPRosterCoreDataStorage *)storage {
    return [[self alloc] initWithStorage:storage];
}

- (void)commonInit {
    usersController = [XMPPUserCoreDataStorageObject MR_fetchAllGroupedBy:nil
                                                            withPredicate:nil
                                                                 sortedBy:@"displayName"
                                                                ascending:YES
                                                                 delegate:self];
    groupsController = [XMPPGroupCoreDataStorageObject MR_fetchAllGroupedBy:nil
                                                              withPredicate:nil
                                                                   sortedBy:@"name"
                                                                  ascending:YES
                                                                   delegate:self];
}

- (NSArray *)contacts {
    NSArray *fetchedUsers = usersController.fetchedObjects;
    
    __block NSMutableArray *contacts = [NSMutableArray array];

    [fetchedUsers enumerateObjectsUsingBlock:^(XMPPUserCoreDataStorageObject *user, NSUInteger idx, BOOL *stop) {
        [contacts addObject:[[XBContact alloc] initWithXMPPUser:user]];
    }];

    return contacts;
}

- (NSArray *)groups {
    NSArray *fetchedGroups = groupsController.fetchedObjects;

    __block NSMutableArray *groups = [NSMutableArray array];

    [fetchedGroups enumerateObjectsUsingBlock:^(XMPPGroupCoreDataStorageObject *group, NSUInteger idx, BOOL *stop){
        [groups addObject:group.name];
    }];

    return groups;
}

- (XBContact *)contactForIndexPath:(NSIndexPath *)indexPath {


    return nil;
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
    return nil;
}


@end