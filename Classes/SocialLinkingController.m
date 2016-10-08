//
//  SocialLinkingController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/04/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "SocialLinkingController.h"
#import "PeopleHuntRequests.h"
#import "iphoneCrowdAppDelegate.h"
#import "LoadingAnimationView.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000 
#import "Twitter/Twitter.h"
#import <Accounts/Accounts.h>
#endif

#import <QuartzCore/QuartzCore.h>

@implementation SocialLinkingController
@synthesize emailField, emailadded, linkedinadded, twitteradded, emaildone, linkedindone, twitterdone, backgroundCurve, myScrollView;
@synthesize peopleReq, notifications;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    /*
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1];
    
    //Config the switch settings
    [self.notifications addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];    
    
    //Check if notifications are active
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types == UIRemoteNotificationTypeNone){
        [self.notifications setOn:FALSE];
    }
    
    
    //background images
    backgroundCurve.backgroundColor = [UIColor whiteColor];
    backgroundCurve.layer.cornerRadius = 8.0;
    backgroundCurve.layer.shadowColor = [[UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:1] CGColor];
    backgroundCurve.layer.shadowOffset = CGSizeMake(0,0);
	backgroundCurve.layer.shadowRadius = 2.0f;
    
    
    //set up buttons
    NSString *linkedInActive = [[NSUserDefaults standardUserDefaults] objectForKey:@"linkedin_added"];
    if (linkedInActive){
        [linkedinadded setImage:[UIImage imageNamed:@"linkin_blue.png"] forState:UIControlStateNormal];
        [linkedindone setText:@"Disconnect"];
        [linkedindone setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0]];
        linkedindone.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1];
    }
    
    
    NSString *twitterAdded = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_handle"];
    if (twitterAdded){
        [twitteradded setImage:[UIImage imageNamed:@"twitter_blue.png"] forState:UIControlStateNormal];
        [twitterdone setText:@"Disconnect"];
        [twitterdone setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0]];
        twitterdone.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1];
    }
    
    NSString *efactorAddedString = [[NSUserDefaults standardUserDefaults] objectForKey:@"efactor_added"];
    if (efactorAddedString){
        [efactorAdded setImage:[UIImage imageNamed:@"efactor_blue.png"] forState:UIControlStateNormal];
        [efactorDone  setText:@"Disconnect"];
        [efactorDone setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0]];
         efactorDone.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1];
        
    }
    */
   
    [super viewDidLoad];
   
    
    myScrollView.delegate = self;
    
    myScrollView.scrollEnabled = YES;
    myScrollView.backgroundColor = [UIColor grayColor];
    [myScrollView setContentSize:CGSizeMake(320, 200)];
    // Do any additional setup after loading the view from its nib.
}





