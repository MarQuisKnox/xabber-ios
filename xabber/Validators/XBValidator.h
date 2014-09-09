//
// Created by Dmitry Sobolev on 09/09/14.
// Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XBValidator <NSObject>

@required - (BOOL)validateData:(id *)data error:(NSError **)error;

@end