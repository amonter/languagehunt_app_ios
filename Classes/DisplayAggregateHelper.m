//
//  DisplayAggregateHelper.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 10/02/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "DisplayAggregateHelper.h"
#import "Question.h"
#import "AsyncImageView.h"
#import "Answer.h"
#import "UIViewStatistics.h"
#import "UIViewStatistics.h"
#import "PrepareUIViewStatistics.h"


@implementation DisplayAggregateHelper
@synthesize remoteViewController, offsetHeight;


- (Question *) parseQuestionObject:(NSDictionary *) theDictionary {

	Question *newQuestion = [[Question alloc] init];
	newQuestion.description = [theDictionary objectForKey:@"questionDescription"];		
	newQuestion.latitude = [[theDictionary objectForKey:@"latitude"] doubleValue];
	newQuestion.longitude = [[theDictionary objectForKey:@"longitude"] doubleValue];
	
	NSArray *theAnswer = [theDictionary objectForKey:@"answers"];	
	NSMutableArray *theAnswers = [[NSMutableArray alloc] init];
	for (NSDictionary *theDicObj in theAnswer) {
		
		Answer *theAnswer = [[Answer alloc] init];		
		theAnswer.answerDescription = [theDicObj objectForKey:@"textualAnswer"];
		theAnswer.resStat = [[theDicObj objectForKey:@"answerNumber"] intValue];
		[theAnswers addObject:theAnswer];
		[theAnswer release];
	} 	
	
	newQuestion.answers = theAnswers;
	[theAnswers release];
	
	return newQuestion;
}


- (void) displayResults: (NSDictionary *) theDictionary {
	
	NSDictionary *aDictionary = [theDictionary objectForKey:@"question"];
	
	Question *newQuestion = [self parseQuestionObject:aDictionary];
	newQuestion.questionPhoneId  = self.remoteViewController.questionObject.questionPhoneId;
	
	self.remoteViewController.questionObject = [newQuestion retain];
	self.remoteViewController.profiles = [aDictionary objectForKey:@"profiles"];		
	[self drawStatsResults];
	[self.remoteViewController.view setNeedsDisplay];
	[newQuestion release];
	
	
	[self.remoteViewController.loadingView removeFromSuperview];
	
}

- (void) drawStatsResults {
	
	PrepareUIViewStatistics *prepView = [[PrepareUIViewStatistics alloc] init];	
	self.remoteViewController.theStatsView = [prepView drawStatsResults:self.remoteViewController.questionObject theView:self.remoteViewController.theScrollView theYValue:200];	
	self.offsetHeight = prepView.offsetHeight;
	[prepView release];		
}

- (void) drawProfile {
	
	CGRect theFrame = [UIScreen mainScreen].applicationFrame;		
	theFrame.size.height = 100;	
	theFrame.origin.x = 0.0;
	theFrame.origin.y = self.offsetHeight + 30;
	
	UIView *outerGray = [[UIView alloc] initWithFrame:theFrame];
	[outerGray setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]];	
	
	UIImageView *totalAnswers = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,16)];
	UIImage *theImage = [UIImage imageNamed:@"pink.png"];
	totalAnswers.image = theImage;
	
	
	UILabel *totalAnswersLabel = [[UILabel alloc] initWithFrame:CGRectMake(6,0, 280, 16)];	
	totalAnswersLabel.lineBreakMode = UILineBreakModeWordWrap;
	totalAnswersLabel.numberOfLines = 0;	
	totalAnswersLabel.textAlignment = UITextAlignmentLeft;
	totalAnswersLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0]; //Same font used 
	totalAnswersLabel.textColor = [UIColor blackColor];	
	totalAnswersLabel.backgroundColor = [UIColor clearColor];	
	totalAnswersLabel.text = [NSString stringWithFormat:@"6 Contributors in 6 locations"];	
	
	[totalAnswers addSubview:totalAnswersLabel];
	[totalAnswersLabel release];
	[outerGray addSubview:totalAnswers];
	[totalAnswers release];	
	
	
	UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(7,19, 280, 16)];	
	instructionsLabel.lineBreakMode = UILineBreakModeWordWrap;
	instructionsLabel.numberOfLines = 0;	
	instructionsLabel.textAlignment = UITextAlignmentLeft;
	instructionsLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:12.0]; //Same font used 
	instructionsLabel.textColor = [UIColor blackColor];	
	instructionsLabel.backgroundColor = [UIColor clearColor];	
	instructionsLabel.text = [NSString stringWithFormat:@"Click on photo to see answers"];	
	[outerGray addSubview:instructionsLabel];
	[instructionsLabel release];
	
	[self.remoteViewController.theScrollView addSubview:outerGray];
	[outerGray release];	
	
	int yValue = self.offsetHeight + 150;
	int xValue = 5;
	NSLog(@"");
	
	UIButton *overbutton = [UIButton buttonWithType:UIButtonTypeCustom];			
	[overbutton setFrame:CGRectMake(xValue, yValue, 60, 60)];	
	[overbutton addTarget:self.remoteViewController action:@selector(alertMe) forControlEvents:UIControlEventTouchUpInside];				
	
	
	
	UIImageView *dummyView = [[UIImageView alloc] initWithFrame:CGRectMake(xValue, yValue, 60, 60)];
	dummyView.userInteractionEnabled = YES;	
	
	NSData *receivedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://a3.twimg.com/profile_images/59762219/profilePhoto1_normal.JPG"]];
	UIImage *profileImage = [[UIImage alloc] initWithData:receivedData];
	
	dummyView.image = profileImage;		
	[self.remoteViewController.theScrollView addSubview:dummyView];
	[self.remoteViewController.theScrollView addSubview:overbutton];
	
	[dummyView release];
	
	
	/*
	for (NSDictionary *aProfile in theProfile) {						
		
		NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
		UIButton *overbutton = [[UIButton buttonWithType:UIButtonTypeCustom] autorelease];		
		[overbutton setFrame:CGRectMake(xValue, yValue, 32, 32)];	
		[overbutton addTarget:self.remoteViewController action:@selector(viewProfile) forControlEvents:UIControlEventTouchUpInside];				
		
		AsyncImageView *asyncImageView = [[[AsyncImageView alloc] initWithFrame:CGRectMake(xValue, yValue, 32, 32)] autorelease];
		NSString *profileImage = [aProfile objectForKey:@"profileImageUrl"];					
		NSURL *url = [NSURL URLWithString:profileImage]; 
		[asyncImageView loadImageFromURL:url theImageFrame:CGRectMake(xValue, yValue, 32, 32)];
		[asyncImageView addSubview:overbutton];
		[self.remoteViewController.theScrollView addSubview:asyncImageView];
		
		xValue = xValue + 37;
		if (counter % 4 == 0) {
			yValue = yValue + 42; 	
			xValue = 5;
		}
		counter++;
		[loopPool release];
	}	
	 */
	
}




- (void)dealloc {	
	[remoteViewController release];
    [super dealloc];
}

@end
