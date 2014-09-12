//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBStringLengthValidator.h"
#import "XBError.h"

@interface XBStringLengthValidator() {
    NSUInteger minLength;
    NSUInteger maxLength;
}
@end

@implementation XBStringLengthValidator {

}
- (instancetype)initWithMinLength:(NSUInteger)aMinLength maxLength:(NSUInteger)aMaxLength {
    self = [super initWithTestClass:[NSString class]];
    if (self) {
        if (aMinLength == 0 && aMaxLength == 0) {
            return nil;
        }

        if (aMinLength != 0 && aMaxLength != 0 && aMaxLength < aMinLength) {
            return nil;
        }

        minLength = aMinLength;
        maxLength = aMaxLength;
    }

    return self;
}

+ (instancetype)validatorWithMinLength:(NSUInteger)aMinLength maxLength:(NSUInteger)aMaxLength {
    return [[self alloc] initWithMinLength:aMinLength maxLength:aMaxLength];
}

+ (instancetype)validatorWithMinLength:(NSUInteger)aMinLength {
    return [[self alloc] initWithMinLength:aMinLength maxLength:0];
}

+ (instancetype)validatorWithMaxLength:(NSUInteger)aMaxLength {
    return [[self alloc] initWithMinLength:0 maxLength:aMaxLength];
}

- (BOOL)validateData:(id *)data error:(NSError **)error {
    if (![super validateData:data error:error])
        return NO;

    if (minLength && [*data length] < minLength) {
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:XBValidationStringTooShort
                                 userInfo:@{
                                         NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"validation: string too short", @"String must be at least %d characters long"), minLength]
                                 }];

        return NO;
    }

    if (maxLength && [*data length] > maxLength) {
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:XBValidationStringTooLong
                                 userInfo:@{
                                         NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"validation: string too short", @"String must be shorter then %d characters long"), maxLength]
                                 }];

        return NO;
    }

    return YES;
}

@end