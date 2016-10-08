//
//  IntroSwipeController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSearchController.h"
#import "LocationSearchDummy.h"
#import "DummyTwoController.h"
#import "HelpWithController.h"
#import "InterestedInController.h"
#import "FacebookProfileSelection.h"
#import "LongProfileController.h"
#import "DummyScroll.h"

@interface DummyViewController : UIViewController <UIScrollViewDelegate>


@property bool showProfile;
@property (nonatomic, retain) IBOutlet UIScrollView* theScrollView;
@property (nonatomic, retain) NSMutableDictionary* allSelectedData;
@property (nonatomic, retain) NSMutableDictionary* preStoredData;
//@property (nonatomic, retain) LocationSearchController* locationSearch;
@property (nonatomic, retain) InterestedInController* interestedIn;
@property (nonatomic, retain) HelpWithController* helpWith;
@property (nonatomic, retain) FacebookProfileSelection* facebooProfile;
@property (nonatomic, retain) LongProfileController* longProfile;
@property (nonatomic, retain) LocationSearchDummy* locationSearch;
//@property (nonatomic, retain) DummyTwoController* locationSearch;
@property (nonatomic, assign) NSInteger lastContentOffset;


@end
