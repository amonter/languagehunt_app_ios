//
//  StatsRemoteViewController.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 29/01/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsViewController.h"
#import "RetrieveQuestionData.h"
#import "LoadingAnimationView.h"
#import "UIViewStatistics.h"
#import "AsyncImageView.h"

@interface StatsRemoteViewController : UIViewController <UIScrollViewDelegate> {

	Question *questionObject;
	bool isUpdated;
	int questionid;
	int yOffset;	
	RetrieveQuestionData *retrieveQuestionProfiles;	
	LoadingAnimationView *loadingView;	
	NSArray *profiles;
	BOOL showAggregatedResults;	
	UIScrollView *theScrollView;
	UIViewStatistics *theStatsView;
	AsyncImageView *asyncImage;
}

@property (nonatomic, retain) IBOutlet UIScrollView *theScrollView;
@property (nonatomic, retain) UIViewStatistics *theStatsView;
@property (nonatomic, retain) AsyncImageView *asyncImage;
@property (nonatomic, retain) LoadingAnimationView *loadingView;
@property (nonatomic, retain) NSArray *profiles;
@property (nonatomic, retain) RetrieveQuestionData *retrieveQuestionProfiles;
@property int questionid;
@property int yOffset;
@property bool isUpdated;
@property BOOL showAggregatedResults;
@property (nonatomic, retain) Question *questionObject;


- (void) alertMe:(id)sender;
- (IBAction) backToQuestions;
- (void)displayTheAggregate: (NSNotification *) theResult;
- (void) viewComments;
- (void) drawProfile;

@end
