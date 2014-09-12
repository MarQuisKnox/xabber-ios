//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBClassValidator.h"
#import "OCMArg.h"
#import "XBError.h"

@interface XBClassValidator() {
    Class testClass;
}
@end

@implementation XBClassValidator
- (instancetype)initWithTestClass:(Class)aClass {
    self = [super init];
    if (self) {
        testClass = aClass;
    }

    return self;
}

+ (instancetype)validatorWithTestClass:(Class)aClass {
    return [[self alloc] initWithTestClass:aClass];
}


- (BOOL)validateData:(id *)data error:(NSError **)error {
    if (![super validateData:data error:error]) {
        return NO;
    }

    if (![*data isKindOfClass:testClass]) {
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:XBValidationIncorrectClass
                                 userInfo:@{
                                         NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"validation: incorrect class", @"Object must be instance of %@ class"), NSStringFromClass(testClass)]
                                 }];
        return NO;
    }

    return YES;
}

@end