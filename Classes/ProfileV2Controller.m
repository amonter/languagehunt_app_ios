//
//  ProfileV2Controller.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 03/12/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "ProfileV2Controller.h"
#import "PeopleHuntRequests.h"
#import "HuntFeedController.h"
#import <QuartzCore/QuartzCore.h>
#import "iphoneCrowdAppDelegate.h"
#import "LinkAccountsController.h"
#import "ConnectionListController.h"
#import "PeopleHuntRequests.h"
#import "HuntProfileHelper.h"
#import "LoadingAnimationView.h"
#import "PlanningView.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
#import "Twitter/Twitter.h"
#import <Accounts/Accounts.h>
#endif

//#import "Mixpanel.h"




@interface ProfileV2Controller ()

@end

@implementation ProfileV2Controller
@synthesize groupData, myGroups, avatarImage, openGroups, myImageUrl, myScrollView, linkedinadded, twitteradded, linkedindone, twitterdone, backgroundCurve, backgroundCurve2, backgroundCurve3, backgroundCurve4, backgroundCurve5, peopleReq, notifications, message, linkedindonebutton,twitterdonebutton, efactordonebutton, facebookdonebutton, facebookAdded, facebookdone, bioLabel, futureLocationLabel, locationLabel;
@synthesize bioTextEdit;


