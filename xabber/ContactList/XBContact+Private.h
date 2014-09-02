//
// Created by Dmitry Sobolev on 01/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBContact.h"

@class XBGroup;

@interface XBContact (Private)

- (void)addGroupToList:(XBGroup *)group;

- (void)removeGroupFromList:(XBGroup *)group;
@end