//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBRequiredValidator.h"
#import "XBError.h"


@implementation XBRequiredValidator {

}
- (BOOL)validateData:(id *)data error:(NSError **)error {
    if (data == NULL || *data == nil) {
        *error = [NSError errorWithDomain:XBXabberErrorDomain
                                     code:XBValidationObjectIsNilError
                                 userInfo:@{
                                         NSLocalizedDescriptionKey: NSLocalizedString(@"validation: object must not be nil", @"Object must not be equal to nil")
                                 }];
        return NO;
    }

    return YES;
}

@end