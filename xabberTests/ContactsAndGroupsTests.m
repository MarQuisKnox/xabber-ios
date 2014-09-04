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

    [group addToContact:contact];

    XCTAssertEqualObjects(contact.groups, @[group]);
}

- (void)testRemoveContactFromGroup {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [group addToContact:contact];
    [group removeFromContact:contact];

    XCTAssertEqual(contact.groups.count, 0u);
}

- (void)testRemoveFromContactNotExistingGroup {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [group removeFromContact:contact];

    XCTAssertEqual(contact.groups.count, 0u);
}

- (void)testAddGroupToContact {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [contact addGroup:group];

    XCTAssertEqualObjects(contact.groups, @[group]);
}

- (void)testRemoveGroupFromContact {
    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
    XBContact *contact = [[XBContact alloc] init];

    [contact addGroup:group];
    [contact removeGroup:group];

    XCTAssertEqual(contact.groups.count, 0u);
}

- (void)testRemoveGroupNotFromContact {
    XBGroup *g1 = [[XBGroup alloc] initWithName:@"test"];
    XBGroup *g2 = [[XBGroup alloc] initWithName:@"test1"];
    XBContact *contact = [[XBContact alloc] init];

    [contact addGroup:g1];
    [contact removeGroup:g2];

    XCTAssertEqual(contact.groups.count, 1u);
}

@end