- (void)setupProfileView {
    //add headerView
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 122)] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.tag = 72837;    
    
    //rounded white background    
    UIView *roundedLabel = [[[UIView alloc] initWithFrame:CGRectMake(11,11, 298,170)] autorelease];
	roundedLabel.backgroundColor = [UIColor whiteColor];
    roundedLabel.layer.borderColor = [UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1].CGColor;
    roundedLabel.layer.borderWidth = 1.0;
    //roundedLabel.layer.cornerRadius = 6.0;
    [myScrollView addSubview:roundedLabel];
    
    //Profile image
    AvatarImageView *profileImage = [[[AvatarImageView alloc] initWithFrame:CGRectMake(7, 7, 70, 70)] autorelease];
    profileImage.tag = 411;
    //profileImage.layer.cornerRadius = 6.0;
    [roundedLabel addSubview:profileImage];    
    [profileImage checkIfImageExists:[[NSUserDefaults standardUserDefaults] objectForKey:@"my_image"] theImageFrame:CGRectMake(0, 0, 70, 70)];
    
    //name    
    UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(86,5,180,20)] autorelease];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
	nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"];
    [roundedLabel addSubview:nameLabel];
    
    NSString *bioLabelText = [[NSUserDefaults standardUserDefaults] objectForKey:@"bio"];
    CGSize withinsize = CGSizeMake(200, 1000);
    CGSize szBioLabel = [bioLabelText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0] constrainedToSize:withinsize lineBreakMode:NSLineBreakByWordWrapping];
    bioLabel.frame = CGRectMake(86, 25, 200, 100);
    bioLabel.text = bioLabelText;
    bioLabel.textColor = [UIColor blackColor];
    bioLabel.backgroundColor = [UIColor clearColor];
    if (szBioLabel.height <100) [bioLabel sizeToFit];
    [roundedLabel addSubview:bioLabel];
    
    locationLabel.frame = CGRectMake(86, 120, 200, 20);
    locationLabel.text = [NSString stringWithFormat:@"Location: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"placemark"]];
    locationLabel.textColor = [UIColor blackColor];
    locationLabel.backgroundColor = [UIColor clearColor];
    [roundedLabel addSubview:locationLabel];
    self.locationLabel.hidden = false;
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"show_location"] boolValue])self.locationLabel.hidden = true;
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"planning"]){
        futureLocationLabel.frame = CGRectMake(86, 140, 190, 20);
        futureLocationLabel.text = [NSString stringWithFormat:@"Going: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"planning"]];
        futureLocationLabel.textColor = [UIColor blackColor];
        futureLocationLabel.backgroundColor = [UIColor clearColor];
        [roundedLabel addSubview:futureLocationLabel];
    }
    
    UIButton *editBio = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBio setFrame:CGRectMake(0, 0, 300, 170)];
    [editBio setBackgroundImage:[UIImage imageNamed:@"editButtonLarge.png"] forState:UIControlStateNormal];
    [editBio addTarget:self action:@selector(editProfileData) forControlEvents:UIControlEventTouchUpInside];
    [roundedLabel addSubview:editBio];
    
    //beginning of linking
    //Config the switch settings
    [self.notifications addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    //Check if notifications are active
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types == UIRemoteNotificationTypeNone){
        [self.notifications setOn:FALSE];
    }    
    
    //background images
    backgroundCurve.backgroundColor = [UIColor whiteColor];
    //backgroundCurve.layer.cornerRadius = 8.0;
    backgroundCurve.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1] CGColor];
    backgroundCurve.layer.borderWidth = 1;
    
    //background images
    backgroundCurve2.backgroundColor = [UIColor whiteColor];
    //backgroundCurve2.layer.cornerRadius = 8.0;
    backgroundCurve2.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1] CGColor];
    backgroundCurve2.layer.borderWidth = 1;
    
    //background images
    backgroundCurve3.backgroundColor = [UIColor whiteColor];
    //backgroundCurve3.layer.cornerRadius = 8.0;
    backgroundCurve3.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1] CGColor];
    backgroundCurve3.layer.borderWidth = 1;
    
    
    //background images
    backgroundCurve4.backgroundColor = [UIColor whiteColor];
    //backgroundCurve4.layer.cornerRadius = 8.0;
    backgroundCurve4.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1] CGColor];
    backgroundCurve4.layer.borderWidth = 1;
    
    //background images
    backgroundCurve5.backgroundColor = [UIColor whiteColor];
    //backgroundCurve5.layer.cornerRadius = 8.0;
    backgroundCurve5.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1] CGColor];
    backgroundCurve5.layer.borderWidth = 1;
    
    //add bio text
    bioTextEdit.delegate = self;
    bioTextEdit.text = @"I love meeting new people, travelling, learning languages and drinking chamomile tea.";    
    
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
    
    
    // Do any additional setup after loading the view from its nib.
    self.myScrollView.delegate = self;
    self.myScrollView.scrollEnabled = YES;    
    [self.myScrollView setContentSize:CGSizeMake(310, 800)];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"Landed on Profile View"];
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    //Close button
    /*UIButton *Button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 41)] autorelease];
    [Button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [Button setImage:[UIImage imageNamed:@"closePressed.png"] forState:UIControlStateHighlighted];
    [Button setImage:[UIImage imageNamed:@"closePressed.png"] forState:UIControlStateSelected];
    [Button addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView:Button] autorelease];*/
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(closePage)];
    backButton.tintColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:239.0/255.0 alpha:1.0];
    [backButton setBackgroundVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = backButton;
   
    [self setupProfileView];   
}

- (void) closePage{  
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction) doFacebookConnect {
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"Facebook btn Tapped"];
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
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"Twitter btn Tapped"];
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



- (IBAction) sendFacebookRequest {
    if (![[FBSession activeSession] isOpen]) {
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                [HuntProfileHelper facebookCall:nil otherId:nil];
            }];
        }
    } else {
        [HuntProfileHelper facebookCall:nil otherId:nil];
    }
}

- (IBAction) sendFeedback:(id)sender{
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"Send Feedback Tapped"];
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



