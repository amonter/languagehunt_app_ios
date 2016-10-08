//
//  StatsRemoteViewController.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 29/01/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 
#import "StatsProfileViewController.h"
#import "RetrieveQuestionData.h"
#import "ProcessQuestionSQL.h"
#import "UIViewStatistics.h"
#import "RetrieveQuestionData.h"
#import "Answer.h"
#import "DisplayAggregateHelper.h"
#import "AsyncImageView.h"
#import "PrepareUIViewStatistics.h"
#import "MapViewQuestion.h"


@implementation StatsRemoteViewController
@synthesize questionid, asyncImage;
@synthesize retrieveQuestionProfiles;
@synthesize questionObject;
@synthesize profiles;
@synthesize showAggregatedResults;
@synthesize loadingView;
@synthesize theScrollView;
@synthesize theStatsView;
@synthesize yOffset;
@synthesize isUpdated;



- (void) viewDidLoad {	
		
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//Loading
	LoadingAnimationView *loadingViewObj = [[LoadingAnimationView alloc] initWithFrame: CGRectMake(0, 0, 140, 80)];	
	self.loadingView = loadingViewObj;
	[loadingViewObj release];
	[self.view addSubview:self.loadingView];
	
	//Retrieve
	RetrieveQuestionData *statsObject =  [[RetrieveQuestionData alloc] init];
	self.retrieveQuestionProfiles = statsObject;		
	
	[theScrollView setBackgroundColor:[UIColor clearColor]];
	[theScrollView setCanCancelContentTouches:NO];
	theScrollView.maximumZoomScale = 3.0;
	theScrollView.minimumZoomScale = 0.55;
	theScrollView.delegate = self;
	theScrollView.clipsToBounds = YES;	// default is NO, we want to restrict drawing within our scrollview
	theScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;	
	[theScrollView setCanCancelContentTouches:NO];
	theScrollView.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1];
	
	if (showAggregatedResults) {			
		self.retrieveQuestionProfiles.retrieveAggregateAnswers = YES;
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(displayTheAggregate:)
													 name:@"finishedConnection" object: self.retrieveQuestionProfiles];	
		self.navigationItem.title = @"Total";		
		UIBarButtonItem *totalButtonObj = [[UIBarButtonItem alloc] initWithTitle:@"MAP" style: UIBarButtonItemStyleDone
																		  target:self
																		  action:@selector(viewComments)];	
		
		//self.navigationItem.rightBarButtonItem = totalButtonObj;
		[totalButtonObj release];
	}
		
	[statsObject release];
	[self.retrieveQuestionProfiles retrieveQuestionProfiles:self.questionObject.questionPhoneId];	
	[super viewDidLoad];		
}


- (void) viewComments {
	
	/*
	ViewCommentsController *comments = [[ViewCommentsController alloc] initWithNibName:@"ViewCommentsController" bundle:nil];
	comments.questionObject = questionObject;
	[self.navigationController pushViewController:comments animated:YES];
	[comments release];
	 */
	MapViewQuestion *theMap = [[MapViewQuestion alloc] initWithNibName:@"MapViewQuestion" bundle:nil];
	NSMutableDictionary * theDic = [[NSMutableDictionary alloc] init];		
			
	[theDic setObject:self.questionObject forKey:[NSString stringWithFormat:@"%i", self.questionObject.questionPhoneId]];				
	self.questionObject.isUpdated = self.isUpdated;	
	[self.navigationController pushViewController:theMap animated:YES];
	[theMap release];		
	
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

	return self.theStatsView;
}


- (void)displayTheAggregate: (NSNotification *) theResult {
	
	NSDictionary *theDictionary =  [theResult userInfo];	
	DisplayAggregateHelper *helper = [[DisplayAggregateHelper alloc] init];
	helper.remoteViewController = [self retain];
	[helper displayResults: theDictionary];	
	self.yOffset = helper.offsetHeight;
	[helper release];
	[self drawProfile];	
}


