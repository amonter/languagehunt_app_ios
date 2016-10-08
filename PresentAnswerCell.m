//
//  PresentAnswerCell.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 20/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "PresentAnswerCell.h"


@implementation PresentAnswerCell
@synthesize addButton;
@synthesize subButton, theField;
@synthesize row;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		CGRect frame = CGRectMake(18.0, 11.0, 289, 31);
		UITextField *textFieldRounded = [[UITextField alloc] initWithFrame:frame];		
		textFieldRounded.borderStyle = UITextBorderStyleBezel;
		textFieldRounded.textColor = [UIColor blackColor];				
		textFieldRounded.backgroundColor = [UIColor whiteColor];
		textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		textFieldRounded.adjustsFontSizeToFitWidth = YES;
		textFieldRounded.keyboardType = UIKeyboardTypeDefault;
		textFieldRounded.returnKeyType = UIReturnKeyNext;
		textFieldRounded.textAlignment =  UITextAlignmentLeft;      
 		self.theField = textFieldRounded;
		
		[self.contentView addSubview:self.theField];
		
		
		UIButton *theSubButton = [UIButton buttonWithType:UIButtonTypeCustom];		
		[theSubButton setFrame:CGRectMake(35, 41, 72, 37)];	
		[theSubButton setBackgroundImage:[[UIImage imageNamed:@"minus.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];			
		self.subButton = theSubButton;	
		[self.contentView addSubview:self.subButton];	
		
		
		UIButton *theAddButton = [UIButton buttonWithType:UIButtonTypeCustom];		
		[theAddButton setFrame:CGRectMake(230, 41, 47, 34)];	
		[theAddButton setBackgroundImage:[[UIImage imageNamed:@"circle.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];			
		self.addButton = theAddButton;	
		[self.contentView addSubview:self.addButton];		
				
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}


- (void)dealloc {
	[theField release];
	[addButton release];
	[subButton release];
    [super dealloc];
}


@end