- (void) switchChanged:(id) sender {

    UISwitch *theSwitch = (UISwitch *)sender;   
    if (theSwitch.isOn){
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    } else {        
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void) sendPushNotificationToken {   
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [req sendPushNotificationToken];    
    
}

- (IBAction)doEmail:(id)sender {

    //Show add email popup
    UIView *emailPop = [[[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 200)] autorelease];
    emailPop.backgroundColor = [UIColor whiteColor]; 
    emailPop.tag = 289;    
    emailPop.layer.cornerRadius = 4.0;       
    emailPop.layer.borderColor = [[UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1] CGColor];
    emailPop.layer.borderWidth = 1;
    
    //Label looking for
    UILabel *msg = [[[UILabel alloc] initWithFrame:CGRectMake(10,10, 260, 35)] autorelease];
    msg.backgroundColor = [UIColor whiteColor];
    msg.lineBreakMode = UILineBreakModeWordWrap;
    msg.numberOfLines = 0;		
    msg.textColor = [UIColor blackColor];
    msg.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];      	
    msg.textAlignment = UITextAlignmentCenter;
    msg.text = @"Add an email address to receive a list of your PeopleHunt connections.";        
    [emailPop addSubview:msg];
    
    //The email field
    self.emailField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 60, 260, 45)] autorelease];
    //self.emailField.adjustsFontSizeToFitWidth = YES;
    self.emailField.textColor = [UIColor blackColor];
    self.emailField.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    self.emailField.placeholder = @"Enter your email";        
    self.emailField.keyboardType = UIKeyboardTypeDefault;
    self.emailField.returnKeyType = UIReturnKeyDone;             
    self.emailField.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0  alpha:1.0];
    self.emailField.layer.borderColor = [[UIColor colorWithRed:113/255.0 green:215/255.0 blue:226/255.0 alpha:1.0]CGColor];
    self.emailField.layer.borderWidth =2.0;
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
    NSString *emailAdded = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    if (emailAdded){
        self.emailField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    }    
    UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)] autorelease];
    self.emailField.leftView = paddingView;
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    
    
    [self.emailField becomeFirstResponder];
    [emailPop addSubview:self.emailField];        
    
    //Done selecting matches Button
    UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeCustom];	
    [goBtn setFrame:CGRectMake(174, 125, 91, 55)];	   
    [goBtn setTitle:@"Done" forState:UIControlStateNormal];   
    [goBtn addTarget:self action:@selector(doHelpDataRequest) forControlEvents:UIControlEventTouchUpInside];	
    goBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:23];
    [goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBtn setBackgroundImage:[UIImage imageNamed:@"Next.png"] forState:UIControlStateNormal];
    [emailPop addSubview:goBtn];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];	
    [cancelbutton setFrame:CGRectMake(15, 125, 100, 55)];	   
    [cancelbutton setTitle:@"Cancel" forState:UIControlStateNormal];   
    [cancelbutton addTarget:self action:@selector(closeSelection) forControlEvents:UIControlEventTouchUpInside];	
    cancelbutton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:23];
    [cancelbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelbutton setBackgroundImage:[UIImage imageNamed:@"Cancel.png"] forState:UIControlStateNormal];
    [emailPop addSubview:cancelbutton];       
    
    [self.view addSubview:emailPop];
   
}



- (void) doHelpDataRequest{

    if ([self.emailField.text length] == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please put in your email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        alert.tag = 919;
        [alert show];    
        [alert release];
        
    } else {
        
        [[self.view viewWithTag:289] removeFromSuperview];
        [self.emailField resignFirstResponder];
        [[NSUserDefaults standardUserDefaults] setObject:self.emailField.text forKey:@"email"];
        PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];          
        [req updateUserEmail];
        [emailadded setImage:[UIImage imageNamed:@"email_blue.png"] forState:UIControlStateNormal];
        [emaildone setText:@"Email"]; 
    } 
}   

    

