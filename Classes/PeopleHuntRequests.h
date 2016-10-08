//
//  PeopleHuntRequests.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 12/07/2011.
//  Copyright 2011 crowdscanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RetrieveQuestionStats.h"


@interface PeopleHuntRequests : RetrieveQuestionStats {
    
    NSString *requester;
    NSTimer *matchTimer;
    
}

@property (nonatomic,retain) NSTimer *matchTimer;
@property (nonatomic,retain) NSString *requester;


- (void) addGuessReq:(int) herHuntid myGuess:(NSString *) theGuess bundleId:(int) bundleid;
- (void) retrieveHuntBundles;
- (void) retrieveOffers;
- (void) findAmigoMatch:(int) myhuntId;
//- (void) addMultipleGuessReq:(int) herHuntid myGuess:(NSString *) theGuess bundleId:(int) bundleid;

- (void) cancelConnectionForHunt;
- (void) retrieveHelpWithData;
- (void) retrieveInterestedInData;
- (void) retrieveAllLocations;

- (void) addFoundTarget:(int) bundleId collectedUser:(NSString *) collectedUsername;
- (void) cantFindTarget:(int) bundleId collectedUser:(int) collectedHuntId theHuntId:(int) aHuntId;
- (void) retrieveSocialStream:(int) bundleId;
- (void) sendPushNotificationToken;
- (void) retrieveBundlePlayers:(int) bundleId;
- (void) addTwitterHandle;
- (void) addLinkedInData:(NSString *) name url:(NSString *) theUrl;
- (void) sendEfactorData:(NSString *) theData;
- (void) retrieveMyFeelerData:(int) segment;
- (void) updateUserEmail;
- (void) retrieveUserHuntId:(int) bundleId;
- (void) addSimpleProfile:(NSString*) profileType;
- (void) retrieveLatestUpdateLink;
- (void) addGroupMembership:(int) groupid;
- (void) retrieveMyGroupsProfile;
- (void) addFeelerState:(int) feelerId statusType:(NSString *) type;
- (void) deleteFeelerState:(int) feelerId statusType:(NSString *) type;
- (void) giveGroupAccess:(NSString *) otherUsername;
- (void) retrieveMatchList;
- (void) retrieveInbox:(int) otherProfileId;
- (void) postNewMessage:(NSString *) content recipient:(NSString *) theRecipient;
- (void) terminateMatch;
- (void) retrieveOpenGroups;
- (void) retrieveMyNotifications;
- (void) postPushNotification:(int) senderId;
- (void) disableNotifications;
- (void) searchFeelerLike:(NSString*) likeData;
- (void) retrieveRandomFeelers;
- (void) removePreviousMatch:(int) otherProfileId;
- (void) updateProfileInfo:(NSDictionary*) elements;
- (void) retrieveProfileFeelerData:(int) otherProfileId;
- (void) addAllFeelerData:(NSDictionary*) feelerData;
- (void) retrieveFastFeeler:(int) feelerId;
- (void) postJsonProfile:(NSDictionary*) theData;
- (void) retrieveProfileData;
- (void) retrieveSentMessages;
//LanguageHunt Requests
- (void) postMissingLanguage:(NSString*) jsonData;
- (void) addTransaction:(NSString*) jsonData;

- (void) dummyCal;

@end
