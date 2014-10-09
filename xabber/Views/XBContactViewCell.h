//
//  XBContactViewCell.h
//  xabber
//
//  Created by Dmitry Sobolev on 09/10/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBFillCellWithObject.h"

@interface XBContactViewCell : UITableViewCell <XBFillCellWithObject>
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *statusShow;
@property (weak, nonatomic) IBOutlet UILabel *statusText;

@end
