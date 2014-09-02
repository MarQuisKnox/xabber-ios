//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBGroup.h"

@class XBContact;

@interface XBGroup (Private)

- (void)addContactToList:(XBContact *)contact;

- (void)removeContactFromList:(XBContact *)contact;
@end