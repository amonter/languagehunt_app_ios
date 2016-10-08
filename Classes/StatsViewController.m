//
//  StatsViewController.m
//  Ousiastikos2
//
//  Created by Adrian Avendano on 09/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StatsViewController.h"
#import "Answer.h"

#import "UIViewStatistics.h"
#import "ProcessQuestionSQL.h"
#import "Question.h"
#import "AltAnswerView.h"
#import "ProcessQuestionSQL.h"
#import "MGTwitterHTTPURLConnection.h"
#import "OAuthTwitterDemoViewController.h"
#import "RealOusiastikosAppDelegate.h"
#import "PrepareUIViewStatistics.h"
#import "StatsRemoteViewController.h"
#import "TwitterMessageView.h"

@implementation StatsViewController
@synthesize username;
@synthesize questionid;
@synthesize questionObject;
@synthesize twitterDelegate;
@synthesize loadingView;
@synthesize theScrollView;
@synthesize theStatsView;
@synthesize toolBar;
@synthesize oAuth;
@synthesize theCounter;
@synthesize realTimer;
@synthesize isUpdated, yOffset;


- (void) viewDidLoad {	
	
	if (self.loadingView == nil) {
		LoadingAnimationView *loadingViewObj = [[LoadingAnimationView alloc] initWithFrame: CGRectMake(0, 0, 140, 80)]; 
		self.loadingView = loadingViewObj;
		[loadingViewObj release];		
	}	
	
	ProcessQuestionSQL *queryDelegate = [[ProcessQuestionSQL alloc] init];
	Question *resQuestion = [queryDelegate queryRetrieveAnswerStats:self.questionid];
	self.questionObject = [resQuestion retain];				
	[queryDelegate release];
	

	self.questionObject.isUpdated = self.isUpdated;
	if (!resQuestion.isPrivate) {		
			
		
		PrepareUIViewStatistics *prepView = [[PrepareUIViewStatistics alloc] init];				
		self.theStatsView = [prepView drawStatsResults:self.questionObject theView:self.theScrollView theYValue:200];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showTotalButton)
													 name:@"show_totalbutton" object: self.theStatsView];
		self.yOffset = prepView.offsetHeight;
		[self addOtherAnswers];
		[prepView release];			
		
		//[self.view addSubview:self.loadingView];
				
		//[retrieveQuestionStats sendStatistics:self.questionObject];	
				
		
	} else {
		 PrepareUIViewStatistics *prepView = [[PrepareUIViewStatistics alloc] init];
		 self.theStatsView = [prepView drawStatsResults:self.questionObject theView:self.theScrollView theYValue:200];			
		 self.yOffset = prepView.offsetHeight;
		 [prepView release];	
		 [self addOtherAnswers];
	}
		
	theScrollView.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1];	
	[theScrollView setCanCancelContentTouches:NO];
	theScrollView.maximumZoomScale = 3.0;
	theScrollView.minimumZoomScale = 0.55;
	theScrollView.delegate = self;
	theScrollView.clipsToBounds = YES;	// default is NO, we want to restrict drawing within our scrollview
	theScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;	
	[theScrollView setCanCancelContentTouches:NO];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;	
	self.navigationItem.title = @"Your Results";		
	
	
	NSString *theUsername = [[NSUserDefaults standardUserDefaults] objectForKey: @"username"];
	NSString *isLinkedWithUser = [[NSString alloc] initWithFormat:@"twitter_link_%@",theUsername];
	NSString *isLinkedTwitter = [[NSUserDefaults standardUserDefaults] objectForKey: isLinkedWithUser];
	NSLog(@"%@", isLinkedTwitter);
	
	if (resQuestion.isPrivate) {		
		toolBar.hidden = YES;	
	}
	
	[isLinkedTwitter release];
	[isLinkedWithUser release];	
	[super viewDidLoad];	
}

- (void) addOtherAnswers {
	
	CGRect theFrameAlt = [UIScreen mainScreen].applicationFrame;
	theFrameAlt.size.width = 308;	
	theFrameAlt.size.height = 100;	
	theFrameAlt.origin.x = 6.0;
	theFrameAlt.origin.y = self.yOffset + 20;
	
	AltAnswerView *altView = [[AltAnswerView alloc] initWithFrame:theFrameAlt questionP:self.questionObject];	
	[altView setBackgroundColor:[UIColor lightGrayColor]];
	[self.theScrollView addSubview:altView];	
	[altView release];
}

- (void) showTotalButton {
	
	UIBarButtonItem *totalButtonObj = [[UIBarButtonItem alloc] initWithTitle:@"Total" style:UIBarButtonItemStyleDone
																	  target:self
																	  action:@selector(viewTotal)];		
	self.navigationItem.rightBarButtonItem = totalButtonObj;	
	[totalButtonObj release];
	
	#ifdef CROWDSCANNER_TRIM
		self.navigationItem.rightBarButtonItem = nil;
	#endif	
}

