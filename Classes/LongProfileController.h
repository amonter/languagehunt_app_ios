//
//  LongProfileController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 15/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchDataTableController.h"

@interface LongProfileController : UIViewController <UIScrollViewDelegate>


@property (nonatomic, retain) MatchDataTableController* profileDataTable;
@property (nonatomic, retain) IBOutlet UIScrollView* underScroll;
@property (nonatomic, retain) NSDictionary *profileData;

- (void) displayProfileData;
- (void) doCommit:(id)sender;
- (void)addKeepBrowsing;
- (void) removeButton;
@end
