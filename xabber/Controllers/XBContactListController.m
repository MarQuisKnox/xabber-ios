//
// Created by Dmitry Sobolev on 15/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBContactListController.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XBXMPPConnector.h"
#import "XBContact.h"

@interface XBContactListController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
}
@end

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
    return self.usersFetchedResultsController.sections.count;
}

- (NSUInteger)numberOfContactsInSection:(NSUInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.usersFetchedResultsController.sections[section];

    return sectionInfo.numberOfObjects;
}

- (XBContact *)contactAtIndexPath:(NSIndexPath *)indexPath {
    XMPPUserCoreDataStorageObject *user = [self.usersFetchedResultsController objectAtIndexPath:indexPath];

    return [[XBContact alloc] initWithXMPPUser:user];
}


- (NSFetchedResultsController *)usersFetchedResultsController {
    if (!fetchedResultsController) {
        fetchedResultsController = [XMPPUserCoreDataStorageObject MR_fetchAllGroupedBy:nil
                                                                         withPredicate:nil
                                                                              sortedBy:@"displayName"
                                                                             ascending:YES
                                                                             inContext:self.storage.mainThreadManagedObjectContext];
        fetchedResultsController.delegate = self;
    }

    return fetchedResultsController;
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