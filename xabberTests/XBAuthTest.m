//
//  XBAuthTest.m
//  xabber
//
//  Created by Dmitry Sobolev on 15/08/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XBAccountManager.h"
#import "OCMock/OCMock.h"
#import "XBAccount.h"
#import "OCObserverMockObject.h"

@interface XBAuthTest : XCTestCase {
    XBAccountManager *manager;
}

@end

@implementation XBAuthTest

- (void)setUp
{
    [super setUp];

    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    manager = [XBAccountManager sharedInstance];
}

- (void)tearDown
{
    for (XBAccount *account in manager.accounts) {
        [manager deleteAccountWithID:account.accountJID];
    }

    [MagicalRecord cleanUp];

    [super tearDown];
}

- (void)testAccountAdd {
    NSUInteger accountsBefore = manager.accounts.count;
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName@example.com";
    [account save];

    [manager addAccount:account];

    XCTAssertEqual([manager accounts].count, accountsBefore + 1);
}

- (void)testTryAddNilAccount {
    [manager addAccount:nil];

    XCTAssertEqual(manager.accounts.count, 0u);
}

- (void)testTryToAddNotSavedAccount {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName";

    [manager addAccount:account];

    XCTAssertEqual([manager accounts].count, 0u);
}

- (void)testAccountFind {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName";
    [account save];

    [manager addAccount:account];

    XBAccount *foundAccount = [manager findAccountByJID:@"accountName"];

    XCTAssertEqualObjects(account, foundAccount);
}

- (void)testTryToFindNotExistingAccount {
    XCTAssertNil([manager findAccountByJID:@"accountName"]);
}

- (void)testAccountDeleteByID {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName";
    [account save];

    [manager addAccount:account];
    [manager deleteAccountWithID:@"accountName"];

    XCTAssertEqual(manager.accounts.count, 0u);
}

- (void)testTryToDeleteAccountByNotExistingID {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName";
    [account save];

    [manager addAccount:account];
    [manager deleteAccountWithID:@"account"];

    XCTAssertEqual(manager.accounts.count, 1u);
}

- (void)testDeleteAccount {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName";
    [account save];

    [manager addAccount:account];
    [manager deleteAccount:account];

    XCTAssertEqual(manager.accounts.count, 0u);
}

- (void)testDeleteNotExistingAccount {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName";
    XBAccount *account2 = [XBAccount accountWithConnector:nil];
    account2.accountJID = @"accountName";
    [account save];

    [manager addAccount:account];
    [manager deleteAccount:account2];

    XCTAssertEqual(manager.accounts.count, 1u);
}

- (void)testAccountManagerPostNotificationOnAdd {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName@example.com";
    account.password = @"accountName";
    [account save];

    OCObserverMockObject *observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:XBAccountManagerAccountAdded object:nil];
    [[observerMock expect] notificationWithName:XBAccountManagerAccountAdded object:[OCMArg any]
                                       userInfo:@{@"account": account}];

    [manager addAccount:account];

    OCMVerifyAll(observerMock);
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

- (void)testAccountManagerPostNotificationOnDelete {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName@example.com";
    account.password = @"accountName";
    [account save];

    [manager addAccount:account];

    OCObserverMockObject *observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:XBAccountManagerAccountDeleted object:nil];
    [[observerMock expect] notificationWithName:XBAccountManagerAccountDeleted object:[OCMArg any]
                                       userInfo:@{@"account": account}];

    [manager deleteAccount:account];

    OCMVerifyAll(observerMock);
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

- (void)testAccountManagerPostNotificationOnDeleteByJID {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName@example.com";
    account.password = @"accountName";
    [account save];

    [manager addAccount:account];

    OCObserverMockObject *observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:XBAccountManagerAccountDeleted object:nil];
    [[observerMock expect] notificationWithName:XBAccountManagerAccountDeleted object:[OCMArg any]
                                       userInfo:@{@"account": account}];

    [manager deleteAccountWithID:@"accountName@example.com"];

    OCMVerifyAll(observerMock);
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

@end
