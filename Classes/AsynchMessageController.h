//
//  AsynchMessageController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 12/01/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Stripe/Stripe.h>
#import "FeedTableBase.h"
#import "HuntProfileHelper.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "THChatInput.h"
#import "HPGrowingTextView.h"
#import "MatchDataTableController.h"

@interface AsynchMessageController :  UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKMapViewDelegate, UIScrollViewDelegate, HuntProfileHelperDelegate, STPCheckoutViewControllerDelegate> {
  
    NSString *theOtherUrl;
    NSString *matchedUsername;
    NSMutableArray *messages;  
    int otherProfileId;
    NSString *theName;   
    IBOutlet UITableView *theTableView;
    bool theyHaveSharedLocation;
    bool iHaveSharedLocation;
    
    NSString *theirSharedLocation;
    NSString* matchContent;
    //ChatInput controllers
    UIView *containerView;
    HPGrowingTextView *textView;
    NSDictionary* matchCriteria;
    NSDictionary* proficiency;
    NSDictionary* currentUserData;
    NSDictionary* otherUserData;
}

@property bool theyHaveSharedLocation;
@property bool iHaveSharedLocation;
@property int otherProfileId;
@property int amountToPay;
@property (nonatomic, retain) MatchDataTableController* matchLayout;
@property (nonatomic, retain) NSDictionary* matchCriteria;
@property (nonatomic, retain) NSDictionary* proficiency;
@property (nonatomic, retain) NSDictionary* currentUserData;
@property (nonatomic, retain) NSDictionary* otherUserData;
@property (nonatomic, retain) NSDictionary* paymentType;
@property (nonatomic, retain) NSDictionary* ratings;
@property (nonatomic, retain) NSString* matchContent;
@property (nonatomic, retain) NSString *theirSharedLocation;
@property (nonatomic, retain) NSString *theName;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, retain) NSString *theOtherUrl;
@property (nonatomic, retain) NSString *matchedUsername;
@property (nonatomic, retain) NSString *userEmail;
@property (nonatomic, retain) MKMapView *myMapView;
@property (nonatomic, retain) IBOutlet UIImageView *theBGChatBar;
@property (nonatomic, retain) IBOutlet UIImageView *bottomImage;
@property (nonatomic, retain) IBOutlet UIView* backView;




- (void) sendChatMessage:(HPGrowingTextView*) aTextView;
- (void) chatConfirmed:(int) data;
- (void) incomingMessage:(NSArray *) response;
- (void) incomingMapLocation:(NSArray *) data;
- (void) addNewRow:(NSDictionary *) myChatResponse;
- (void) showKeyboard;
- (void) hideKeyboard;
- (UIControl *)createCardView;
- (void)doMatchLayout:(NSDictionary *)matchingArray;
- (void) retrieveInbox;

@end
