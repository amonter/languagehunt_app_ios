//
//  PrepareUIViewStatistics.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 25/03/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "PrepareUIViewStatistics.h"
#import "UIViewStatistics.h"
#import "AltAnswerView.h"
#import <QuartzCore/QuartzCore.h> 

@implementation PrepareUIViewStatistics
@synthesize asyncImage, offsetHeight;

- (UIViewStatistics *) drawStatsResults:(Question *) theQuestion theView:(UIScrollView *) view theYValue:(int) yvalue{
	
	int graphWidth = 320;	
	
	//Calculate Height according to answers
	int size = [theQuestion.answers count];	
	int heightDefault = 332;
	if (size > 2) {
		int res = size * 18;	
		heightDefault = heightDefault + res;		
	}
	
	//Create Outer gray
	CGRect theFrame = [UIScreen mainScreen].applicationFrame;
	theFrame.size.width = graphWidth -12;	
	theFrame.size.height = heightDefault;	
	theFrame.origin.x = 6.0;
	theFrame.origin.y = 5.0;	
	UIView *outerGray = [[UIView alloc] initWithFrame:theFrame];
	[outerGray setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]];	
	
	
	//Inner white
	theFrame.size.width = graphWidth -22;	
	theFrame.size.height = heightDefault -10;	
	theFrame.origin.x = 5.0;
	theFrame.origin.y = 5.0;
	UIViewStatistics *theStats = [[[UIViewStatistics alloc] initWithFrame:theFrame uiImageFrame:CGRectMake(0,45,200,160)] autorelease];				
	[theStats setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[theStats setBackgroundColor:[UIColor whiteColor]];
	theStats.graphWidth = 290;
	theStats.graphHeight = 160;
	theStats.questionObj = theQuestion;	
	
	UILabel *questionDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,2, 280, 40)];	
	questionDesLabel.lineBreakMode = UILineBreakModeWordWrap;
	questionDesLabel.numberOfLines = 0;
	questionDesLabel.tag = 24;
	questionDesLabel.textAlignment = UITextAlignmentLeft;
	questionDesLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0]; //Same font used 
	//questionDesLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:204.0/255.0 blue:51.0/255.0 alpha:1];
	questionDesLabel.textColor = [UIColor blackColor];
	questionDesLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	questionDesLabel.backgroundColor = [UIColor clearColor];	
	questionDesLabel.text = theQuestion.description;		
	[theStats addSubview:questionDesLabel];	
	[questionDesLabel release];	
	
	//290,160	
	theStats.yValue = yvalue;
	theStats.answerArray = [[theQuestion getSortedAnswers] retain];	
	
	AsyncImageView *theGraphView = [theStats getGraphic:[[theQuestion getSortedAnswers] retain] questionDes:theQuestion.description];
	self.asyncImage = theGraphView;
	[theStats addSubview:theGraphView];		
	
	//Add total answers image
	UIView *totalAnswers = [[UIView alloc] initWithFrame:CGRectMake(4,heightDefault - 33,290,21)];
	totalAnswers.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:242.0/255.0 blue:0.0/255.0 alpha:1];
		
	
	UILabel *totalAnswersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,3, 280, 16)];	
	totalAnswersLabel.lineBreakMode = UILineBreakModeWordWrap;
	totalAnswersLabel.numberOfLines = 0;	
	totalAnswersLabel.textAlignment = UITextAlignmentRight;
	totalAnswersLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0]; //Same font used 
	totalAnswersLabel.textColor = [UIColor blackColor];	
	totalAnswersLabel.backgroundColor = [UIColor clearColor];	
	totalAnswersLabel.text = [NSString stringWithFormat:@"Total people asked: %i", [theQuestion totalAnswerCount]];		
	[totalAnswers addSubview:totalAnswersLabel];
	
	[theStats addSubview:totalAnswers];
	[totalAnswers release];	
	
	//add content	
	[outerGray addSubview:theStats];
	[view addSubview:outerGray];
	[outerGray release];
	
	//add alternative answers
	int sizeAlt = [theQuestion.altAnswers count];	
	int heightDefaultAlt = 100;
	if (sizeAlt > 2) {
		int res = (sizeAlt/2) + 45;	
		heightDefaultAlt = heightDefaultAlt + res;		
	}	
	
	CGRect theFrameAlt = [UIScreen mainScreen].applicationFrame;
	theFrameAlt.size.width = graphWidth -12;	
	theFrameAlt.size.height = heightDefaultAlt;	
	theFrameAlt.origin.x = 6.0;
	theFrameAlt.origin.y = heightDefault + 30;
	
	// Other Answers View
	/*
	AltAnswerView *altView = [[[AltAnswerView alloc] initWithFrame:theFrameAlt questionP:theQuestion] autorelease];
	[altView setBackgroundColor:[UIColor lightGrayColor]];
	[view addSubview:altView];			
	self.offsetHeight = (heightDefault + 30) + heightDefaultAlt;
	*/
	
	self.offsetHeight = (heightDefault + 30);	 
	[view setContentSize:CGSizeMake(theStats.frame.size.width, 1000)];
	[view setScrollEnabled:YES];	
	
	return theStats;
}


- (void)dealloc {
	[asyncImage	release];
    [super dealloc];
}


@end
