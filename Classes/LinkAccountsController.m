//
//  LinkAccountsController.m
//  CrowdScannerMindField
//
//  Created by ellie's macbook on 03/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "LinkAccountsController.h"
#import "PeopleHuntRequests.h"
#import "HuntProfileHelper.h"
#import "LoadingAnimationView.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
#import "Twitter/Twitter.h"
#import <Accounts/Accounts.h>
#endif

#import "iphoneCrowdAppDelegate.h"
#import <QuartzCore/QuartzCore.h>



@interface LinkAccountsController ()

@end

@implementation LinkAccountsController
@synthesize myScrollView, linkedinadded, twitteradded, linkedindone, twitterdone, backgroundCurve, backgroundCurve2, backgroundCurve3, backgroundCurve4, backgroundCurve5, peopleReq, notifications, message, linkedindonebutton,twitterdonebutton, efactordonebutton, facebookdonebutton;

@synthesize facebookAdded, facebookdone;

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    
    UIButton *Button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 41)] autorelease];
    [Button setImage:[UIImage imageNamed:@"backArrow.png"] forState:UIControlStateNormal];
    [Button setImage:[UIImage imageNamed:@"backPressed.png"] forState:UIControlStateHighlighted];
    [Button setImage:[UIImage imageNamed:@"backPressed.png"] forState:UIControlStateSelected];
    [Button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView:Button] autorelease];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    navBar.tag = 1203;
    UIImage *backgroundImage = [UIImage imageNamed:@"SettingsNav.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    
    
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
    backgroundCurve.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1] CGColor];
    backgroundCurve.layer.borderWidth = 1;
    
    //background images
    backgroundCurve2.backgroundColor = [UIColor whiteColor];
    backgroundCurve2.layer.cornerRadius = 8.0;
    backgroundCurve2.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1] CGColor];
    backgroundCurve2.layer.borderWidth = 1;
    
    //background images
    backgroundCurve3.backgroundColor = [UIColor whiteColor];
    backgroundCurve3.layer.cornerRadius = 8.0;
    backgroundCurve3.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1] CGColor];
    backgroundCurve3.layer.borderWidth = 1;
    
    
    //background images
    backgroundCurve4.backgroundColor = [UIColor whiteColor];
    backgroundCurve4.layer.cornerRadius = 8.0;
    backgroundCurve4.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1] CGColor];
    backgroundCurve4.layer.borderWidth = 1;
    
    //background images
    backgroundCurve5.backgroundColor = [UIColor whiteColor];
    backgroundCurve5.layer.cornerRadius = 8.0;
    backgroundCurve5.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1] CGColor];
    backgroundCurve5.layer.borderWidth = 1;
    
    //set up buttons
    NSString *linkedInActive = [[NSUserDefaults standardUserDefaults] objectForKey:@"linkedin_added"];
    if (linkedInActive){
        [linkedinadded setImage:[UIImage imageNamed:@"linkin_blue.png"] forState:UIControlStateNormal];
        [linkedindone setText:@"Connected to LinkedIn"];
        [linkedindone setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]];
        linkedindone.shadowColor = [UIColor whiteColor];
        linkedindone.shadowOffset = CGSizeMake(0.0, 1.0);
        [linkedindonebutton setImage:[UIImage imageNamed:@"Added_button.png"] forState:UIControlStateNormal];
        linkedindonebutton.userInteractionEnabled = false;
        
    }
    
    
    NSString *twitterAdded = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_handle"];
    if (twitterAdded){
        [twitteradded setImage:[UIImage imageNamed:@"twitter_blue.png"] forState:UIControlStateNormal];
        [twitterdone setText:@"Connected to Twitter"];
        [twitterdone setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]];
        twitterdone.shadowColor = [UIColor whiteColor];
        twitterdone.shadowOffset = CGSizeMake(0.0, 1.0);
        [twitterdonebutton setImage:[UIImage imageNamed:@"Added_button.png"] forState:UIControlStateNormal];
        twitterdonebutton.userInteractionEnabled = false;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_btn"] boolValue]){
        [facebookAdded setImage:[UIImage imageNamed:@"faceBookSettings.png"] forState:UIControlStateNormal];
        [facebookdone setText:@"Connected to Facebook"];
        [facebookdone setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]];
        facebookdone.shadowColor = [UIColor whiteColor];
        facebookdone.shadowOffset = CGSizeMake(0.0, 1.0);
        [facebookdonebutton setImage:[UIImage imageNamed:@"Added_button.png"] forState:UIControlStateNormal];
        facebookdonebutton.userInteractionEnabled = false;
    }

    
    NSString *efactorAddedString = [[NSUserDefaults standardUserDefaults] objectForKey:@"efactor_added"];
    if (efactorAddedString){
        [efactorAdded setImage:[UIImage imageNamed:@"efactor_blue.png"] forState:UIControlStateNormal];
        [efactorDone  setText:@"Connected to EFactor"];
        [efactorDone setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]];
        efactorDone.shadowColor = [UIColor whiteColor];
        efactorDone.shadowOffset = CGSizeMake(0.0, 1.0);
        [efactordonebutton setImage:[UIImage imageNamed:@"Added_button.png"] forState:UIControlStateNormal];
        efactordonebutton.userInteractionEnabled = false;
    }
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.myScrollView.delegate = self;
    
    self.myScrollView.scrollEnabled = YES;

    [self.myScrollView setContentSize:CGSizeMake(310, 1000)];
}

