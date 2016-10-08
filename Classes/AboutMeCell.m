//
//  AboutMeCell.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 17/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "AboutMeCell.h"
#import "TextViewWithPlaceholder.h"


@implementation AboutMeCell
@synthesize aboutMeLabel;
@synthesize aboutMeView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *wrapInfluence = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 143)];
		[wrapInfluence setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1]];
		
		UIView *innerFieldView = [[UIView alloc] initWithFrame: CGRectMake(9, 7, 302, 130)];
		[innerFieldView setBackgroundColor:[UIColor whiteColor]];
		[innerFieldView addSubview:[self createTextView]];
		
		UILabel *createdByLabelObj = [[UILabel alloc] initWithFrame:CGRectMake(0,9,88, 21)];	
		createdByLabelObj.lineBreakMode = UILineBreakModeWordWrap;		
		createdByLabelObj.numberOfLines = 0;
		createdByLabelObj.text = @"about me";
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


- (UITextView *) createTextView {

	
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(96,6,199, 117)];
	textView.scrollEnabled = NO;
	//textView.userInteractionEnabled = NO;	
	textView.keyboardType = UIKeyboardTypeDefault;
	textView.returnKeyType = UIReturnKeyNext;
	textView.tag = 88;
	textView.backgroundColor = [UIColor grayColor];
	textView.textColor = [UIColor blackColor];
	textView.font = [UIFont systemFontOfSize:17.0];		
	self.aboutMeView = textView;
	
	return textView;
}
 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[aboutMeView release];
	[aboutMeLabel release];
    [super dealloc];
}


@end