- (void) accessInfoTap {
    
    UIView *theView = [self.view viewWithTag:573829];
    float ypos = theView.frame.origin.y-82;
    
    /*UIView *accessInfoPop = [[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,self.tableView.frame.size.height)] autorelease];
    accessInfoPop.backgroundColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:0.5];
    accessInfoPop.tag = 721194;
    [self.tableView addSubview:accessInfoPop];*/
    
    UIView *accessImage = [[[UIView alloc] initWithFrame:CGRectMake(55,ypos, 225,136)] autorelease];
    accessImage.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    accessImage.tag = 721194;
    //accessImage.layer.cornerRadius = 6.0;
    //[self.tableView addSubview:accessImage];
    
    UIButton *gotItButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gotItButton setFrame:CGRectMake(140, 85, 73, 42)];
    [gotItButton addTarget:self action:@selector(accessInfoTapRemove) forControlEvents:UIControlEventTouchUpInside];
    [gotItButton setBackgroundImage:[UIImage imageNamed:@"gotit.png"] forState:UIControlStateNormal];
    [accessImage addSubview:gotItButton];
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15,15,205,65)] autorelease];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    infoLabel.lineBreakMode = UILineBreakModeWordWrap;
    infoLabel.textAlignment = UITextAlignmentLeft;
    infoLabel.numberOfLines = 0;
	infoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    infoLabel.text = [NSString stringWithFormat:@"These are groups that your peoplehunt connections have given you access to."];
    [accessImage addSubview:infoLabel];
    [accessImage setAlpha:0.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    
    [accessImage setAlpha:1.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    
}

- (void) accessInfoTapRemove{
    
    /*NSArray *thearray = [self.tableView subviews];
    for (UIView *theView in thearray) {
        if (theView.tag == 721194) {
            [theView removeFromSuperview];
        }
        NSLog(@"removing access");
        
    }*/
    
}



#pragma - mark Navigation methods
- (void) editProfileData {
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"Edit Profile Tapped"];
    PlanningView* editProfile = [[[PlanningView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) superController:self.view navigationController:self.navigationController] autorelease];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(updateBio)
                                                 name:@"edit_bio" object:editProfile];   

}

- (void) updateBio  {
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"Profile Updated"];
    NSString *bioLabelText = [[NSUserDefaults standardUserDefaults] objectForKey:@"bio"];
    CGSize withinsize = CGSizeMake(200, 1000);
    CGSize szBioLabel = [bioLabelText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0] constrainedToSize:withinsize lineBreakMode:NSLineBreakByWordWrapping];
    self.bioLabel.text = bioLabelText;
    if (szBioLabel.height <100) [bioLabel sizeToFit];
    self.futureLocationLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"planning"];
    self.locationLabel.hidden = false;
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"show_location"] boolValue])self.locationLabel.hidden = true;
}

- (void) viewConnections {
    ConnectionListController *con = [[[ConnectionListController alloc] initWithNibName:@"ConnectionListController" bundle:nil] autorelease];
    [self.navigationController pushViewController:con animated:YES];

}


- (IBAction) goSettings {
    LinkAccountsController *socialLinking = [[[LinkAccountsController alloc] initWithNibName:@"LinkAccountsController" bundle:nil] autorelease];
    [self.navigationController pushViewController:socialLinking animated:YES];
    
}

#pragma - mark profile methods
- (void) updateData {

    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updateProfileGroups:)
                                                 name:@"load_end" object:req];
    [req retrieveMyGroupsProfile];
}

- (void) updateProfileGroups:(NSNotification *) data {
    if ([self.tableGroups count] > 0){
        [self.tableGroups removeAllObjects];
    }
    //NSLog(@"RES %@",[data userInfo]);
    NSDictionary *open = [[[NSDictionary alloc] initWithObjectsAndKeys:[[data userInfo] objectForKey:@"open"], @"open", nil] autorelease];
    [self.tableGroups addObject:open];
    NSDictionary *members = [[[NSDictionary alloc] initWithObjectsAndKeys:[[data userInfo] objectForKey:@"member"], @"member", nil] autorelease];
     [self.tableGroups addObject:members];
    
    NSArray *accessArray = [[data userInfo] objectForKey:@"access"];
    if ([accessArray count] > 0){
        NSDictionary *access = [[[NSDictionary alloc] initWithObjectsAndKeys:[[data userInfo] objectForKey:@"access"], @"access", nil] autorelease];
        [self.tableGroups addObject:access];
    }
    
    //set connections value
    UILabel *connections = (UILabel *)[self.view viewWithTag:9991245];
    connections.text = [NSString stringWithFormat:@"%i", [[[data userInfo] objectForKey:@"connections"] intValue]];
}


