//
//  ContactsAndGroupsTests.m
//  xabber
//
//  Created by Dmitry Sobolev on 01/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XBGroup.h"
#import "XBContact.h"

@interface ContactsAndGroupsTests : XCTestCase

@end

@implementation ContactsAndGroupsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddAccountToGroup {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [group addContact:contact];

    XCTAssertEqualObjects(group.contacts, @[contact]);
    XCTAssertEqualObjects(contact.groups, @[group]);
}

- (void)testAddAccountToGroupAndDealloc {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [group addContact:contact];

    [group removeContact:contact];

    XCTAssertEqual(group.contacts.count, 0u);
    XCTAssertEqual(contact.groups.count, 0u);
}

- (void)testAddGroupToAccount {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [contact addGroup:group];

    XCTAssertEqualObjects(group.contacts, @[contact]);
    XCTAssertEqualObjects(contact.groups, @[group]);
}

- (void)testAddGroupToAccountAndDealloc {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [contact addGroup:group];

    [contact removeGroup:group];

    XCTAssertEqual(contact.groups.count, 0u);
    XCTAssertEqual(group.contacts.count, 0u);
}

@end
