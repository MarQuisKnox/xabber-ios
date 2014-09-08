//
//  ContactListTests.m
//  xabber
//
//  Created by Dmitry Sobolev on 02/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XBContactList.h"
#import "XBGroup.h"
#import "XBContact.h"

@interface ContactListTests : XCTestCase

@end

@implementation ContactListTests

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

//- (void)testAddGroup {
//    XBContactList *cl = [[XBContactList alloc] init];
//    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
//
//    [cl addGroup:group];
//
//    XCTAssertEqualObjects(cl.groups, @[group]);
//}
//
//- (void)testGetGroupByName {
//    XBContactList *cl = [[XBContactList alloc] init];
//    XBGroup *group = [[XBGroup alloc] initWithName:@"test"];
//
//    [cl addGroup:group];
//
//    XCTAssertEqualObjects([cl groupByName:@"test"], group);
//}
//
//- (void)testAddTwoGroupsWithSameName {
//    XBContactList *cl = [[XBContactList alloc] init];
//
//    XBGroup *g1 = [[XBGroup alloc] initWithName:@"test"];
//    XBGroup *g2 = [[XBGroup alloc] initWithName:@"test"];
//
//    [cl addGroup:g1];
//    [cl addGroup:g2];
//
//    XCTAssertEqualObjects(cl.groups, @[g1]);
//}
//
//- (void)testAddTwoEqualContacts {
//    XBContactList *cl = [[XBContactList alloc] init];
//    XBContact *c1 = [[XBContact alloc] init];
//    XBContact *c2 = [[XBContact alloc] init];
//
//    c1.contactID = @"test";
//    c2.contactID = @"test";
//
//    [cl addContact:c1];
//    [cl addContact:c2];
//
//    XCTAssertEqualObjects(cl.contacts, @[c1]);
//}
//
//- (void)testTryToGetNotExistingGroup {
//    XBContactList *cl = [[XBContactList alloc] init];
//
//    XCTAssertNil([cl groupByName:@"test"]);
//}
//
//- (void)testRemoveGroup {
//    XBContactList *cl = [[XBContactList alloc] init];
//    XBGroup *g = [[XBGroup alloc] initWithName:@"group"];
//    XBContact *c = [[XBContact alloc] init];
//    c.contactID = @"contact";
//
//    [cl addGroup:g];
//    [cl addContact:c];
//
//    [g addToContact:c];
//    [cl removeGroup:g];
//
//    XCTAssertEqual(cl.groups.count, 0u);
//    XCTAssertEqualObjects(c.groups, @[]);
//}
//
//- (void)testRemoveContact {
//    XBContactList *cl = [[XBContactList alloc] init];
//    XBContact *c = [[XBContact alloc] init];
//    c.contactID = @"contact";
//
//    [cl addContact:c];
//    [cl removeContact:c];
//
//    XCTAssertEqual(cl.contacts.count, 0u);
//}
//
//- (void)testContactsForGroupByName {
//    XBContactList *cl = [[XBContactList alloc] init];
//    XBGroup *g = [[XBGroup alloc] initWithName:@"group"];
//    XBContact *c = [[XBContact alloc] init];
//
//    [cl addGroup:g];
//    [cl addContact:c];
//
//    [c addGroup:g];
//
//    XCTAssertEqualObjects([cl contactsForGroupWithName:@"group"], @[c]);
//}
//
//- (void)testContactsForGroup {
//    XBContactList *cl = [[XBContactList alloc] init];
//    XBGroup *g = [[XBGroup alloc] initWithName:@"group"];
//    XBContact *c = [[XBContact alloc] init];
//
//    [cl addGroup:g];
//    [cl addContact:c];
//
//    [c addGroup:g];
//
//    XCTAssertEqualObjects([cl contactsForGroup:g], @[c]);
//}
//
//- (void)testContactsWithUnknownGroup {
//    XBContactList *cl = [[XBContactList alloc] init];
//    XBGroup *g = [[XBGroup alloc] initWithName:@"group"];
//
//    XCTAssertNil([cl contactsForGroup:g]);
//}
//
//- (void)testContactsWithUnknownGroupName {
//    XBContactList *cl = [[XBContactList alloc] init];
//
//    XCTAssertNil([cl contactsForGroupWithName:@"group"]);
//}
//
//- (void)testGetGroupWithNilAsGroupName {
//    XBContactList *cl = [[XBContactList alloc] init];
//
//    XCTAssertNil([cl groupByName:nil]);
//}
//
//- (void)testContactForAccount {
//    XBContactList *cl = [[XBContactList alloc] init];
//
//    XBContact *c1 = [[XBContact alloc] init];
//    XBContact *c2 = [[XBContact alloc] init];
//    XBAccount *a1 = [XBAccount accountWithConnector:nil];
//    XBAccount *a2 = [XBAccount accountWithConnector:nil];
//
//    c1.account = a1;
//    c2.account = a2;
//
//    [cl addContact:c1];
//    [cl addContact:c2];
//
//    XCTAssertEqualObjects([cl contactsForAccount:a1], @[c1]);
//}
//
//
@end
