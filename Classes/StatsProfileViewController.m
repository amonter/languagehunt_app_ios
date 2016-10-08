//
//  StatsProfileViewController.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 08/02/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "StatsProfileViewController.h"
#import "RetrieveQuestionData.h"
#import "UIViewStatistics.h"
#import "Question.h"
#import "Answer.h"


@implementation StatsProfileViewController
@synthesize retrieveQuestionStats;
@synthesize questionPhoneId;
@synthesize loadingView;
@synthesize theProfile;
@synthesize theTitle;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	CGRect aRect = [UIScreen mainScreen].applicationFrame;	
	UIViewStatistics *theStats = [[UIViewStatistics alloc] initWithFrame:aRect uiImageFrame:CGRectMake(8,70,290,160)];	
	
	[theStats setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[theStats setBackgroundColor:[UIColor clearColor]];
	theStats.tag = 87;
	
	
	RetrieveQuestionData *retrieveStatsObj = [[RetrieveQuestionData alloc] init];	
	self.retrieveQuestionStats = retrieveStatsObj;
	[retrieveStatsObj release];
	
	LoadingAnimationView *loadingViewObj = [[LoadingAnimationView alloc] initWithFrame: CGRectMake(0, 0, 140, 80)]; 
	self.loadingView = loadingViewObj;
	[loadingViewObj release];
	
	[theStats addSubview:self.loadingView];
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(4, 0, 50, 50)];
	imageView.contentMode = UIViewContentModeScaleAspectFit;	
	
	NSString *imageURL = [theProfile objectForKey:@"profileImageUrl"];
	NSData *receivedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
	UIImage *theImage = [[UIImage alloc] initWithData:receivedData];
	imageView.image = theImage;
	
	[theStats addSubview:imageView];	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(displayTheView:)
													 name:@"finishedConnection" object: self.retrieveQuestionStats];	
	
	NSDictionary *theUser = [theProfile objectForKey:@"user"];
	NSString *theUsername = [theUser objectForKey:@"userName"];
	theTitle.title = [theUser objectForKey:@"lastName"];	
	int questionId = [[self.theProfile objectForKey:@"questionIdBackend"] intValue];
	
	[retrieveQuestionStats retrieveProfileStats:questionId username:theUsername];
	self.navigationItem.title = [theUser objectForKey:@"lastName"];	
	
	[self.view addSubview:theStats];
	[theStats release];
	[imageView release];
	[theImage release];
    [super viewDidLoad];
}


- (void)displayTheView: (NSNotification *) theResult {

	NSDictionary *stats = [theResult userInfo];
	NSDictionary *aDictionary = [stats objectForKey:@"question"];
	Question *newQuestion = [[Question alloc] init];
	newQuestion.description = [aDictionary objectForKey:@"questionDescription"];		
	
	NSArray *theAnswer = [aDictionary objectForKey:@"answers"];	
	NSMutableArray *theAnswers = [[NSMutableArray alloc] init];
	for (NSDictionary *theDicObj in theAnswer) {
		
		Answer *theAnswer = [[Answer alloc] init];		
		theAnswer.answerDescription = [theDicObj objectForKey:@"textualAnswer"];
		theAnswer.resStat = [[theDicObj objectForKey:@"answerNumber"] intValue];
		[theAnswers addObject:theAnswer];
		[theAnswer release];
	} 		
	
	newQuestion.answers = theAnswers;
	
	UIViewStatistics *theStats = (UIViewStatistics *) [self.view viewWithTag:87];
	theStats.graphWidth = 290;
	theStats.graphHeight = 169;
	theStats.yValue = 235;
	theStats.answerArray = [newQuestion getSortedAnswers];
	
	//User stats label
	UILabel *description = [[UILabel alloc] initWithFrame: CGRectMake(80, 0, 200, 50)] ;
	description.lineBreakMode = UILineBreakModeWordWrap;
	description.numberOfLines = 0;
	description.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;	
	NSDictionary *theUser = [theProfile objectForKey:@"user"];	
	NSString *theCountry = [theUser objectForKey:@"country"];
	NSString *theState = [theUser objectForKey:@"state"];
	//NSString *username  = [theUser objectForKey:@"userName"];
	NSString *lastName  = [theUser objectForKey:@"lastName"];
	
	description.text = [NSString stringWithFormat:@"%@ asked people in %@, %@", lastName, theState, theCountry];

	description.backgroundColor = [UIColor clearColor];
	description.textColor = [UIColor blackColor];	
	description.font = [UIFont fontWithName:@"Verdana" size:14];	
	
	[theStats addSubview:description];
	
	//CGRect imageframe = CGRectMake(8,70,290,160);
	//UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageframe];
	AsyncImageView *imageGraph = [theStats getGraphic:[newQuestion getSortedAnswers] questionDes:newQuestion.description];
	[theStats addSubview:imageGraph];
	[theStats setNeedsDisplay];
	[loadingView removeFromSuperview];

	[newQuestion release];
	[theAnswers release];
}

- (IBAction) goBack {

	[self.navigationController popViewControllerAnimated:YES];
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
	[theProfile release];
	[loadingView release];
	[retrieveQuestionStats release];
    [super dealloc];
}


@end
