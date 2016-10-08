//
//  iphoneCrowdAppDelegate.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 09/07/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "RealOusiastikosAppDelegate.h" 
#import "TheMatcher.h"
#import "MatchViewController.h"
#import "ProtocolCommunication.h"
#import "SegmentsController.h"
#import "ProcessingProtocol.h"


extern NSString *const FBSessionStateChangedNotification;

@class Reachability;
@interface iphoneCrowdAppDelegate : RealOusiastikosAppDelegate <UIAlertViewDelegate>  {

    UINavigationController *navigationController;
    TheMatcher *matcherRequest;
    NSString *otherUsername;
    ProtocolCommunication *protocol;
    ProcessingProtocol *process;       
}


@property (nonatomic, retain) SegmentsController *segmentsCustom;
@property (nonatomic, retain) UISegmentedControl *segmentControl;
@property (nonatomic, retain) ProcessingProtocol *process; 
@property (nonatomic, retain) ProtocolCommunication *protocol;
@property (nonatomic, retain) NSString *otherUsername;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) FBSession *session;
@property (nonatomic, retain) TheMatcher *matcherRequest;
@property (nonatomic, retain) MatchViewController *theMatch;

- (void)doPushNotifications;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (BOOL)openSessionReadWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) doPopUpdate;
- (void) retrieveUpdateLink;
- (void) startHunting;
- (void) notifiyPhotoDone;
- (void) displayAccessScreen:(NSString *) yourMatchName otherUsername:(NSString *) username;
- (void) giveAccessOn: (id) sender;
- (void) saveAccess:(id) sender;
- (void) cancelHunting;
- (void) displayPeopleSearch;
- (void) initProtocolCommunicationMainThread;
- (void) resetConnection;
- (void) checkHeartBeat;
- (UINavigationController*) retrieveMessageSegments;
- (void) goIntroSwipe:(bool) profileMode;
- (void) displayLanguageSelection;
- (void) showMissingLanguageView;



@end
