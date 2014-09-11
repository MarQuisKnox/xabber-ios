//
//  AccountTests.m
//  xabber
//
//  Created by Dmitry Sobolev on 22/08/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SSKeychain/SSKeychain.h>
#import <OCMock/OCMock.h>
#import "XBAccount.h"
#import "XBXMPPCoreDataAccount.h"
#import "OCObserverMockObject.h"

@interface AccountTests : XCTestCase

@end

@implementation AccountTests

- (void)setUp
{
    [super setUp];

    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

- (void)tearDown
{
    [MagicalRecord cleanUp];

    [super tearDown];
}

- (void)testAccountSave {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";

    [acc save];

    XCTAssertEqual([XBXMPPCoreDataAccount MR_findAll].count, 1u);
}

- (void)testAccountIsNew {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";

    XCTAssertTrue(acc.isNew);
}

- (void)testCreatedEmptyAccountIsNew {
    XBAccount *acc = [XBAccount accountWithConnector:nil];

    XCTAssertTrue(acc.isNew);
}

- (void)testAccountNotNewAfterSave {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    [acc save];

    XCTAssertFalse(acc.isNew);
}

- (void)testLoadedFromCoreDataAccountNotNew {
    XBAccount *acc1 = [XBAccount accountWithConnector:nil];
    acc1.accountJID = @"account";
    [acc1 save];

    XBAccount *acc2 = [XBAccount accountWithConnector:nil coreDataAccount:[XBXMPPCoreDataAccount MR_findFirstByAttribute:@"accountID" withValue:@"account"]];

    XCTAssertFalse(acc2.isNew);
}

- (void)testNotCreatingDuplicates {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";

    [acc save];
    [acc save];

    XCTAssertEqual([XBXMPPCoreDataAccount MR_findAll].count, 1u);
}

- (void)testDefaults {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";

    XCTAssertTrue(acc.autoLogin);
    XCTAssertEqual(acc.port, (UInt16)5222);
    XCTAssertEqual(acc.status, XBAccountStatusAvailable);
    XCTAssertTrue(acc.isNew);
    XCTAssertFalse(acc.isDeleted);
}

- (void)testRestoreFromCoreData {
    XBAccount *acc1 = [XBAccount accountWithConnector:nil];
    acc1.accountJID = @"account";
    acc1.password = @"123";
    acc1.host = @"example.com";

    [acc1 save];

    XBAccount *acc2 = [XBAccount accountWithConnector:nil coreDataAccount:[XBXMPPCoreDataAccount MR_findFirstByAttribute:@"accountID" withValue:@"account"]];

    XCTAssertEqualObjects(acc1, acc2);
}

- (void)testCannotSaveIfAccountIDAlreadyUsed {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";

    [acc save];

    XBAccount *acc2 = [XBAccount accountWithConnector:nil];
    acc2.accountJID = @"account";

    XCTAssertFalse([acc2 save]);
}

- (void)testDeleteAccount {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";

    [acc save];

    [acc delete];

    XCTAssertTrue(acc.isDeleted);
    XCTAssertEqual([XBXMPPCoreDataAccount MR_findAll].count, 0u);
    XCTAssertNil([SSKeychain passwordForService:@"xabberService" account:@"account"]);
}

- (void)testDeleteNotSavedAccount {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";

    XCTAssertFalse([acc delete]);
    XCTAssertFalse(acc.isDeleted);
}

- (void)testCompareAccountsWithEqualData {
    XBAccount *acc1 = [XBAccount accountWithConnector:nil];
    acc1.accountJID = @"account";
    XBAccount *acc2 = [XBAccount accountWithConnector:nil];
    acc2.accountJID = @"account";

    [acc1 save];

    XCTAssertNotEqualObjects(acc1, acc2);
}

- (void)testAccountValidation {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account@example.com";
    acc.password = @"123";

    XCTAssertTrue(acc.isValid);
}

- (void)testValidationAccountWithIncorrectJID {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";
    acc.password = @"123";

    XCTAssertFalse(acc.isValid);
}

- (void)testValidateAccountWithoutJID {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.password = @"123";

    XCTAssertFalse(acc.isValid);
}

- (void)testValidateAccountWithoutPassword {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";

    XCTAssertFalse(acc.isValid);
}

- (void)testValidateZeroPortValue {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";
    acc.password = @"123";
    acc.port = 0;

    XCTAssertFalse(acc.isValid);
}

- (void)testValidateTooBigPortValue {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"account";
    acc.password = @"123";
    acc.port = 655536;

    XCTAssertFalse(acc.isValid);
}

- (void)testNotificationOnSave {
    XBAccount *account = [XBAccount accountWithConnector:nil];
    account.accountJID = @"accountName@example.com";
    account.password = @"accountName";

    OCObserverMockObject *observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:XBAccountSaved object:nil];
    [[observerMock expect] notificationWithName:XBAccountSaved object:[OCMArg any] userInfo:@{@"account": account}];

    [account save];

    OCMVerifyAll(observerMock);
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

- (void)testNotificationOnChangeAccountJID {
    XBAccount *account = [XBAccount accountWithConnector:nil];

    OCObserverMockObject *observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:XBAccountFieldValueChanged object:nil];
    [[observerMock expect] notificationWithName:XBAccountFieldValueChanged object:[OCMArg any]
                                       userInfo:@{@"account": account, @"fieldName": @"accountJID"}];

    account.accountJID = @"accountName@example.com";

    OCMVerifyAll(observerMock);
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

- (void)testNotificationOnChangePassword {
    XBAccount *account = [XBAccount accountWithConnector:nil];

    OCObserverMockObject *observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:XBAccountFieldValueChanged object:nil];
    [[observerMock expect] notificationWithName:XBAccountFieldValueChanged object:[OCMArg any]
                                       userInfo:@{@"account": account, @"fieldName": @"password"}];

    account.password = @"accountName@example.com";

    OCMVerifyAll(observerMock);
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

- (void)testNotificationOnChangeAutoLogin {
    XBAccount *account = [XBAccount accountWithConnector:nil];

    OCObserverMockObject *observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:XBAccountFieldValueChanged object:nil];
    [[observerMock expect] notificationWithName:XBAccountFieldValueChanged object:[OCMArg any]
                                       userInfo:@{@"account": account, @"fieldName": @"autoLogin"}];

    account.autoLogin = NO;

    OCMVerifyAll(observerMock);
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

- (void)testNotificationOnChangeStatus {
    XBAccount *account = [XBAccount accountWithConnector:nil];

    OCObserverMockObject *observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:XBAccountFieldValueChanged object:nil];
    [[observerMock expect] notificationWithName:XBAccountFieldValueChanged object:[OCMArg any]
                                       userInfo:@{@"account": account, @"fieldName": @"status"}];

    account.status = XBAccountStatusXA;

    OCMVerifyAll(observerMock);
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

- (void)testNotificationOnChangeHost {
    XBAccount *account = [XBAccount accountWithConnector:nil];

    OCObserverMockObject *observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:XBAccountFieldValueChanged object:nil];
    [[observerMock expect] notificationWithName:XBAccountFieldValueChanged object:[OCMArg any]
                                       userInfo:@{@"account": account, @"fieldName": @"host"}];

    account.host = @"example.com";

    OCMVerifyAll(observerMock);
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

- (void)testNotificationOnChangePort {
    XBAccount *account = [XBAccount accountWithConnector:nil];

    OCObserverMockObject *observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:XBAccountFieldValueChanged object:nil];
    [[observerMock expect] notificationWithName:XBAccountFieldValueChanged object:[OCMArg any]
                                       userInfo:@{@"account": account, @"fieldName": @"port"}];

    account.port = 5223;

    OCMVerifyAll(observerMock);
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

@end
