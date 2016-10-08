//
//  StatsProfileViewController.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 08/02/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetrieveQuestionData.h"
#import "LoadingAnimationView.h"

@interface StatsProfileViewController : UIViewController {

	RetrieveQuestionData *retrieveQuestionStats;	
	int questionPhoneId;
	LoadingAnimationView *loadingView;
	UIBarButtonItem *theTitle;
	NSDictionary *theProfile;
}

@property (nonatomic,retain) NSDictionary *theProfile;
@property (nonatomic,retain) RetrieveQuestionData *retrieveQuestionStats;
@property (nonatomic,retain) LoadingAnimationView *loadingView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *theTitle;
@property int questionPhoneId;

- (IBAction) goBack;
- (void)displayTheView: (NSNotification *) theResult;

@end
