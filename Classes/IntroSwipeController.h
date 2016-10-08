//
//  IntroSwipeController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
// CHNAGES PROCESSING AND iPHONECROWD APP DELEGATE

#import <UIKit/UIKit.h>
#import "LocationSearchController.h"
#import "HelpWithController.h"
#import "InterestedInController.h"
#import "FacebookProfileSelection.h"
#import "LongProfileController.h"
#import "HubLocationsController.h"
#import "DummyScroll.h"
#import "LanguageModeController.h"
#import "FastConnectionsController.h"
#import "MeetingInfoController.h"
#import "MainProfileController.h"
#import "EditProfileController.h"
#import "SignupIntroController.h"
#import "LocationSearchDummy.h"

@interface IntroSwipeController : UIViewController <UIScrollViewDelegate, SelectedDataDelegate, HPGrowingTextViewDelegate, LanguageModeDelegate, MainProfileDataDelegate>



@property bool helpMode;
@property bool profileMode;
@property bool startMode;
@property int checkList;
@property int displayedIndex;
@property (nonatomic, retain) IBOutlet UIScrollView* theScrollView;
@property (nonatomic, retain) NSMutableDictionary* allSelectedData;
@property (nonatomic, retain) NSMutableDictionary* preStoredData;
@property (nonatomic, retain) LocationSearchController* locationSearch;
@property (nonatomic, retain) InterestedInController* interestedIn;
@property (nonatomic, retain) HubLocationsController* hubLocations;
@property (nonatomic, retain) HelpWithController* helpWith;
@property (nonatomic, retain) FacebookProfileSelection* facebooProfile;
@property (nonatomic, retain) LongProfileController* longProfile;
@property (nonatomic, retain) MainProfileController* mainProfile;
@property (nonatomic, retain) SignupIntroController * signUpController;
@property (nonatomic, assign) NSInteger lastContentOffset;
@property (nonatomic, retain) UIView* loadingScreen;
@property (nonatomic, retain) NSMutableArray* matchCardArray;
@property (nonatomic, retain) UIView* textChatContainer;
@property (nonatomic, retain) HPGrowingTextView* textView;
@property (nonatomic, retain) LanguageModeController* languageMode;
@property (nonatomic, retain) FastConnectionsController* matchCell;
@property (nonatomic, retain) NSMutableArray* matchDataArray;
@property (nonatomic, retain) MeetingInfoController* theInfo;
@property (nonatomic, retain) EditProfileController *editController;
@property (nonatomic, retain) NSMutableArray* selectedMatches;
@property (nonatomic, retain) MessageConfirmationController* theMessage;





- (void) populateHubLocations:(NSArray*) locations;
- (void)showProfileCard:(NSDictionary *)theData hasLocation:(BOOL) location index:(int) theIndex;
- (void) showCards:(NSDictionary*) theData;
- (void) goProfile;
- (void) goLanguages;
- (void) liveMessage;
- (void) showLanguageSelection;

@end
