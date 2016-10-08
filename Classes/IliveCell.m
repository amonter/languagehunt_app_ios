//
//  IliveCell.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 17/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "IliveCell.h"


@implementation IliveCell
@synthesize theField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier theLabel:(NSString *) aLabel{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {       
		
		UIView *wrapInfluence = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 54)];
		[wrapInfluence setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1]];
		
		UIView *innerFieldView = [[UIView alloc] initWithFrame: CGRectMake(9, 7, 302, 40)];
		[innerFieldView setBackgroundColor:[UIColor whiteColor]];
		[innerFieldView addSubview:[self textFieldRounded]];
		
		UILabel *createdByLabelObj = [[UILabel alloc] initWithFrame:CGRectMake(0,9,88, 21)];	
		createdByLabelObj.lineBreakMode = UILineBreakModeWordWrap;
		createdByLabelObj.text = aLabel;
		createdByLabelObj.numberOfLines = 0;
		createdByLabelObj.tag = 24;		
		createdByLabelObj.font = [UIFont fontWithName:@"Helvetica-Bold" size:15]; //Same font used 
		createdByLabelObj.textColor = [UIColor grayColor];
		createdByLabelObj.textAlignment = UITextAlignmentRight;
		createdByLabelObj.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		createdByLabelObj.backgroundColor = [UIColor clearColor];	
		[innerFieldView addSubview:createdByLabelObj];
		
		[wrapInfluence addSubview:innerFieldView];
		
		[self.contentView addSubview: wrapInfluence];
		[wrapInfluence release];
		[innerFieldView release];
		[createdByLabelObj release];
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UITextField *)textFieldRounded
{
	
		CGRect frame = CGRectMake(96.0, 5.0, 199, 31);
		UITextField *textFieldRounded = [[UITextField alloc] initWithFrame:frame];		
		textFieldRounded.borderStyle = UITextBorderStyleBezel;
		textFieldRounded.textColor = [UIColor blackColor];
		//textFieldRounded.font = [UIFont systemFontOfSize:22.0];		
		textFieldRounded.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1];
		textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		textFieldRounded.adjustsFontSizeToFitWidth = YES;
		textFieldRounded.keyboardType = UIKeyboardTypeDefault;
		textFieldRounded.returnKeyType = UIReturnKeyNext;
		textFieldRounded.textAlignment =  UITextAlignmentLeft;       		
		textFieldRounded.tag = 3;		// tag this control so we can remove it later for recycled cells		
		self.theField = textFieldRounded;
	
	return textFieldRounded;
}



- (void)dealloc {
	[theField release];
    [super dealloc];
}


@end
