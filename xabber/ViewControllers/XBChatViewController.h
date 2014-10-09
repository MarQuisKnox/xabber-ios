//
//  XBChatViewController.h
//  xabber
//
//  Created by Dmitry Sobolev on 09/10/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBContact;

@interface XBChatViewController : UIViewController

@property (nonatomic, weak) XBContact *contact;

@end
