//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBClassValidator.h"


@interface XBMaxValueValidator : XBClassValidator
- (instancetype)initWithMaxValue:(NSInteger)aMaxValue;

+ (instancetype)validatorWithMaxValue:(NSInteger)aMaxValue;
@end