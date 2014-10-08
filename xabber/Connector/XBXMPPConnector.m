//
// Created by Dmitry Sobolev on 26/08/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <XMPPFramework/XMPPJID.h>
#import "XBXMPPConnector.h"
#import "XBAccount.h"
#import "XMPPFramework.h"
#import "XBError.h"

@interface XBXMPPConnector () <XMPPStreamDelegate> {
    XMPPReconnect *_xmppReconnect;
    XMPPRosterCoreDataStorage *_xmppRosterStorage;
    XMPPRoster *_xmppRoster;
    XMPPvCardCoreDataStorage *_xmppVCardStorage;
    XMPPvCardTempModule *_xmppVCardTempModule;
    XMPPvCardAvatarModule *_xmppVCardAvatarModule;

    BOOL _allowSelfSignedCertificates;
    BOOL _allowSSLHostNameMismatch;

    XBConnectionState _state;
}

- (void)setupStream;

- (void)teardownStream;

- (void)goOnline;

- (void)goOffline;

@end


@implementation XBXMPPConnector

- (id)init {
    self = [super init];
    if (self) {
        [self setupStream];
        _state = XBConnectionStateOffline;
    }

    return self;
}

- (void)dealloc {
    [self teardownStream];
}

#pragma mark Login/logout

- (XBConnectionState)connectionState {
    return _state;
}

- (BOOL)loginToAccount:(XBAccount *)account error:(NSError **)error {
    if (!self.xmppStream.isDisconnected) {
        DDLogError(@"Stream already connected");
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:XBLoginValidationError
                                 userInfo:@{NSLocalizedDescriptionKey : @"Stream already connected"}];
        return NO;
    }

    if (!account) {
        DDLogError(@"Account is nil");
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:XBLoginValidationError
                                 userInfo:@{NSLocalizedDescriptionKey : @"Account must not be nil"}];
        return NO;
    }

    if (account.accountJID == nil || account.password == nil) {
        DDLogError(@"Login or password are empty");
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:XBLoginValidationError
                                 userInfo:@{NSLocalizedDescriptionKey : @"Login or password are empty"}];
        return NO;
    }

    if ([self.delegate respondsToSelector:@selector(connectorWillLogin:)]) {
        [self.delegate connectorWillLogin:self];
    }

    self.xmppStream.hostName = account.host;
    self.xmppStream.hostPort = (UInt16) account.port;
    self.xmppStream.myJID = [XMPPJID jidWithString:account.accountJID];

    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:error]) {
        DDLogError(@"Error connecting: %@", *error);
        return NO;
    }

    _state = XBConnectionStateConnecting;

    return YES;
}

- (BOOL)logout:(NSError **)error {
    if (self.xmppStream.isDisconnected) {
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Connector already disconnected"}];

        return NO;
    }

    _state = XBConnectionStateDisconnecting;

    [self goOffline];
    [self.xmppStream disconnect];

    return YES;
}

- (void)setNewStatus:(XBAccountStatus)status {
    XMPPPresence *presence = [XMPPPresence presence];
    NSString *domain = [self.xmppStream.myJID domain];
    NSString *showString = [self showByStatus:status];

    if (showString) {
        DDXMLElement *show = [DDXMLElement elementWithName:@"show" stringValue:showString];
        [presence addChild:show];
    }

    if([domain isEqualToString:@"gmail.com"]
            || [domain isEqualToString:@"gtalk.com"]
            || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }

    [self.xmppStream sendElement:presence];
}

#pragma mark Setup/teardown stream

