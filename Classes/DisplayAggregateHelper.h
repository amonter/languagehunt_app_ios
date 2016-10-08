//
//  DisplayAggregateHelper.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 10/02/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsRemoteViewController.h"
#import "Question.h"


@interface DisplayAggregateHelper : NSObject {

	StatsRemoteViewController *remoteViewController;
	int offsetHeight;
}

@property int offsetHeight;
@property (nonatomic, retain) StatsRemoteViewController *remoteViewController;

- (void) displayResults: (NSDictionary *) theDictionary;
- (void) drawStatsResults;
- (void) drawProfile;
- (Question *) parseQuestionObject:(NSDictionary *) theDictionary;
@end