- (IBAction)tweetButtonPressed:(id)sender {
    
    Class tweeterClass = NSClassFromString(@"TWTweetComposeViewController");
    
    if(tweeterClass != nil) {   // check for Twitter integration
        
        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000 
        // check Twitter accessibility and at least one account is setup        
        [self addLoadingView];
        if([TWTweetComposeViewController canSendTweet]) {
            
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];            
            // Create an account type that ensures Twitter accounts are retrieved.
            ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
                if(granted) {
                    // Get the list of Twitter accounts.
                    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];    
                    if ([accountsArray count] > 0){              
                        
                        //Show view twitter tag selection
                        int y_val2 = 260;
                        if ([accountsArray count] == 3){
                            y_val2 = 280;
                        }
                        if ([accountsArray count] == 4){
                            y_val2 = 320;
                        }
                        if ([accountsArray count] > 4){
                            y_val2 = 390;
                        }
                        
                        UIView *emailPop = [[[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, y_val2)] autorelease];
                        emailPop.backgroundColor = [UIColor whiteColor]; 
                        emailPop.tag = 69;                            
                        emailPop.layer.cornerRadius = 4.0;       
                        emailPop.layer.borderColor = [[UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1] CGColor];
                        emailPop.layer.borderWidth = 1;                       
                        
                        UILabel *selectTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10,10, 260, 40)] autorelease];
                        selectTitle.backgroundColor = [UIColor whiteColor];
                        selectTitle.textColor = [UIColor blackColor];
                        selectTitle.numberOfLines = 0;
                        selectTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];      	
                        selectTitle.textAlignment = UITextAlignmentCenter;        
                        selectTitle.text = [NSString stringWithFormat:@"Link a Twitter account so PeopleHunters can follow you."];
                        [emailPop addSubview:selectTitle];
                        
                        UILabel *selectTitle2 = [[[UILabel alloc] initWithFrame:CGRectMake(10,60, 260, 30)] autorelease];
                        selectTitle2.backgroundColor = [UIColor whiteColor];
                        selectTitle2.textColor = [UIColor blackColor];
                        selectTitle2.font = [UIFont fontWithName:@"Helvetica" size:13.0];      	
                        selectTitle2.numberOfLines = 0;
                        selectTitle2.textAlignment = UITextAlignmentCenter;        
                        selectTitle2.text = [NSString stringWithFormat:@"We will never post to your account unless you specifically ask us to."];
                        [emailPop addSubview:selectTitle2];
                        
                        
                        int y_val = 105;
                        for (ACAccount *account in accountsArray) {                 
                                                      
                            UIButton *handlerSelect = [UIButton buttonWithType:UIButtonTypeCustom];	
                            [handlerSelect setFrame:CGRectMake(40, y_val, 200, 45)];	   
                            [handlerSelect setTitle:[NSString stringWithFormat:@"@%@", account.username] forState:UIControlStateNormal];   
                            [handlerSelect addTarget:self action:@selector(setUpTwitter:) forControlEvents:UIControlEventTouchUpInside];	
                            handlerSelect.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                            [handlerSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [handlerSelect setBackgroundImage:[UIImage imageNamed:@"TakePhoto.png"] forState:UIControlStateNormal];
                            [emailPop addSubview:handlerSelect]; 
                            y_val+=55;                                                        
                        }	
                        
                        [[self.view viewWithTag:612] removeFromSuperview];
                        [self.view addSubview:emailPop];
                        
                    }                   
                }
            }];                      
        
            
        } else {
            [[self.view viewWithTag:612] removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Whoops! You have no Twitter account set up in your iphone." delegate:self 
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
      
    #endif
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Whoops! You are still using iOS 4.x. We don't support it for this action." delegate:self 
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void) loginViewDidFinish:(NSNotification*)notification {
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
    [self profileApiCall];
	
}



- (void)setTwitterData:(NSString *)twitterHandle {
    
    [[NSUserDefaults standardUserDefaults] setObject:twitterHandle forKey:@"twitter_handle"];
    self.peopleReq = [[[PeopleHuntRequests alloc] init] autorelease];
    [self.peopleReq addTwitterHandle];
    [[self.view viewWithTag:69] removeFromSuperview];    
      
}

- (void) setUpTwitter:(id)sender {
    
    UIButton *tButton = (UIButton *)sender;
    NSString *twitterHandle = tButton.titleLabel.text;
    //move this to twitter
    [twitteradded setImage:[UIImage imageNamed:@"twitter_blue.png"] forState:UIControlStateNormal];
    [twitterdone setText:@"Twitter"];   
    [self setTwitterData:twitterHandle];    
}


- (void) addLoadingView {   
    LoadingAnimationView *loadingViewObj = [[[LoadingAnimationView alloc] initWithFrame: CGRectMake(90, 110, 140, 80)] autorelease];
    loadingViewObj.tag = 612;
    [self.view addSubview:loadingViewObj];   
    [self.view bringSubviewToFront:loadingViewObj];
}

- (void) closeSelection {
    [[self.view viewWithTag:289] removeFromSuperview];
}


- (void)dealloc {
    [myScrollView release];
    [peopleReq release];
    [emailField release];
    [emailadded release];
    [linkedinadded release];
    [twitteradded release];
    [emaildone release];
    [linkedindone release];
    [twitterdone release];
    [notifications release];
    [backgroundCurve release];
    [super dealloc];
} 


@end
