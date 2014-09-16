//
//  XBAccountViewCell.m
//  xabber
//
//  Created by Dmitry Sobolev on 15/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBAccountViewCell.h"
#import "XBXMPPConnector.h"
#import "XBAccount.h"

@implementation XBAccountViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithObject:(id)object {
    if (![object isKindOfClass:[XBAccount class]]) {
        return;
    }

    XBAccount *account = object;

    self.accountName.text = account.accountJID;
    self.accountState.text = [self stateLabelByAccount:account];
}

- (NSString *)stateLabelByAccount:(XBAccount *)account {
    NSString *labelText = nil;

    switch (account.state) {
        case XBConnectionStateOffline:
            labelText = @"Offline";
            break;
        case XBConnectionStateConnecting:
            labelText = @"Connecting...";
            break;
        case XBConnectionStateOnline:
            labelText = @"Online";
            break;
        case XBConnectionStateDisconnecting:
            labelText = @"Disconnecting...";
            break;
        default:
            labelText = @"";
    }

    return labelText;
}

@end
