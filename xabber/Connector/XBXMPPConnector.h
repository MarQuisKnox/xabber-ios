//
// Created by Dmitry Sobolev on 26/08/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTypes.h"

@class XBAccount;
@class XMPPStream;
@class XMPPJID;
@protocol XBXMPPConnectorDelegate;

@interface XBXMPPConnector : NSObject
@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, weak) id <XBXMPPConnectorDelegate> delegate;

- (BOOL)loginToAccount:(XBAccount *)account error:(NSError **)error;

- (BOOL)logout:(NSError **)error;

- (void)setNewStatus:(XBAccountStatus)status;

- (XBConnectionState)state;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToConnector:(XBXMPPConnector *)connector;

- (NSUInteger)hash;

@end

@protocol XBXMPPConnectorDelegate <NSObject>

@required
- (void)connector:(XBXMPPConnector *)connector willAuthorizeWithPassword:(NSString **)password;

@optional
- (void)connectorWillLogin:(XBXMPPConnector *)connector;

- (void)connector:(XBXMPPConnector *)connector willGoOnlineWithStatus:(XBAccountStatus *)status;

- (void)connectorDidLoginSuccessfully:(XBXMPPConnector *)connector;

- (void)connector:(XBXMPPConnector *)connector didNotLoginWithError:(NSError *)error;

- (void)connector:(XBXMPPConnector *)connector didLogoutWithError:(NSError *)error;

@end
