//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBClassValidator.h"


@interface XBMinValueValidator : XBClassValidator
- (instancetype)initWithMinValue:(NSInteger)aMinValue;

+ (instancetype)validatorWithMinValue:(NSInteger)aMinValue;

@end