- (void) drawProfile {
	
	CGRect theFrame = [UIScreen mainScreen].applicationFrame;		
	theFrame.size.height = 100;	
	theFrame.origin.x = 0.0;
	theFrame.origin.y = 30 + self.yOffset;
	
	UIView *outerGray = [[UIView alloc] initWithFrame:theFrame];
	[outerGray setBackgroundColor:[UIColor clearColor]];	
	
	UIView *totalAnswers = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,21)];
	totalAnswers.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:144.0/255.0 blue:0.0/255.0 alpha:1];		
	
	UILabel *totalAnswersLabel = [[UILabel alloc] initWithFrame:CGRectMake(6,3, 280, 16)];	
	totalAnswersLabel.lineBreakMode = UILineBreakModeWordWrap;
	totalAnswersLabel.numberOfLines = 0;	
	totalAnswersLabel.textAlignment = UITextAlignmentLeft;
	totalAnswersLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0]; //Same font used 
	totalAnswersLabel.textColor = [UIColor blackColor];	
	totalAnswersLabel.backgroundColor = [UIColor clearColor];	
	totalAnswersLabel.text = [NSString stringWithFormat:@"%i Contributors in %i locations",[self.profiles count],[self.profiles count]];	
	
	[totalAnswers addSubview:totalAnswersLabel];
	[totalAnswersLabel release];
	[outerGray addSubview:totalAnswers];
	[totalAnswers release];	
	
	
	UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(13,21, 280, 16)];	
	instructionsLabel.lineBreakMode = UILineBreakModeWordWrap;
	instructionsLabel.numberOfLines = 0;	
	instructionsLabel.textAlignment = UITextAlignmentLeft;
	instructionsLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:12.0]; //Same font used 
	instructionsLabel.textColor = [UIColor blackColor];	
	instructionsLabel.backgroundColor = [UIColor clearColor];	
	instructionsLabel.text = [NSString stringWithFormat:@"Click on photo to see answers"];	
	[outerGray addSubview:instructionsLabel];
	[instructionsLabel release];
	
	[self.theScrollView addSubview:outerGray];
	[outerGray release];			
	
	int counter = 0;
	int yValue = self.yOffset + 80;
	int xValue = 13;
	
	for (NSDictionary *aProfile in self.profiles) {						
	 
		 NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
         UIButton *overbutton = [UIButton buttonWithType: UIButtonTypeCustom];
		 overbutton.tag = counter;
		 [overbutton setFrame:CGRectMake(xValue,yValue, 60, 60)];	
		 [overbutton addTarget:self action:@selector(alertMe:) forControlEvents:UIControlEventTouchUpInside];		
		 
		 AsyncImageView *asyncImageView = [[[AsyncImageView alloc] initWithFrame:CGRectZero] autorelease];	
		 asyncImageView.notify = false;	
		 asyncImageView.userInteractionEnabled = YES;
		 [self.theScrollView addSubview:asyncImageView];
		 [self.theScrollView addSubview:overbutton];		 
		 
		 NSURL *url = [NSURL URLWithString:[aProfile objectForKey:@"profileImageUrl"]]; 
		 [asyncImageView loadImageFromURL:url theImageFrame:CGRectMake(xValue,yValue, 60, 60)];

	 
		 xValue = xValue + 78;
		 counter++;
		 if (counter % 4 == 0) {
			 yValue = yValue + 70; 	
			 xValue = 13;
		 }
		 
		 [loopPool release];
	 }	
}


- (IBAction) backToQuestions {
	
	[self.navigationController popViewControllerAnimated:YES];	
}


- (void) alertMe:(id)sender {
	
	int theRow = ((UIButton *)sender).tag;	
	NSDictionary *theProfileDic = [profiles objectAtIndex:theRow]; 		
	
	StatsProfileViewController *profileView = [[StatsProfileViewController alloc] initWithNibName:@"StatsProfileViewController" bundle:nil];
	profileView.theProfile = theProfileDic;
	profileView.questionPhoneId = self.questionObject.questionPhoneId;
	
	[self.navigationController pushViewController:profileView animated:YES];	
	[profileView release];
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
	[asyncImage release];
	[theScrollView release];	
	[loadingView release];
	[profiles release];
	[questionObject release];	
	[retrieveQuestionProfiles release];		
    [super dealloc];
}


@end
