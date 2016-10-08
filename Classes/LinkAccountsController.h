//
//  LinkAccountsController.h
//  CrowdScannerMindField
//
//  Created by ellie's macbook on 03/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleHuntRequests.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface LinkAccountsController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate> {

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
    PeopleHuntRequests *peopleReq;

}

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

- (IBAction)tweetButtonPressed:(id)sender;
- (IBAction) sendFeedback:(id)sender;

- (void) setUpTwitter:(id)sender;
- (void) setTwitterData:(NSString *)twitterHandle;
- (void) loginViewDidFinish:(NSNotification*)notification;

- (void) addLoadingView;
- (void) sendPushNotificationToken;

- (void) backButtonTapped;
- (IBAction) doFacebookConnect;
- (void) resetImages;


@end