- (void) doneAdding:(NSNotification *) data {
    
    //[self.tableGroups removeAllObjects];
    int myProfile = [[[data userInfo] objectForKey:@"profileid"] intValue];
    if (myProfile > 0){
        [[NSUserDefaults standardUserDefaults] setObject:@"profile" forKey:@"last_active"];    
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:myProfile] forKey:@"profileid"];
  
        NSDictionary *open = [[[NSDictionary alloc] initWithObjectsAndKeys:[[data userInfo] objectForKey:@"open"], @"open", nil] autorelease];
        [self.tableGroups insertObject:open atIndex:0];
        if ([[[data userInfo] objectForKey:@"member"] count] > 0){
            //[self.tableGroups removeAllObjects];
            NSDictionary *members = [[[NSDictionary alloc] initWithObjectsAndKeys:[[data userInfo] objectForKey:@"member"], @"member", nil] autorelease];
            [self.tableGroups insertObject:members atIndex:1];
        }
    
        if ([[[data userInfo] objectForKey:@"access"] count] > 0){
            NSDictionary *access = [[[NSDictionary alloc] initWithObjectsAndKeys:[[data userInfo] objectForKey:@"access"], @"access", nil] autorelease];
            [self.tableGroups insertObject:access atIndex:2];
        }        
        
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_active"];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Oops, Something went wrong while creating your account. Please try again!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];       
    }
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.tableGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    
    NSArray *value = [[[self.tableGroups objectAtIndex:section] allValues] objectAtIndex:0];   
    return [value count];
}

- (void)createButton:(int)theRow cell:(UITableViewCell *)cell {
    UIButton *checkGroup = [UIButton buttonWithType:UIButtonTypeCustom];
    checkGroup.tag = theRow;
    [checkGroup setFrame:CGRectMake(236, 0, 73, 42)];
    [checkGroup addTarget:self action:@selector(joinGroup:) forControlEvents:UIControlEventTouchUpInside];
    [checkGroup setBackgroundImage:[UIImage imageNamed:@"join.png"] forState:UIControlStateSelected];
    [checkGroup setBackgroundImage:[UIImage imageNamed:@"join.png"] forState:UIControlStateNormal];
    [cell.contentView addSubview:checkGroup];
}

- (UITableViewCell *)tableView:(UITableView *) aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyGroup";
    int theRow = [indexPath row];
    NSDictionary *data = [self.tableGroups objectAtIndex:[indexPath section]];
    NSString *theKey = [[data allKeys] objectAtIndex:0];
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = 99;
              
        if ([theKey isEqualToString:@"open"]){
            
            UILabel *groupName = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 215, 42)] autorelease];
            groupName.tag = 555;
            groupName.backgroundColor = [UIColor clearColor];
            groupName.lineBreakMode = UILineBreakModeWordWrap;
            groupName.numberOfLines = 0;
            groupName.textColor = [UIColor blackColor];
            groupName.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
            [cell.contentView addSubview:groupName];
            
            [self createButton:theRow cell:cell];
           
        }else{
            //Group name
            UILabel *groupName = [[[UILabel alloc] initWithFrame:CGRectMake(11, 0, 298, 42)] autorelease];
            groupName.tag = 555;
            groupName.backgroundColor = [UIColor clearColor];
            groupName.lineBreakMode = UILineBreakModeWordWrap;
            groupName.numberOfLines = 0;
            groupName.textColor = [UIColor blackColor];
            groupName.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
            [cell.contentView addSubview:groupName];
            
        }
        
    } else {        
       
        NSArray *views = [cell.contentView subviews];
        for (UIView *theView in views) {
            if ([theView isKindOfClass:[UIButton class]]) {
                [theView removeFromSuperview];
            }
        }
        
        if ([theKey isEqualToString:@"open"]){
            NSArray *views = [cell.contentView subviews];
            bool hasButton = false;
            for (UIView *theView in views) {
                if ([theView isKindOfClass:[UIButton class]]) {
                    hasButton = true;                  
                }
            }
            if (!hasButton){
                [self createButton:theRow cell:cell];
            }
        }
    }
    
    
    ((UILabel *)[cell viewWithTag:555]).text = [[[data objectForKey:theKey] objectAtIndex:theRow] objectForKey:@"description"];
    [cell setNeedsLayout];

    
    // Set up the cell...    
    [cell setNeedsLayout];
    
    return cell;
}