- (void)setupStream {
    NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");

    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    _xmppStream = [[XMPPStream alloc] init];
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        // When you try to set the associated property on the simulator, it simply fails.
        // And when you background an app on the simulator,
        // it just queues network traffic til the app is foregrounded again.
        // We are patiently waiting for a fix from Apple.
        // If you do enableBackgroundingOnSocket on the simulator,
        // you will simply see an error message from the xmpp stack when it fails to set the property.
        _xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif

    // Setup reconnect
    //
    // The XMPPReconnect module monitors for "accidental disconnections" and
    // automatically reconnects the stream for you.
    // There's a bunch more information in the XMPPReconnect header file.
    _xmppReconnect = [[XMPPReconnect alloc] init];

    // Setup roster
    //
    // The XMPPRoster handles the xmpp protocol stuff related to the roster.
    // The storage for the roster is abstracted.
    // So you can use any storage mechanism you want.
    // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
    // or setup your own using raw SQLite, or create your own storage mechanism.
    // You can do it however you like! It's your application.
    // But you do need to provide the roster with some storage facility.
    _xmppRosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    _xmppRoster.autoFetchRoster = YES;
    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;

    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
    _xmppVCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _xmppVCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppVCardStorage];
    _xmppVCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppVCardTempModule];

    // Activate xmpp modules
    [_xmppReconnect activate:_xmppStream];
    [_xmppRoster activate:_xmppStream];
    [_xmppVCardTempModule activate:_xmppStream];
    [_xmppVCardAvatarModule activate:_xmppStream];

    // Add ourself as a delegate to anything we may be interested in
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];

    _allowSelfSignedCertificates = NO;
    _allowSSLHostNameMismatch = NO;
}

- (void)teardownStream {
    [_xmppStream removeDelegate:self];
    [_xmppRoster removeDelegate:self];
    [_xmppReconnect deactivate];
    [_xmppRoster deactivate];
    [_xmppVCardTempModule deactivate];
    [_xmppVCardAvatarModule deactivate];
    [_xmppStream disconnect];

    _xmppStream = nil;
    _xmppReconnect = nil;
    _xmppRoster = nil;
    _xmppRosterStorage = nil;
    _xmppVCardStorage = nil;
    _xmppVCardTempModule = nil;
    _xmppVCardAvatarModule = nil;
}

#pragma mark Private

- (void)goOnline {
    XBAccountStatus status = XBAccountStatusAvailable;

    if ([self.delegate respondsToSelector:@selector(connector:willGoOnlineWithStatus:)]) {
        [self.delegate connector:self willGoOnlineWithStatus:&status];
    }

    [self setNewStatus:status];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

- (NSString *)showByStatus:(XBAccountStatus)status {
    switch (status) {
        case XBAccountStatusChat:
            return @"chat";
        case XBAccountStatusAway:
            return @"away";
        case XBAccountStatusXA:
            return @"xa";
        case XBAccountStatusDnD:
            return @"dnd";
        default:
            return nil;
    }

    return nil;
}

#pragma mark XMPPStream delegate

- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    DDLogVerbose(@"%@", THIS_METHOD);
}

- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender {
    DDLogVerbose(@"%@", THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    if (_allowSelfSignedCertificates)
    {
        settings[(NSString *) kCFStreamSSLAllowsAnyRoot] = @YES;
    }
    if (_allowSSLHostNameMismatch)
    {
        settings[(NSString *) kCFStreamSSLPeerName] = [NSNull null];
    }
    else
    {

        // Google does things incorrectly (does not conform to RFC).
        // Because so many people ask questions about this (assume xmpp framework is broken),
        // I've explicitly added code that shows how other xmpp clients "do the right thing"
        // when connecting to a google server (gmail, or google apps for domains).
        NSString *expectedCertName = nil;
        NSString *serverDomain = self.xmppStream.hostName;
        NSString *virtualDomain = [self.xmppStream.myJID domain];
        if ([serverDomain isEqualToString:@"talk.google.com"])
        {
            if ([virtualDomain isEqualToString:@"gmail.com"])
            {
                expectedCertName = virtualDomain;
            }
            else
            {
                expectedCertName = serverDomain;
            }
        }
        else if (serverDomain == nil)
        {
            expectedCertName = virtualDomain;
        }
        else
        {
            expectedCertName = serverDomain;
        }
        if (expectedCertName)
        {
            settings[(NSString *) kCFStreamSSLPeerName] = expectedCertName;
        }
    }
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender {

}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSError *error = nil;
    NSString *password = nil;

    if ([self.delegate respondsToSelector:@selector(connector:willAuthorizeWithPassword:)]) {
        [self.delegate connector:self willAuthorizeWithPassword:&password];
    }

    if (![self.xmppStream authenticateWithPassword:password error:&error])
    {
        DDLogError(@"Error authenticating: %@", error);

        _state = XBConnectionStateOffline;

        if ([self.delegate respondsToSelector:@selector(connector:didNotLoginWithError:)]) {
            [self.delegate connector:self didNotLoginWithError:error];
        }
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    DDLogVerbose(@"%@", THIS_METHOD);

    [self goOnline];

    _state = XBConnectionStateOnline;

    if ([self.delegate respondsToSelector:@selector(connectorDidLoginSuccessfully:)]) {
        [self.delegate connectorDidLoginSuccessfully:self];
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    DDLogVerbose(@"%@: %@", THIS_METHOD, error);

    NSError *e = [NSError errorWithDomain:XBXabberErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Stream didn't authenticate"}];

    _state = XBConnectionStateOffline;

    if ([self.delegate respondsToSelector:@selector(connector:didNotLoginWithError:)]) {
        [self.delegate connector:self didNotLoginWithError:e];
    }
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    DDLogVerbose(@"%@: %@", THIS_METHOD, iq);

    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq {
    DDLogVerbose(@"%@: %@", THIS_METHOD, iq);
}

- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence {
    DDLogVerbose(@"%@: %@", THIS_METHOD, presence);
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    DDLogVerbose(@"%@: %@", THIS_METHOD, presence);
}


- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    _state = XBConnectionStateOffline;

    if ([self.delegate respondsToSelector:@selector(connector:didLogoutWithError:)]) {
        [self.delegate connector:self didLogoutWithError:error];
    }
}

#pragma mark Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToConnector:other];
}

- (BOOL)isEqualToConnector:(XBXMPPConnector *)connector {
    if (self == connector)
        return YES;
    if (connector == nil)
        return NO;
    if (_xmppReconnect != connector->_xmppReconnect && ![_xmppReconnect isEqual:connector->_xmppReconnect])
        return NO;
    if (self.xmppStream != connector.xmppStream && ![self.xmppStream isEqual:connector.xmppStream])
        return NO;
    if (_xmppRosterStorage != connector->_xmppRosterStorage && ![_xmppRosterStorage isEqual:connector->_xmppRosterStorage])
        return NO;
    if (_xmppRoster != connector->_xmppRoster && ![_xmppRoster isEqual:connector->_xmppRoster])
        return NO;
    if (_xmppVCardStorage != connector->_xmppVCardStorage && ![_xmppVCardStorage isEqual:connector->_xmppVCardStorage])
        return NO;
    if (_xmppVCardTempModule != connector->_xmppVCardTempModule && ![_xmppVCardTempModule isEqual:connector->_xmppVCardTempModule])
        return NO;
    if (_xmppVCardAvatarModule != connector->_xmppVCardAvatarModule && ![_xmppVCardAvatarModule isEqual:connector->_xmppVCardAvatarModule])
        return NO;
    if (_allowSelfSignedCertificates != connector->_allowSelfSignedCertificates)
        return NO;
    if (_allowSSLHostNameMismatch != connector->_allowSSLHostNameMismatch)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [_xmppReconnect hash];
    hash = hash * 31u + [self.xmppStream hash];
    hash = hash * 31u + [_xmppRosterStorage hash];
    hash = hash * 31u + [_xmppRoster hash];
    hash = hash * 31u + [_xmppVCardStorage hash];
    hash = hash * 31u + [_xmppVCardTempModule hash];
    hash = hash * 31u + [_xmppVCardAvatarModule hash];
    hash = hash * 31u + _allowSelfSignedCertificates;
    hash = hash * 31u + _allowSSLHostNameMismatch;
    return hash;
}

@end