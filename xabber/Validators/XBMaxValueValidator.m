//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBMaxValueValidator.h"
#import "XBError.h"


@interface XBMaxValueValidator() {
    NSInteger maxValue;
}
@end

@implementation XBMaxValueValidator

- (instancetype)initWithMaxValue:(NSInteger)aMaxValue {
    self = [super initWithTestClass:[NSNumber class]];
    if (self) {
        maxValue = aMaxValue;
    }

    return self;
}

+ (instancetype)validatorWithMaxValue:(NSInteger)aMaxValue {
    return [[self alloc] initWithMaxValue:aMaxValue];
}

- (BOOL)validateData:(id *)data error:(NSError **)error {
    if (![super validateData:data error:error]) {
        return NO;
    }

    if ([*data integerValue] > maxValue) {
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:XBValidationValueTooBig
                                 userInfo:@{
                                         NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"validate: number too big", @"Number must be less then or equal to %d"), maxValue]
                                 }];

        return NO;
    }

    return YES;
}


@end