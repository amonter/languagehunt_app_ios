//
//  SocialLinkingController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/04/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleHuntRequests.h"


@interface SocialLinkingController : UIViewController <UIScrollViewDelegate> {

    IBOutlet UIScrollView *myScrollView;
    UITextField *emailField;
    IBOutlet UIButton *emailadded;
    IBOutlet UIButton *linkedinadded;
    IBOutlet UIButton *twitteradded;
    IBOutlet UIButton *efactorAdded;
    IBOutlet UILabel *emaildone;
    IBOutlet UILabel *linkedindone;
    IBOutlet UILabel *twitterdone;
    IBOutlet UILabel *efactorDone;
    IBOutlet UISwitch *notifications;
    IBOutlet UIImageView *backgroundCurve;
    
    
    PeopleHuntRequests *peopleReq;
    
}

@property (nonatomic,retain) UIScrollView *myScrollView;
@property (nonatomic, retain) PeopleHuntRequests *peopleReq;
@property (nonatomic, retain) UITextField *emailField;
@property (nonatomic, retain) UIButton *emailadded;
@property (nonatomic, retain) UIButton *linkedinadded;
@property (nonatomic, retain) UIButton *twitteradded;
@property (nonatomic, retain) UILabel *emaildone;
@property (nonatomic, retain) UILabel *linkedindone;
@property (nonatomic, retain) UILabel *twitterdone;
@property (nonatomic, retain) UISwitch *notifications;
@property (nonatomic, retain) UIImageView *backgroundCurve;


- (IBAction)tweetButtonPressed:(id)sender;

- (void) setUpTwitter:(id)sender;
- (void) setTwitterData:(NSString *)twitterHandle;
- (void) loginViewDidFinish:(NSNotification*)notification;

- (void) addLoadingView;
- (void) doHelpDataRequest;
- (void) sendPushNotificationToken;



@end