- (void) joinGroup:(id) sender {
    
    UIView *theCell = [[((UIButton *)sender) superview] superview];
    NSIndexPath *indexToRemove = nil;
    if ([theCell isKindOfClass:[UITableViewCell class]]){
        //indexToRemove = [self.tableView indexPathForCell:((UITableViewCell *)theCell)];
    }
    
    //retrieve open groups
    NSDictionary *retrievedRow = nil;
    NSDictionary *openGroupDic = nil;
    for (NSDictionary *sectionDic in self.tableGroups) {
        NSString *theKey = [[sectionDic allKeys] objectAtIndex:0];
        if ([theKey isEqualToString:@"open"]){
            retrievedRow = [[sectionDic objectForKey:theKey] objectAtIndex:[indexToRemove row]];
            openGroupDic = [[sectionDic retain] autorelease];
        }
        
    }       
    
    //Retrieve member section content - index here
    NSMutableArray *arrayToAdd = [[[[[self.tableGroups objectAtIndex:1] allValues] objectAtIndex:0] mutableCopy] autorelease];
    [arrayToAdd insertObject:retrievedRow atIndex:0];
    [self.tableGroups removeObjectAtIndex:0];
    
    //add new updated row to member section array
    NSDictionary *coreAdition = [[[NSDictionary alloc] initWithObjectsAndKeys:arrayToAdd, @"member", nil] autorelease];
    [self.tableGroups insertObject:coreAdition atIndex:1];//index here
    
    //delete the array from open section
    NSMutableArray *arrayToDelete = [[[[openGroupDic allValues] objectAtIndex:0] mutableCopy] autorelease];
    [arrayToDelete removeObjectAtIndex:[indexToRemove row]];
    [self.tableGroups removeObjectAtIndex:0];
    
    //add the new updated set to open group row
    NSDictionary *openAdition = [[[NSDictionary alloc] initWithObjectsAndKeys:arrayToDelete, @"open", nil] autorelease];
    [self.tableGroups insertObject:openAdition atIndex:0];
    
    //add the row to the section
    NSMutableArray *addArray = [[[NSMutableArray alloc] init] autorelease];
    [addArray addObject:[NSIndexPath indexPathForRow:0 inSection:1]];//index here
    
    //delete the row to the section
    NSMutableArray *deleteArray = [[[NSMutableArray alloc] init] autorelease];
    [deleteArray addObject:indexToRemove];

    //[self.tableView beginUpdates];
    //[self.tableView insertRowsAtIndexPaths:addArray withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView endUpdates];
    
    //add user membership
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    NSLog(@"the ID %i", [[retrievedRow objectForKey:@"id"] intValue]);
    [req addGroupMembership:[[retrievedRow objectForKey:@"id"] intValue]];
    
     
}


#pragma mark - textView did begin editing
- (void)textViewDidBeginEditing:(UITextView *)textView {
    //Change here depending on device
    [myScrollView scrollRectToVisible:CGRectMake(0, 140, 320, myScrollView.frame.size.height) animated:YES];
}

#pragma - mark this are the table methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *theTitle = @"";
    if ([self.tableGroups count] > 0){
        NSLog(@"title %@ sec %i", self.tableGroups, section);
        theTitle = [[[self.tableGroups objectAtIndex:section] allKeys] objectAtIndex:0];
    }
    return theTitle;
}

