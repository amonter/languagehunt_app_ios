//
//  MainCardController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 26/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSearchController.h"
#import "MainFeelersCardController.h"
#import "MatchConnectionCell.h"
#import "ConnectionsCardController.h"
#import "AsynchMessageController.h"
#import "LongProfileController.h"
#import "IndividualFeelerController.h"
#import "PaymentTipControllerController.h"


@interface MainCardController : UIViewController <UIScrollViewDelegate, UITextViewDelegate, HPGrowingTextViewDelegate> {
 
    HPGrowingTextView *textView;
}


@property int otherProfileId;
@property int messageCount;
@property bool loadAllLocations;
@property bool disableMatchScroll;
@property (nonatomic, retain) IBOutlet UIScrollView* theScroll;
@property (nonatomic, retain) IBOutlet UIScrollView* nextScroll;



@property (nonatomic, retain) MainFeelersCardController* mainCard;
@property (nonatomic, retain) NSMutableDictionary* theLocations;
@property (nonatomic, retain) NSMutableDictionary* selectedLocation;
@property (nonatomic, retain) ConnectionsCardController* matchCell;
@property (nonatomic, retain) AsynchMessageController* soloMessage;
@property (nonatomic, assign) NSInteger lastContentOffset;
@property (nonatomic, retain) UIView* textChatContainer;
@property (nonatomic, retain) HPGrowingTextView* textView;
@property (nonatomic, retain) UIView* loadingScreen;
@property (nonatomic, retain) LongProfileController* longProfile;
@property (nonatomic, retain) NSMutableDictionary* allSelectedData;
@property (nonatomic, retain) PaymentTipControllerController* tipController;


@property (nonatomic, retain) IndividualFeelerController* indFeeler;



- (void) triggerMatch;
- (void) prepareChatView;
- (void) hideChat;
- (void) chatAnimation:(CGRect)moveFrame;
- (void) incomingMessage:(NSArray *) response;
- (void) chatConfirmed:(int) data;
- (void) swipeBack:(bool) loadMatches;
- (void) userLive:(NSDictionary *) user;
- (void) loadNewMatches:(NSDictionary*) jsonData;
- (void) addFeelerButtons:(int) feelerId;
- (void) populateMessages:(NSArray*) msgs;

@end
