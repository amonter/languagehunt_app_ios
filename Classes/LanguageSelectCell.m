//
//  LanguageSelectCell.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 7/7/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "LanguageSelectCell.h"

@implementation LanguageSelectCell
@synthesize previousSelected;

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

    //NSLog(@"LanguageSelectCell -- %@ High %i", ((UILabel*)[self.contentView viewWithTag:44555]).text, self.selected);
    UIImageView* theImage = (UIImageView*) [self.contentView viewWithTag:992182];
    if (selected) {
        if (theImage == nil) {
            [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"orange.png"]]];           
        }
    } else if (theImage == nil){
        [self setBackgroundColor:[UIColor clearColor]];
    }
}


@end
