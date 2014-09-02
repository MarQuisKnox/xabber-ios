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

- (void)testAddContactToGroup {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [group addContact:contact];

    XCTAssertEqualObjects(group.contacts, @[contact]);
    XCTAssertEqualObjects(contact.groups, @[group]);
}

- (void)testRemoveContactFromGroup {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [group addContact:contact];

    [group removeContact:contact];

    XCTAssertEqual(group.contacts.count, 0u);
    XCTAssertEqual(contact.groups.count, 0u);
}

- (void)testAddGroupToContact {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [contact addGroup:group];

    XCTAssertEqualObjects(group.contacts, @[contact]);
    XCTAssertEqualObjects(contact.groups, @[group]);
}

- (void)testRemoveGroupFromContact {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [contact addGroup:group];

    [contact removeGroup:group];

    XCTAssertEqual(contact.groups.count, 0u);
    XCTAssertEqual(group.contacts.count, 0u);
}

- (void)testGroupsWithDifferentContactsAreNotEqual {
    XBContact *c1 = [[XBContact alloc] init];
    XBContact *c2 = [[XBContact alloc] init];
    c1.contactID = @"c1";
    c2.contactID = @"c2";

    XBGroup *g1 = [[XBGroup alloc] initWithName:@"test"];
    XBGroup *g2 = [[XBGroup alloc] initWithName:@"test"];

    [g1 addContact:c1];
    [g2 addContact:c2];

    XCTAssertNotEqualObjects(g1, g2);
}

@end
