//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBClassValidator.h"


@interface XBStringLengthValidator : XBClassValidator
- (instancetype)initWithMinLength:(NSUInteger)aMinLength maxLength:(NSUInteger)aMaxLength;

+ (instancetype)validatorWithMinLength:(NSUInteger)aMinLength maxLength:(NSUInteger)aMaxLength;

+ (instancetype)validatorWithMinLength:(NSUInteger)aMinLength;

+ (instancetype)validatorWithMaxLength:(NSUInteger)aMaxLength;
@end