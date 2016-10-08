//
//  ProcessAnswerViewController.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 20/03/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "ProcessAnswerViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 1.3;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 700;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;



@implementation ProcessAnswerViewController
@synthesize theScrollView;
@synthesize addQuestionButton;
@synthesize positionButton;
@synthesize positionField;
@synthesize fields;
@synthesize theQuestion;


- (void) viewDidLoad {						
	
	self.theScrollView.contentSize = CGSizeMake(320, 700);
	[theScrollView setBackgroundColor:[UIColor clearColor]];
	[theScrollView setCanCancelContentTouches:NO];
	theScrollView.clipsToBounds = YES;	// default is NO, we want to restrict drawing within our scrollview
	theScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;	
	[theScrollView setCanCancelContentTouches:NO];
	[self.theScrollView  setScrollEnabled:YES];		
	
	UILabel *description = [[UILabel alloc] initWithFrame: CGRectMake(12, 10, self.view.bounds.size.width - 30, 180)] ;
	description.lineBreakMode = UILineBreakModeWordWrap;
	description.numberOfLines = 0;
	description.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	description.text = @"Insert your Answers";
	description.backgroundColor = [UIColor clearColor];
	description.textColor = [UIColor blueColor];	
	description.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];	
	[self.theScrollView addSubview:description];
	
	
	self.positionField = 150;
	UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 150, 260, 30)];
	myTextField.delegate = self;
	myTextField.tag = 1;
	[myTextField becomeFirstResponder];
	myTextField.returnKeyType = UIReturnKeyNext;
	[myTextField setBackgroundColor:[UIColor whiteColor]];
	myTextField.borderStyle = UITextBorderStyleLine;
	[fields addObject:myTextField];	
	[self.theScrollView addSubview:myTextField];	
	
	
	self.positionButton = 170;
	UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
	playButton.frame = CGRectMake(160, 170, 160.0, 44.0);	
	[playButton setTitle:@"Next Answer" forState:UIControlStateNormal];
	[playButton setTitle:@"Next Answer" forState:UIControlEventTouchUpInside];
	playButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
	playButton.titleLabel.textColor = [UIColor blackColor];
	[playButton addTarget:self action:@selector(removeButton) forControlEvents:UIControlEventTouchUpInside];	
	self.addQuestionButton = playButton;
	[self.theScrollView addSubview:playButton];
	
	[self.view addSubview:theScrollView];	
	[super viewDidLoad];	
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	CGRect textFieldRect = [self.theScrollView.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.theScrollView.window convertRect:self.theScrollView.bounds fromView:self.theScrollView];   
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	NSLog(@"midline %1.2f", midline);
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
	NSLog(@"numerator %1.2f denominator %1.2f", numerator,denominator);
    CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }	
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
	
	CGRect viewFrame = self.theScrollView.frame;
	NSLog(@"animated %1.2f", animatedDistance);
    viewFrame.origin.y -= animatedDistance;	
    
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.theScrollView setFrame:viewFrame];
	[self.theScrollView  setScrollEnabled:YES];	
    
    [UIView commitAnimations];
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
    CGRect viewFrame = self.theScrollView.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];    
    [self.theScrollView setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if (textField.tag == 1) {	
		[self removeButton];	
	}
	else {	
		[self awesomeAlert];	
	}
	
	return NO; 
}

- (void) removeButton {
	
	[self.addQuestionButton removeFromSuperview];
	[self addTextField];	
}


- (void) addTextField {
	
	[self.addQuestionButton removeFromSuperview];
	
	self.positionField = positionField + 50;
	UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, self.positionField, 260, 30)];
	myTextField.delegate = self;
	myTextField.returnKeyType = UIReturnKeyGo;
	[myTextField becomeFirstResponder];
	[myTextField setBackgroundColor:[UIColor whiteColor]];
	myTextField.borderStyle = UITextBorderStyleLine;
	[fields addObject:myTextField];
	[self.theScrollView addSubview:myTextField];
	
	self.positionButton = positionButton + 50;
	NSLog(@"position %i", self.positionButton);
	UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
	playButton.frame = CGRectMake(160, self.positionButton, 160.0, 44.0);
	[playButton setTitle:@"Another Answer" forState:UIControlStateNormal];
	[playButton setTitle:@"Another Answer" forState:UIControlEventTouchUpInside];
	playButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
	playButton.titleLabel.textColor = [UIColor blackColor];
	[playButton addTarget:self action:@selector(removeButton) forControlEvents:UIControlEventTouchUpInside];	
	self.addQuestionButton = playButton;
	[self.theScrollView addSubview:self.addQuestionButton];
	
	//[self.view addSubview:self.addQuestionButton];	
	
}


- (void) awesomeAlert {
	
	
	
	
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[addQuestionButton release];	
	[fields release];
	[theScrollView release];
    [super dealloc];
}






@end
