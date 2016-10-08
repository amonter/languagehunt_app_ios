//
//  ProfileV2Controller.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 03/12/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "FeedTableBase.h"
#import "AvatarImageView.h"
#import <UIKit/UIKit.h>
#import "PeopleHuntRequests.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ProfileV2Controller : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate,UITextViewDelegate>{

    IBOutlet UIScrollView *myScrollView;
    IBOutlet UIButton *linkedinadded;
    IBOutlet UIButton *twitteradded;
    IBOutlet UIButton *efactorAdded;
    IBOutlet UILabel *linkedindone;
    IBOutlet UILabel *twitterdone;
    IBOutlet UILabel *efactorDone;
    IBOutlet UISwitch *notifications;
    IBOutlet UILabel *message;
    IBOutlet UIImageView *backgroundCurve;
    IBOutlet UIImageView *backgroundCurve2;
    IBOutlet UIImageView *backgroundCurve3;
    IBOutlet UIImageView *backgroundCurve4;
    IBOutlet UIImageView *backgroundCurve5;
    IBOutlet UIButton *linkedindonebutton;
    IBOutlet UIButton *twitterdonebutton;
    IBOutlet UIButton *efactordonebutton;
    IBOutlet UIButton *facebookdonebutton;
    IBOutlet UILabel *bioLabel;
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *futureLocationLabel;
    
    PeopleHuntRequests *peopleReq;
    NSString *groupData;
    NSMutableArray *myGroups;
    
}

@property (nonatomic, retain) NSString *groupData;
@property (nonatomic, retain) NSString *myImageUrl;
@property (nonatomic, retain) NSMutableArray *myGroups;
@property (nonatomic, retain) NSMutableArray *tableGroups;
@property (nonatomic, retain) NSMutableArray *openGroups;
@property (nonatomic, retain) AvatarImageView *avatarImage;
@property (nonatomic,retain) UIScrollView *myScrollView;
@property (nonatomic, retain) PeopleHuntRequests *peopleReq;
@property (nonatomic, retain) UIButton *linkedinadded;
@property (nonatomic, retain) UIButton *twitteradded;
@property (nonatomic, retain) IBOutlet UIButton *facebookAdded;
@property (nonatomic, retain) UILabel *linkedindone;
@property (nonatomic, retain) UILabel *twitterdone;
@property (nonatomic, retain) IBOutlet UILabel *facebookdone;
@property (nonatomic, retain) UISwitch *notifications;
@property (nonatomic, retain) UIImageView *backgroundCurve;
@property (nonatomic, retain) UIImageView *backgroundCurve2;
@property (nonatomic, retain) UIImageView *backgroundCurve3;
@property (nonatomic, retain) UIImageView *backgroundCurve4;
@property (nonatomic, retain) UIImageView *backgroundCurve5;
@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) IBOutlet UIButton *linkedindonebutton;
@property (nonatomic, retain) IBOutlet UIButton *twitterdonebutton;
@property (nonatomic, retain) IBOutlet UIButton *efactordonebutton;
@property (nonatomic, retain) IBOutlet UIButton *facebookdonebutton;
@property (nonatomic, retain) IBOutlet UITextView *bioTextEdit;
@property (nonatomic, retain) IBOutlet UILabel *bioLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *futureLocationLabel;

- (IBAction) tweetButtonPressed:(id)sender;
- (IBAction) sendFeedback:(id)sender;
- (IBAction) linkedInButtonPressed:(id)sender;
- (IBAction) eFactorButtonPressed:(id)sender;
- (void) editProfileData;
- (void) setUpTwitter:(id)sender;
- (void) loginViewDidFinish:(NSNotification*)notification;
- (void) profileApiCall;
- (void) addLoadingView;
- (void) sendPushNotificationToken;
- (void) efactorViewDidFinish;
- (void) backButtonTapped;
- (IBAction) doFacebookConnect;
- (void) resetImages;
- (IBAction) sendFacebookRequest;



- (IBAction) goSettings;
- (void) accessInfoTap;
- (void) accessInfoTapRemove;


@end
