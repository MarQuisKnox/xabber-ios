//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBRequiredValidator.h"


@interface XBClassValidator : XBRequiredValidator
- (instancetype)initWithTestClass:(Class)aClass;

+ (instancetype)validatorWithTestClass:(Class)aClass;

@end