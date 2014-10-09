//
//  XBContactViewCell.m
//  xabber
//
//  Created by Dmitry Sobolev on 09/10/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBContactViewCell.h"
#import "XBXMPPConnector.h"
#import "XBContact.h"

@implementation XBContactViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithObject:(XBContact *)object {
    if (![object isKindOfClass:[XBContact class]]) {
        return;
    }

    self.contactName.text = object.contactName;
    self.statusText.text = object.statusText;
    self.statusShow.text = [self statusShowOfContact:object];
}

- (NSString *)statusShowOfContact:(XBContact *)contact {
    if (!contact.isOnline) {
        return @"Offline";
    }

    if (contact.status == XBContactStatusAvailable) {
        return @"Available";
    }

    if (contact.status == XBContactStatusChat) {
        return @"Chat";
    }

    if (contact.status == XBContactStatusAway) {
        return @"Away";
    }

    if (contact.status == XBContactStatusXA) {
        return @"XA";
    }

    if (contact.status == XBContactStatusDnD) {
        return @"DnD";
    }

    return @"Available";
}


@end