- (void) statsSendOk {
	
}

- (void) viewTotal {

	StatsRemoteViewController *stats = [[StatsRemoteViewController alloc] initWithNibName:@"StatsRemoteViewController" bundle:nil];				
	stats.isUpdated = self.isUpdated;
	stats.showAggregatedResults = YES;
	stats.questionObject = questionObject;	
	stats.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController: stats animated:YES];	
	[stats release];	
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	
	return self.theStatsView;
}

- (void) signInTwitter {	
	
	TwitterRemoteRequests *twitterRemoteObj =  [[TwitterRemoteRequests alloc] init];
	OAuthTwitterDemoViewController *oauthTwitter = [[OAuthTwitterDemoViewController alloc] initWithNibName:@"OAuthTwitterDemoViewController" bundle:nil] ;		
	self.oAuth = oauthTwitter;
	
	self.twitterDelegate = twitterRemoteObj;	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(twitterAuthentication:)
												 name:@"authenticated" object: oauthTwitter];
	[[NSNotificationCenter defaultCenter] addObserver: self.twitterDelegate selector: @selector(twitterAlreadyAuthenticated)
												 name:@"already_authenticated" object: oauthTwitter];
	
	[self.navigationController pushViewController:oauthTwitter animated:YES];	
	[twitterRemoteObj release];
	[oauthTwitter release];
	
}	

- (void) twitterAuthentication:(NSNotification *) note {
	
	[self.oAuth.navigationController popViewControllerAnimated:YES];	
	
	self.realTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(addModalView) userInfo:nil repeats:YES];
	self.theCounter = 0;
	
	/*
	sleep(2);
	TwitterMessageView *theModal = [[TwitterMessageView alloc] initWithNibName:@"TwitterMessageView" bundle:nil];				
	theModal.theQuestion = self.questionObject;
	
	[self.navigationController pushViewController:theModal animated:YES];	
	[theModal release];		
	 */
} 

- (void) addModalView {
	
	theCounter++;
	
	if (theCounter == 1) {			
	
		TwitterMessageView *theModal = [[TwitterMessageView alloc] initWithNibName:@"TwitterMessageView" bundle:nil];				
		theModal.theQuestion = self.questionObject;
		
		[self.navigationController pushViewController:theModal animated:YES];	
		[theModal release];		
		
		[realTimer invalidate];
	}
}




- (IBAction) showShareOptions {

	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self 
						cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) {		
		
		NSString *theUsername = [[NSUserDefaults standardUserDefaults] objectForKey: @"username"];
		NSString *isLinkedWithUser = [[NSString alloc] initWithFormat:@"twitter_link_%@",theUsername];	
		NSString *isLinkedTwitter = [[NSUserDefaults standardUserDefaults] objectForKey: isLinkedWithUser];	
		if ([isLinkedTwitter isEqualToString:@"YES"]) {					
			
			TwitterMessageView *theModal = [[TwitterMessageView alloc] initWithNibName:@"TwitterMessageView" bundle:nil];				
			theModal.theQuestion = self.questionObject;
			
			[self.navigationController pushViewController:theModal animated:YES];	
			[theModal release];	
		}	
		else {
		
			[self signInTwitter];			
		}		
	}
}


- (void) postTweet {
	
	if (self.loadingView == nil) {
		LoadingAnimationView *loadingViewObj = [[LoadingAnimationView alloc] initWithFrame: CGRectMake(0, 0, 140, 80)]; 
		self.loadingView = loadingViewObj;
		[loadingViewObj release];		
	}
	
	[self.view addSubview:loadingView];
	NSString *theUsername = [[NSUserDefaults standardUserDefaults] objectForKey: @"username"];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(tweetPosted)
												 name:@"tweetPosted" object: self.twitterDelegate];	
	if (twitterDelegate == nil) {
		TwitterRemoteRequests *twitterRemoteObj =  [[TwitterRemoteRequests alloc] init];
		self.twitterDelegate = twitterRemoteObj;
		[twitterRemoteObj release];
	}
	
	[twitterDelegate postTweet:self.questionObject.questionPhoneId username:theUsername theMessage:@""];
}


- (void) tweetPosted {
	[loadingView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
}

- (void)viewDidUnload {	
	[super viewDidUnload];
}


- (void)dealloc {
	[realTimer release];
	[oAuth release];
	[loadingView release];	
	[twitterDelegate release];	
	[username release];
	[questionObject release];
    [super dealloc];
}


@end
