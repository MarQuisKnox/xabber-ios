//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBMinValueValidator.h"
#import "XBError.h"

@interface XBMinValueValidator (){
    NSInteger minValue;
}
@end

@implementation XBMinValueValidator
- (instancetype)initWithMinValue:(NSInteger)aMinValue {
    self = [super initWithTestClass:[NSNumber class]];
    if (self) {
        minValue = aMinValue;
    }

    return self;
}

+ (instancetype)validatorWithMinValue:(NSInteger)aMinValue {
    return [[self alloc] initWithMinValue:aMinValue];
}

- (BOOL)validateData:(id *)data error:(NSError **)error {
    if (![super validateData:data error:error]) {
        return NO;
    }

    if ([*data integerValue] < minValue) {
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:XBValidationValueTooSmall
                                 userInfo:@{
                                         NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"validate: number too small", @"Number must be greater or equal to %d"), minValue]
                                 }];

        return NO;
    }

    return YES;
}

@end