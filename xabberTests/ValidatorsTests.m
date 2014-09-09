//
//  ValidatorsTests.m
//  xabber
//
//  Created by Dmitry Sobolev on 09/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XBRequiredValidator.h"
#import "XBClassValidator.h"
#import "XBStringLengthValidator.h"

@interface ValidatorsTests : XCTestCase

@end

@implementation ValidatorsTests

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

- (void)testValidateRequiredString {
    XBRequiredValidator *v = [[XBRequiredValidator alloc] init];

    NSError *e = nil;
    NSString *test = @"";

    XCTAssertTrue([v validateData:&test error:&e]);
}

- (void)testValidateRequiredNilString {
    XBRequiredValidator *v = [[XBRequiredValidator alloc] init];

    NSError *e = nil;
    NSString *test = nil;

    XCTAssertFalse([v validateData:&test error:&e]);
    XCTAssertNotNil(e);
}

- (void)testValidateRequiredNULL {
    XBRequiredValidator *v = [[XBRequiredValidator alloc] init];

    NSError *e = nil;

    XCTAssertFalse([v validateData:NULL error:&e]);
    XCTAssertNotNil(e);
}

- (void)testValidateClass {
    XBClassValidator *v = [XBClassValidator validatorWithTestClass:[NSString class]];

    NSError *e = nil;
    NSString *test = @"";

    XCTAssertTrue([v validateData:&test error:&e]);
}

- (void)testValidateNotMatchingClass {
    XBClassValidator *v = [XBClassValidator validatorWithTestClass:[NSString class]];

    NSError *e = nil;
    NSNumber *test = @1;

    XCTAssertFalse([v validateData:&test error:&e]);
    XCTAssertNotNil(e);
}

- (void)testValidateStringLengthIncorrectInitialParameters {
    XBStringLengthValidator *v = [XBStringLengthValidator validatorWithMinLength:20 maxLength:19];

    XCTAssertNil(v);
}

- (void)testValidateStringLengthNilInitialParameters {
    XBStringLengthValidator *v = [XBStringLengthValidator validatorWithMinLength:0 maxLength:0];

    XCTAssertNil(v);
}

- (void)testValidateStringLength {
    XBStringLengthValidator *v = [XBStringLengthValidator validatorWithMinLength:1 maxLength:4];

    NSError *e = nil;
    NSString *test = @"123";

    XCTAssertTrue([v validateData:&test error:&e]);
}

- (void)testValidateTooShortString {
    XBStringLengthValidator *v = [XBStringLengthValidator validatorWithMinLength:4];

    NSError *e = nil;
    NSString *test = @"123";

    XCTAssertFalse([v validateData:&test error:&e]);
    XCTAssertNotNil(e);
}

- (void)testValidateTooLongString {
    XBStringLengthValidator *v = [XBStringLengthValidator validatorWithMaxLength:1];

    NSError *e = nil;
    NSString *test = @"123";

    XCTAssertFalse([v validateData:&test error:&e]);
    XCTAssertNotNil(e);
}

@end
