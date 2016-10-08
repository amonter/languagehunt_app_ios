//
//  MatchConnectionCell.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 29/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "MatchConnectionCell.h"

@implementation MatchConnectionCell
@synthesize theImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