- (IBAction) doFacebookConnect {   
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"publishaction_done"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"facebook_btn"];
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetImages) name:FBSessionStateChangedNotification object:nil];
    [appDelegate openSessionWithAllowLoginUI:YES];
        
    
}


- (void) resetImages {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [facebookAdded setImage:[UIImage imageNamed:@"faceBookSettings.png"] forState:UIControlStateNormal];
    [facebookdone setText:@"Connected to Facebook"];
    [facebookdone setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]];
    facebookdone.shadowColor = [UIColor whiteColor];
    facebookdone.shadowOffset = CGSizeMake(0.0, 1.0);
    [facebookdonebutton setImage:[UIImage imageNamed:@"Added_button.png"] forState:UIControlStateNormal];
    facebookdonebutton.userInteractionEnabled = false;

}

- (void) switchChanged:(id) sender {
    
    UISwitch *theSwitch = (UISwitch *)sender;
    if (theSwitch.isOn){
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    } else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}


- (void) backButtonTapped {
    //[[self.navigationController.navigationBar viewWithTag:1203] removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) sendPushNotificationToken {
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [req sendPushNotificationToken];
    
}

- (IBAction)tweetButtonPressed:(id)sender {
    
    [self addLoadingView];
    [HuntProfileHelper showTwitterPop:self];
}


- (void) setUpTwitter:(id)sender {
    

    [twitteradded setImage:[UIImage imageNamed:@"twitter_blue.png"] forState:UIControlStateNormal];
    [twitterdone setText:@"Connected to Twitter"];
    [twitterdone setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]];
    twitterdone.shadowColor = [UIColor whiteColor];
    twitterdone.shadowOffset = CGSizeMake(0.0, 1.0);
    
    [twitterdonebutton setImage:[UIImage imageNamed:@"Added_button.png"] forState:UIControlStateNormal];
    twitterdonebutton.userInteractionEnabled = false;
    
    UIButton *tButton = (UIButton *)sender;
    NSString *twitterHandle = tButton.titleLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"twitter_btn"];
    [[NSUserDefaults standardUserDefaults] setObject:twitterHandle forKey:@"twitter_handle"];
    PeopleHuntRequests *peopleRequest = [[[PeopleHuntRequests alloc] init] autorelease];
    [peopleRequest addTwitterHandle];
    [[self.view viewWithTag:69] removeFromSuperview];

}


-(void) loginViewDidFinish:(NSNotification*)notification {
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
    //adding stuff
    [self profileApiCall];
    [linkedindonebutton setImage:[UIImage imageNamed:@"Added_button.png"] forState:UIControlStateNormal];
    linkedindonebutton.userInteractionEnabled = false;
	
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

- (IBAction) sendFeedback:(id)sender{
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
    
}
-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"PeopleHunt Feedback"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"bugs@peoplehunt.me"];
	
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text
	NSString *emailBody = @"My feedback is:";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			message.text = @"Result: failed";
			break;
		default:
			message.text = @"Result: not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:bugs@peoplehunt.me?&subject=PeopleHuntFeedback";
	NSString *body = @"&body=My feedback is:";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [myScrollView release];
    [linkedindonebutton release];
    [twitterdonebutton release];
    [efactordonebutton release];
    [facebookdonebutton release];
    [peopleReq release];
    [linkedinadded release];
    [twitteradded release];
    [linkedindone release];
    [twitterdone release];
    [notifications release];
    [backgroundCurve release];
    [backgroundCurve2 release];
    [backgroundCurve3 release];
    [backgroundCurve4 release];
    [backgroundCurve5 release];
    [message release];
    [super dealloc];
}


@end
