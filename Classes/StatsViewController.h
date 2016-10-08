//
//  StatsViewController.h
//  Ousiastikos2
//
//  Created by Adrian Avendano on 09/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterRemoteRequests.h"
#import "OAuthTwitterDemoViewController.h"
#import "Question.h"

#import "LoadingAnimationView.h"
#import "UIViewStatistics.h"
#import "OAuthTwitterDemoViewController.h"

@interface StatsViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate> {

	NSString *username;	
	bool isUpdated;
	Question *questionObject;
	int questionid;	
	TwitterRemoteRequests *twitterDelegate; 		
	LoadingAnimationView *loadingView;
	UIScrollView *theScrollView;
	UIViewStatistics *theStatsView;
	UIToolbar *toolBar;
	OAuthTwitterDemoViewController *oAuth;
	int theCounter;
	int yOffset;
	NSTimer *realTimer;
}

@property bool isUpdated;
@property int theCounter;
@property int questionid;
@property int yOffset;
@property (nonatomic, retain) NSTimer *realTimer;
@property (nonatomic, retain) OAuthTwitterDemoViewController *oAuth;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) IBOutlet UIScrollView *theScrollView;
@property (nonatomic, retain) TwitterRemoteRequests *twitterDelegate;
@property (nonatomic, retain) UIViewStatistics *theStatsView;
@property (nonatomic, retain) LoadingAnimationView *loadingView;
@property (nonatomic, retain) Question *questionObject;
@property (nonatomic, retain) NSString *username;
- (void) statsSendOk;
- (void) signInTwitter;
- (void) postTweet;
- (IBAction) showShareOptions;
- (void) tweetPosted;
- (void) viewTotal;
- (void) addOtherAnswers;
- (void) showTotalButton;

@end
