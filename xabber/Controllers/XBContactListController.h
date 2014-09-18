//
// Created by Dmitry Sobolev on 15/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMPPRosterCoreDataStorage;
@class XBContact;
@protocol XBContactListControllerDelegate;


@interface XBContactListController : NSObject

@property (nonatomic, strong) XMPPRosterCoreDataStorage *storage;

@property (nonatomic, weak) id <XBContactListControllerDelegate> delegate;

- (instancetype)initWithStorage:(XMPPRosterCoreDataStorage *)storage;

+ (instancetype)controllerWithStorage:(XMPPRosterCoreDataStorage *)storage;

- (NSUInteger)numberOfSections;

- (NSString *)titleOfSectionAtIndex:(NSUInteger)section;

- (NSUInteger)numberOfContactsInSection:(NSUInteger)section;

- (XBContact *)contactAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol XBContactListControllerDelegate <NSObject>

@optional
- (void)controllerWillChangeContent:(XBContactListController *)controller;

@optional
- (void)controllerDidChangeContent:(XBContactListController *)controller;

@end