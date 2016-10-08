//
//  TopQuestionsViewController.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 13/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "TopQuestionsViewController.h"
#import "ModalQuestionsViewController.h"
#import "MapViewQuestion.h"
#import "SwitchViewController.h"
#import "Question.h"
#import "StatsRemoteViewController.h"


@implementation TopQuestionsViewController
@synthesize flipButton;
@synthesize modalView;
@synthesize mapView;
@synthesize questions, location;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
 
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];	
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
	if (self.location == nil) {
		LocationManagerObject *locationObj = [[LocationManagerObject alloc] init];
		self.location = locationObj;
		[locationObj release];
	}	
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;	
	
	ModalQuestionsViewController *modalQuestion = [[ModalQuestionsViewController alloc] initWithNibName:@"ModalQuestionsViewController" bundle:nil];						
	self.modalView = modalQuestion;
	[modalQuestion release];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(viewSelectedModalQuestion:)
												 name:@"answerSelected" object: self.modalView];
	
	[self.view insertSubview:self.modalView.view atIndex:0];	
	
	UIBarButtonItem *mapButtonObj = [[UIBarButtonItem alloc] initWithTitle:@"MAP" style:UIBarButtonItemStyleDone
	target:self  action:@selector(flipViews)];
	self.flipButton = mapButtonObj;
	self.navigationItem.rightBarButtonItem = mapButtonObj;	
	
	self.navigationItem.title = @"Questions Nearby";
	[mapButtonObj release];				
	
    [super viewDidLoad];
}


- (void) refreshContent {

	if (self.modalView.view.superview == nil)  {	
		[self.mapView refreshContent];
	}	
}


- (void) flipViews {

	if (self.modalView.view.superview == nil)  {
	
		self.navigationItem.leftBarButtonItem = nil;
		[UIView beginAnimations:@"theFlip" context:nil];
		[UIView setAnimationDuration:1.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		self.flipButton.title = @"MAP";
		if (self.modalView == nil) {
			ModalQuestionsViewController *modalQuestion = [[ModalQuestionsViewController alloc] initWithNibName:@"ModalQuestionsViewController" bundle:nil];						
			self.modalView = modalQuestion;
			[modalQuestion release];
		}
	
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(viewSelectedModalQuestion:)
													 name:@"answerSelected" object: self.modalView];
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];			
		[self.mapView.view removeFromSuperview];
		[self.view insertSubview:self.modalView.view atIndex:0];						
		[UIView commitAnimations];		
	
	} else {
		
		UIBarButtonItem *refreshButtonObj = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																						  target:self
																						  action:@selector(refreshContent)];
		
		self.navigationItem.leftBarButtonItem = refreshButtonObj;
		
		self.questions = self.modalView.questions;
		[UIView beginAnimations:@"theFlip" context:nil];
		[UIView setAnimationDuration:1.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		self.flipButton.title = @"List";
		if (self.mapView == nil) {
			MapViewQuestion *theMapView = [[MapViewQuestion alloc] initWithNibName:@"MapViewQuestion" bundle:nil];
			theMapView.hidesBottomBarWhenPushed = YES;	
			self.mapView = theMapView;
			[theMapView release];			
		}
		
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(viewSelectedMapQuestion:)
													 name:@"answerSelectedMap" object: self.mapView];
		//temporal 
		NSMutableDictionary * theDic = [[NSMutableDictionary alloc] init];		
		for (Question *aQuest in self.questions) {			
			[theDic setObject:aQuest forKey:[NSString stringWithFormat:@"%i", aQuest.questionPhoneId]];			
		}
		
		
		[theDic release];
		[refreshButtonObj release];
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
		[self.modalView.view removeFromSuperview];
		[self.view insertSubview:self.mapView.view atIndex:0];		
		[UIView commitAnimations];			
	}

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release anything that's not essential, such as cached data
    if (self.modalView.view.superview == nil) 
        self.modalView = nil;
    else
        self.mapView = nil;		
}

- (void) viewSelectedMapQuestion: (NSNotification *) theResult {

	NSDictionary *theDictionary =  [theResult userInfo];
	
	SwitchViewController *switchView = [[SwitchViewController alloc] initWithNibName:@"SwitchViewController" bundle:nil];		
	switchView.hidesBottomBarWhenPushed = YES;	
	switchView.pathToRoot = YES;
	Question *questionObject = [theDictionary objectForKey:@"the_question"];
	
	switchView.questionObject = [questionObject retain];		
	[self.navigationController pushViewController:switchView animated:YES];		
	[switchView release];
}



- (void) viewSelectedModalQuestion: (NSNotification *) theResult {
	
	NSDictionary *theDictionary =  [theResult userInfo];
	Question *questionObject = [theDictionary objectForKey:@"the_question"];
	
	#ifdef CROWDSCANNER_TRIM
		StatsRemoteViewController *stats = [[StatsRemoteViewController alloc] initWithNibName:@"StatsRemoteViewController" bundle:nil];				
		stats.isUpdated = false;
		stats.showAggregatedResults = YES;
		stats.questionObject = questionObject;	
		stats.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController: stats animated:YES];	
		[stats release];						
	#else	
		SwitchViewController *switchView = [[SwitchViewController alloc] initWithNibName:@"SwitchViewController" bundle:nil];		
		switchView.hidesBottomBarWhenPushed = YES;	
		switchView.pathToRoot = YES;	
		switchView.questionObject = [questionObject retain];		
		[self.navigationController pushViewController:switchView animated:YES];		
		[switchView release];		
	#endif
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void) viewWillAppear:(BOOL)animated {
	[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"needs_reload"];
	[self.modalView viewWillAppear:YES];	
}

- (void)dealloc {
	[location release];
	[questions release];
	[modalView release];
	[mapView release];
	[flipButton release];
    [super dealloc];
}


@end
