//
//  XBTypes.h
//  xabber
//
//  Created by Dmitry Sobolev on 11/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//


typedef enum {
    XBAccountStatusAvailable,
    XBAccountStatusChat,
    XBAccountStatusAway,
    XBAccountStatusXA,
    XBAccountStatusDnD
} XBAccountStatus;

typedef enum {
    XBConnectionStateOffline,
    XBConnectionStateConnecting,
    XBConnectionStateOnline,
    XBConnectionStateDisconnecting,
} XBConnectionState;