- (UIButton *) retrieveUIButton:(UITableViewCell *) theCell {
    NSArray *subViews = [theCell.contentView subviews];
    for (id theView in subViews) {
        if ([theView isKindOfClass:[UIButton class]]){
            return ((UIButton *)theView);
            
        }
    }
    
    return nil;
}


- (CGSize) getCellWidth:(UITableView *)aTableView copy:(NSString *)copy theRow:(NSIndexPath *)indexPath{
    
    NSDictionary *data = [self.tableGroups objectAtIndex:[indexPath section]];
    NSString *theKey = [[data allKeys] objectAtIndex:0];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    CGSize withinsize;
    
    if ([theKey isEqualToString:@"open"]){
        withinsize = CGSizeMake(215, 2000); //1000 is just a large number. could be 500 as well
        // You can choose a different Wrap Mode of your choice
    }else{
        withinsize = CGSizeMake(298, 2000); //1000 is just a large number. could be 500 as well
        // You can choose a different Wrap Mode of your choice
    }
    
    return [copy sizeWithFont:font constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap];
}


- (CGFloat)tableView:(UITableView *) aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int theRow = [indexPath row];
    NSDictionary *data = [self.tableGroups objectAtIndex:[indexPath section]];  
    
    NSString *copy = [[[[data allValues]  objectAtIndex:0] objectAtIndex:theRow] objectForKey:@"description"];
    CGSize sz = [self getCellWidth:aTableView copy:copy theRow:indexPath];
    //you need to use size to fit to make the label wrap correctly, but it needs to be constrained to the top or bottom using the struts, without any inner expansion in nib.
    //Or - if it causes funky behaviour, instead you can use setneedslayout of the cell, and in the cell, you calculate the frame again, and in the nib, position the uilabel at the very top of the cell and it will expand to fill it
    
    if (sz.height==42) {
        return sz.height;
    }else{
        return sz.height + 22;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionBack = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 45)] autorelease];
    sectionBack.backgroundColor = [UIColor whiteColor];
    sectionBack.userInteractionEnabled= true;
   
    switch (section) {
        case 2:
            sectionBack.tag = 573829;
            //access info button
            UIButton *accessInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [accessInfoBtn setFrame:CGRectMake(288, -5, 27, 42)];
            [accessInfoBtn addTarget:self action:@selector(accessInfoTap) forControlEvents:UIControlEventTouchUpInside];
            [accessInfoBtn setBackgroundImage:[UIImage imageNamed:@"infoButton.png"] forState:UIControlStateNormal];
            [sectionBack addSubview:accessInfoBtn];
            
            break;
        case 1:
            sectionBack.tag = 566829;
          
        default:
            sectionBack.tag = 134553;
           
        
            break;
    }
  
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,4,218,24)] autorelease];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1];
	headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    
    NSString *header = [[[self.tableGroups objectAtIndex:section] allKeys] objectAtIndex:0];
    if ([header isEqualToString:@"open"]) header = @"PeopleHunt groups";
    if ([header isEqualToString:@"member"]) header = @"My groups";
    if ([header isEqualToString:@"access"]) header = @"My network's groups";
    headerLabel.text = header;

    [sectionBack addSubview:headerLabel];
    
    
    UILabel *headerLine = [[[UILabel alloc] initWithFrame:CGRectMake(0,34,320,1)] autorelease];
	headerLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1];
    [sectionBack addSubview:headerLine];

    
	return sectionBack;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}


- (void) viewWillAppear:(BOOL)animated {
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"Profile.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [bioTextEdit release];
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
    [myImageUrl release];
    [openGroups release];
    [avatarImage release];
    [myGroups release];
    [groupData release];
    [bioLabel release];
    [futureLocationLabel release];
    [locationLabel release];
    [super dealloc];
}

@end
