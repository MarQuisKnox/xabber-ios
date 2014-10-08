//
// Created by Dmitry Sobolev on 15/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBContactListController.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XBXMPPConnector.h"
#import "XBContact.h"

@interface XBContactListController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *usersFetchedResultsController;
    NSFetchedResultsController *groupsFetchedResultsController;
}
- (NSFetchedResultsController *)usersFetchedResultsController;

- (NSFetchedResultsController *)groupsFetchedResultsController;
@end

static NSString *const XBNotInGroupSectionName = @"Not in group";

@implementation XBContactListController {

}
- (instancetype)initWithStorage:(XMPPRosterCoreDataStorage *)storage {
    self = [super init];
    if (self) {
        self.storage = storage;
    }

    return self;
}

+ (instancetype)controllerWithStorage:(XMPPRosterCoreDataStorage *)storage {
    return [[self alloc] initWithStorage:storage];
}

- (NSUInteger)numberOfSections {
    return self.groupsFetchedResultsController.fetchedObjects.count + 1;
}

- (NSString *)titleOfSectionAtIndex:(NSUInteger)section {
    if (![self isCorrectSection:section]) {
        return nil;
    }

    if ([self isNotInGroupSection:section]) {
        return XBNotInGroupSectionName;
    }

    return [self groupName:section];
}

- (NSUInteger)numberOfContactsInSection:(NSUInteger)section {
    if (![self isCorrectSection:section]) {
        return 0;
    }

    return [self usersInSection:section].count;
}

- (XBContact *)contactAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger row = (NSUInteger) indexPath.row;

    XMPPUserCoreDataStorageObject *user = [self usersInSection:section][row];

    if (!user) {
        return nil;
    }

    return [[XBContact alloc] initWithXMPPUser:user];
}

#pragma mark Fetched Results Controllers

- (NSFetchedResultsController *)usersFetchedResultsController {
    if (!usersFetchedResultsController) {
        usersFetchedResultsController = [XMPPUserCoreDataStorageObject MR_fetchAllGroupedBy:nil
                                                                         withPredicate:nil
                                                                              sortedBy:@"displayName"
                                                                             ascending:YES
                                                                             inContext:self.storage.mainThreadManagedObjectContext];
        usersFetchedResultsController.delegate = self;
    }

    return usersFetchedResultsController;
}

- (NSFetchedResultsController *)groupsFetchedResultsController {
    if (!groupsFetchedResultsController) {
        groupsFetchedResultsController = [XMPPGroupCoreDataStorageObject MR_fetchAllGroupedBy:nil
                                                                                withPredicate:nil
                                                                                     sortedBy:@"name"
                                                                                    ascending:YES
                                                                                    inContext:self.storage.mainThreadManagedObjectContext];
        groupsFetchedResultsController.delegate = self;
    }

    return groupsFetchedResultsController;
}

#pragma mark Private

- (NSArray *)usersInSection:(NSUInteger)section {
    if (![self isCorrectSection:section]) {
        return nil;
    }

    NSPredicate *sectionFilterPredicate = nil;

    if ([self isNotInGroupSection:section]) {
        sectionFilterPredicate = [NSPredicate predicateWithFormat:@"groups.@count == 0"];
    }
    else {
        sectionFilterPredicate = [NSPredicate predicateWithFormat:@"%@ IN groups", self.groupsFetchedResultsController.fetchedObjects[section]];
    }

    return [self.usersFetchedResultsController.fetchedObjects filteredArrayUsingPredicate:sectionFilterPredicate];
}

- (BOOL)isNotInGroupSection:(NSUInteger)section {
    return section == self.numberOfSections - 1;
}

- (BOOL)isCorrectSection:(NSUInteger)section {
    return section < self.numberOfSections;
}

- (NSString *)groupName:(NSUInteger)section {
    XMPPGroupCoreDataStorageObject *group = self.groupsFetchedResultsController.fetchedObjects[section];
    return group.name;
}

#pragma mark NSFetchedResultsControllerDelegate

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//
//}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if ([self.delegate respondsToSelector:@selector(controllerWillChangeContent:)]) {
        [self.delegate controllerWillChangeContent:self];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if ([self.delegate respondsToSelector:@selector(controllerDidChangeContent:)]) {
        [self.delegate controllerDidChangeContent:self];
    }
}

@end