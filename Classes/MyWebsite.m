//
//  MyWebsite.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 17/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "MyWebsite.h"


@implementation MyWebsite

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier theLabel:(NSString *) aLabel {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		
		UIView *wrapInfluence = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 54)];
		[wrapInfluence setBackgroundColor:[UIColor grayColor]];
		
		UIView *innerFieldView = [[UIView alloc] initWithFrame: CGRectMake(9, 7, 302, 40)];
		[innerFieldView setBackgroundColor:[UIColor whiteColor]];
		[innerFieldView addSubview:[self textFieldRounded]];
		
		UILabel *createdByLabelObj = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, 0, self.frame.size.width-60, self.frame.size.height-20)];	
		createdByLabelObj.lineBreakMode = UILineBreakModeWordWrap;
		createdByLabelObj.numberOfLines = 0;
		createdByLabelObj.tag = 24;		
		createdByLabelObj.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.5]; //Same font used 
		createdByLabelObj.textColor = [UIColor colorWithRed:51.0/255.0 green:204.0/255.0 blue:51.0/255.0 alpha:1];
		createdByLabelObj.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		createdByLabelObj.backgroundColor = [UIColor clearColor];	
		
		[wrapInfluence addSubview:innerFieldView];
		
		[self.contentView addSubview: wrapInfluence];
		[wrapInfluence release];
		[innerFieldView release];
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (UITextField *)textFieldRounded
{
	
	CGRect frame = CGRectMake(96.0, 6.0, 199, 31);
	UITextField *textFieldRounded = [[UITextField alloc] initWithFrame:frame];
	
	textFieldRounded.borderStyle = UITextBorderStyleNone;
	textFieldRounded.textColor = [UIColor blackColor];
	textFieldRounded.font = [UIFont systemFontOfSize:17.0];		
	textFieldRounded.backgroundColor = [UIColor lightGrayColor];
	textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	textFieldRounded.keyboardType = UIKeyboardTypeDefault;
	textFieldRounded.returnKeyType = UIReturnKeyDone;
	
	textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	textFieldRounded.tag = 3;		// tag this control so we can remove it later for recycled cells
	
	//textFieldRounded.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	
	// Add an accessibility label that describes what the text field is for.
	[textFieldRounded setAccessibilityLabel:NSLocalizedString(@"RoundedTextField", @"")];
	
	return textFieldRounded;
}



- (void)dealloc {	
    [super dealloc];
}

@end
