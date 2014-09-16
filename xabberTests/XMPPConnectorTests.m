//
//  XMPPConnectorTests.m
//  xabber
//
//  Created by Dmitry Sobolev on 28/08/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XBXMPPConnector.h"
#import "XMPPStream.h"
#import "OCMock.h"
#import "XMPPModule.h"
#import "XBError.h"
#import "XMPPPresence+XBEquality.h"
#import "XBAccount.h"

@interface XMPPConnectorTests : XCTestCase {
    id mockXMPPStream;
    id mockConnector;
}
@end

@implementation XMPPConnectorTests

- (void)setUp
{
    [super setUp];

    XBXMPPConnector *connector = [[XBXMPPConnector alloc] init];
    mockConnector = OCMPartialMock(connector);
    mockXMPPStream = OCMClassMock([XMPPStream class]);
    OCMStub([mockConnector xmppStream]).andReturn(mockXMPPStream);
}

- (void)tearDown
{
    [mockConnector stopMocking];
    [mockXMPPStream stopMocking];

    [super tearDown];
}

- (void)testXMPPStreamIsConnected {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    OCMStub([mockXMPPStream isDisconnected]).andReturn(NO);
    NSError *e = nil;
    NSError *testError = [NSError errorWithDomain:XBXabberErrorDomain
                                             code:XBLoginValidationError
                                         userInfo:@{NSLocalizedDescriptionKey: @"Stream already connected"}];

    XCTAssertFalse([mockConnector loginToAccount:acc error:&e]);

    XCTAssertEqualObjects(e, testError);
}

- (void)testAccountNotValid {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    NSError *testError = [NSError errorWithDomain:XBXabberErrorDomain
                                             code:XBLoginValidationError
                                         userInfo:@{NSLocalizedDescriptionKey: @"Login or password are empty"}];

    NSError *e = nil;

    OCMStub([mockXMPPStream isDisconnected]).andReturn(YES);

    XCTAssertFalse([mockConnector loginToAccount:acc error:&e]);

    XCTAssertEqualObjects(e, testError);
}

- (void)testCouldNotConnect {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"test";
    acc.password = @"password";
    NSError *e = nil;
    NSError *testError = [NSError errorWithDomain:@""
                                             code:-1
                                         userInfo:nil];

    OCMStub([mockXMPPStream isDisconnected]).andReturn(YES);
    OCMStub([mockXMPPStream connectWithTimeout:XMPPStreamTimeoutNone
                                         error:(NSError __autoreleasing **)[OCMArg setTo:testError]]).andReturn(NO);

    XCTAssertFalse([mockConnector loginToAccount:acc error:&e]);
    XCTAssertEqualObjects(e, testError);
}

- (void)testStreamNotAuthenticate {
    NSError *testError = [NSError errorWithDomain:@""
                                             code:-1
                                         userInfo:nil];
    id connectorDelegate = OCMProtocolMock(@protocol(XBXMPPConnectorDelegate));

    [mockConnector setDelegate:connectorDelegate];

    OCMStub([connectorDelegate connector:mockConnector willAuthorizeWithPassword:(NSError __autoreleasing **)[OCMArg setTo:@"123"]]);

    OCMStub([mockXMPPStream authenticateWithPassword:@"123"
                                               error:(NSError __autoreleasing **)[OCMArg setTo:testError]]).andReturn(NO);

    [mockConnector xmppStreamDidConnect:mockXMPPStream];

    XCTAssertEqual([mockConnector connectionState], XBConnectionStateOffline);

}

- (void)testXMPPStreamDidAuthenticated {
    XBAccount *acc = [XBAccount accountWithConnector:nil];
    acc.accountJID = @"test";
    acc.password = @"password";
    acc.status = XBAccountStatusAvailable;
    NSError *e = nil;

    OCMStub([mockXMPPStream isDisconnected]).andReturn(YES);
    OCMStub([mockXMPPStream connectWithTimeout:XMPPStreamTimeoutNone
                                         error:[OCMArg anyObjectRef]]).andReturn(YES);
    OCMStub([mockConnector setNewStatus:XBAccountStatusAvailable]);

    [mockConnector loginToAccount:acc error:&e];

    XCTAssertEqual((XBConnectionState) [mockConnector connectionState], XBConnectionStateConnecting);

    OCMStub([mockXMPPStream isDisconnected]).andReturn(NO);
    OCMStub([mockXMPPStream isAuthenticated]).andReturn(YES);

    [mockConnector xmppStreamDidAuthenticate:mockXMPPStream];

    XCTAssertEqual((XBConnectionState) [mockConnector connectionState], XBConnectionStateOnline);
}

- (void)testSetStatusAvailable {
    XMPPPresence *presence = [XMPPPresence presence];

    OCMStub([mockXMPPStream sendElement:[OCMArg any]]);

    [mockConnector setNewStatus:XBAccountStatusAvailable];

    OCMVerify([mockXMPPStream sendElement:presence]);
}

- (void)testSetStatusChat {
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addChild:[DDXMLElement elementWithName:@"show" stringValue:@"chat"]];

    OCMStub([mockXMPPStream sendElement:[OCMArg any]]);

    [mockConnector setNewStatus:XBAccountStatusChat];

    OCMVerify([mockXMPPStream sendElement:presence]);
}

- (void)testSetStatusAway {
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addChild:[DDXMLElement elementWithName:@"show" stringValue:@"away"]];

    OCMStub([mockXMPPStream sendElement:[OCMArg any]]);

    [mockConnector setNewStatus:XBAccountStatusAway];

    OCMVerify([mockXMPPStream sendElement:presence]);
}

- (void)testSetStatusXA {
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addChild:[DDXMLElement elementWithName:@"show" stringValue:@"xa"]];

    OCMStub([mockXMPPStream sendElement:[OCMArg any]]);

    [mockConnector setNewStatus:XBAccountStatusXA];

    OCMVerify([mockXMPPStream sendElement:presence]);
}

- (void)testSetStatusDnD {
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addChild:[DDXMLElement elementWithName:@"show" stringValue:@"dnd"]];

    OCMStub([mockXMPPStream sendElement:[OCMArg any]]);

    [mockConnector setNewStatus:XBAccountStatusDnD];

    OCMVerify([mockXMPPStream sendElement:presence]);
}

@end
