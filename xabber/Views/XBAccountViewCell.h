//
//  XBAccountViewCell.h
//  xabber
//
//  Created by Dmitry Sobolev on 15/09/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBFillCellWithObject.h"

@interface XBAccountViewCell : UITableViewCell <XBFillCellWithObject>
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *accountState;
@end
