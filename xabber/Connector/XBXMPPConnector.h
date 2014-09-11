//
// Created by Dmitry Sobolev on 26/08/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTypes.h"

@class XBAccount;
@class XMPPStream;

@interface XBXMPPConnector : NSObject
@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, weak) XBAccount* account;

- (void)loginWithCompletion:(void (^)(NSError *error))completionHandler;

- (void)logoutWithCompletion:(void(^)(NSError *error))completionHandler;

- (void)setNewStatus:(XBAccountStatus)status;

- (XBConnectionState)state;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToConnector:(XBXMPPConnector *)connector;

- (NSUInteger)hash;

@end
