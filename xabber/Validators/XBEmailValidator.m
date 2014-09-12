//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBEmailValidator.h"
#import "XBError.h"


@implementation XBEmailValidator
- (id)init {
    self = [super initWithTestClass:[NSString class]];
    if (self) {

    }

    return self;
}


- (BOOL)validateData:(id *)data error:(NSError **)error {
    if (![super validateData:data error:error])
        return NO;

    NSString *emailRegExp =
            @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

    NSPredicate *checkEmailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegExp];

    if (![checkEmailPredicate evaluateWithObject:*data]) {
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:XBValidationIncorrectEmail
                                 userInfo:@{
                                         NSLocalizedDescriptionKey: NSLocalizedString(@"validation: incorrect email", @"Incorrect email string")
                                 }];

        return NO;
    }

    return YES;
}

@end