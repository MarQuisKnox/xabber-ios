//
//  AccountsControllerTests.m
//  xabber
//
//  Created by Dmitry Sobolev on 12/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XBAccountsController.h"
#import "XBAccountManager.h"
#import "XBAccount.h"

@interface AccountsControllerTests : XCTestCase {
    XBAccountsController *controller;
    id accountsManagerMock;
}

@end

@implementation AccountsControllerTests

- (void)setUp
{
    [super setUp];

    accountsManagerMock = OCMClassMock([XBAccountManager class]);

    controller = [XBAccountsController controllerWithAccountManager:accountsManagerMock];
}

- (void)tearDown
{
    [accountsManagerMock stopMocking];
    [super tearDown];
}

- (void)testNumberOfAccountsInRightSection {
    OCMStub([accountsManagerMock accounts]).andReturn(@[[XBAccount accountWithConnector:nil]]);

    XCTAssertEqual(controller.numberOfAccounts, 1u);
}

- (void)testAccountWithIndexPath {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    OCMStub([accountsManagerMock accounts]).andReturn(@[account]);

    XCTAssertEqualObjects([controller accountWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], account);
}

- (void)testNilIfAccountIndexPathHaveWrongSection {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    OCMStub([accountsManagerMock accounts]).andReturn(@[account]);

    XCTAssertNil([controller accountWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]);
}

- (void)testNilIfAccountIndexPathHaveWrongRow {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    OCMStub([accountsManagerMock accounts]).andReturn(@[account]);

    XCTAssertNil([controller accountWithIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]);
}

- (void)testIsAccountIndexPath {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    OCMStub([accountsManagerMock accounts]).andReturn(@[account]);

    XCTAssertTrue([NSIndexPath indexPathForRow:0 inSection:0]);
}

- (void)testNotAccountIndexPathWithWrongSection {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    OCMStub([accountsManagerMock accounts]).andReturn(@[account]);

    XCTAssertFalse([controller accountWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]);
}

- (void)testNotAccountIndexPathWithWrongRow {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    OCMStub([accountsManagerMock accounts]).andReturn(@[account]);

    XCTAssertFalse([controller accountWithIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]);
}

- (void)testDeleteAccount {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    OCMStub([accountsManagerMock accounts]).andReturn(@[account]);
    OCMExpect([accountsManagerMock deleteAccount:account]);

    XCTAssertTrue([controller deleteAccountInIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]);

    OCMVerifyAll(accountsManagerMock);
}

- (void)testDeleteAccountWithWrongIndexPath {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    OCMStub([accountsManagerMock accounts]).andReturn(@[account]);

    XCTAssertFalse([controller deleteAccountInIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]]);
}

@end
