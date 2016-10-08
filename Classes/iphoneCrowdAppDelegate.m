//
//  iphoneCrowdAppDelegate.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 09/07/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "iphoneCrowdAppDelegate.h"
#import "FirstLevelViewController.h"
#import "Reachability.h"
#import "GroupSelectionController.h"
#import "ProfileV2Controller.h"
#import "PeopleHuntRequests.h"
#import "LinkAccountsController.h"
#import "HuntFeedController.h"
#import "SocialLinkingController.h"
#import "MainCardController.h"
#import "IntroSwipeController.h"


#import "ProtocolCommunication.h"
#import "NotificationsController.h"
#import "iRate.h"
#import "iVersion.h"

#import "SegmentsController.h"
#import "ConnectionListController.h"
#import "CommunityActivityController.h"
#import "NSArray+PerformSelector.h"
#import <QuartzCore/QuartzCore.h>
//#import "Mixpanel.h"
#import "MissingLangController.h"
#import <Stripe/Stripe.h>


NSString *const FBSessionStateChangedNotification = @"com.peoplehunt.peoplehuntv2:FBSessionStateChangedNotification";

NSString * const StripePublishableKey = @"pk_live_zvyoPjR59S92qDDCvnEXYTiy";

//NSString * const StripePublishableKey = @"pk_test_MX4NqpiShAgTRlDGPmUnlVSl";

@implementation iphoneCrowdAppDelegate
@synthesize navigationController;
@synthesize session = _session;
@synthesize protocol;
@synthesize process;
@synthesize matcherRequest, theMatch, otherUsername, segmentControl, segmentsCustom;



#pragma - mark iRate method
+ (void)initialize {    
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 3;
    [iRate sharedInstance].usesUntilPrompt = 4;
    //configure iVersion
    [iVersion sharedInstance].appStoreID = 579833763;
    [iVersion sharedInstance].remoteVersionsPlistURL = @"http://50.19.45.37:8080peoplehuntversion.plist";
}



#pragma Facebook methods

- (BOOL)openSessionReadWithAllowLoginUI:(BOOL)allowLoginUI {
    
    NSArray *permissions = [[[NSArray alloc] initWithObjects:
                            @"email, user_about_me",
                             nil] autorelease];
    return [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:allowLoginUI 
                                            completionHandler:^(FBSession *session,
                                                                FBSessionState state,
                                                                NSError *error) {
                                                [self sessionStateChanged:session
                                                                    state:state
                                                                    error:error];
                                            }];
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    NSArray *permissions = [[[NSArray alloc] initWithObjects:
                             @"publish_actions",
                             nil] autorelease];
    return [FBSession openActiveSessionWithPublishPermissions:permissions
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                                 allowLoginUI:allowLoginUI
                                            completionHandler:^(FBSession *session,
                                                                FBSessionState state,
                                                                NSError *error) {
                                                [self sessionStateChanged:session
                                                                    state:state
                                                                    error:error];
                                            }];
}






- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
            NSLog(@"SESSION CLOSED");
            break;
        case FBSessionStateClosedLoginFailed:
            //[FBSession.activeSession closeAndClearTokenInformation];
            NSLog(@"login failed and stuff");
            break;
        case FBSessionStateCreatedTokenLoaded:
            NSLog(@"token created and stuff");
            break;
        default:
            NSLog(@"other");
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        NSString *errorTitle = NSLocalizedString(@"Error", @"Facebook connect");
        NSString *errorMessage = [error localizedDescription];
        if (error.code == FBErrorLoginFailedOrCancelled) {
            errorTitle = NSLocalizedString(@"Facebook Login Failed", @"Facebook Connect");
            errorMessage = NSLocalizedString(@"Make sure you've allowed My App to use Facebook in Settings > Facebook.", @"Facebook connect");
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorTitle
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"Facebook Connect")
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}



//FAceboon callback method
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[FBSession activeSession] handleOpenURL:url];
}


- (void)doPushNotifications {
    //Push notifications  
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}


- (void) doPopUpdate {

    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"*Announcement*" message:@"Hi there PeopleHunt user,\nWe’re sorry, but this version of PeopleHunt is no longer supported.\nPlease install a brand new version, (and delete this version)." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Install", nil];
    [theAlert show];
    [theAlert release];
}

#pragma AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if (buttonIndex == 1) {
        NSString *defaultUrl = @"itms-apps://itunes.apple.com/app/peoplehuntv2/id579833763?ls=1&mt=8";
        NSString *storedUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"update_url"];
        if (storedUrl) defaultUrl = storedUrl;
    
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:defaultUrl]];
     }
   
}

- (void) retrieveUpdateLink {
    
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue: [NSOperationQueue mainQueue]
     usingBlock: ^(NSNotification * note) {
         NSLog(@"THE URL %@", [[note userInfo] objectForKey:@"url"]);
         [[NSUserDefaults standardUserDefaults] setObject:[[note userInfo] objectForKey:@"url"] forKey:@"update_url"];
    }];
    
    [req retrieveLatestUpdateLink];

}

- (void) applicationDidFinishLaunching:(UIApplication *)application {   
	
	sleep(1);
	//[self startGeolocation];
    
    float delayHunt = 1.6;
    bool isCellConnection = [self checkConnectivity];
    if (isCellConnection) delayHunt = 1.8;
    
	self.navigationController.title = @"theroot";
    [window setRootViewController:navigationController];	
    [window makeKeyAndVisible];	
    //[self retrieveUpdateLink];
    
    //[self doPushNotifications];
    NSString *activated = [[NSUserDefaults standardUserDefaults] objectForKey:@"hunt_activated"];
    if (activated){      
        [self performSelector:@selector(startHunting) withObject:nil afterDelay:delayHunt];
    }
   
    
    [self initProtocolCommunicationMainThread];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_matchconnections"];
}




- (bool)checkConnectivity {
    // Part 1 - Create Internet socket addr of zero
    struct sockaddr_in zeroAddr;
	bzero(&zeroAddr, sizeof(zeroAddr));
	zeroAddr.sin_len = sizeof(zeroAddr);
	zeroAddr.sin_family = AF_INET;
    
	// Part 2- Create target in format need by SCNetwork
	SCNetworkReachabilityRef target =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddr);
    
	// Part 3 - Get the flags
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(target, &flags);
    
	// Part 4 - Create output
	bool sNetworkReachable = false;
	if (flags & kSCNetworkFlagsReachable)sNetworkReachable = true;
    
    if (!sNetworkReachable) {    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet"
                                                        message:@"whoops! we can't find an internet connection" delegate:self
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
	bool sCellNetwork = false;
	if (flags & kSCNetworkReachabilityFlagsIsWWAN)sCellNetwork = true;
	
    return sCellNetwork;	
}


- (void) goIntroSwipe:(bool) profileMode {
        
    PeopleHuntRequests *req = [[PeopleHuntRequests alloc] init];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        
        NSLog(@"MAIN DATA %@", [notification userInfo]);
        NSArray *profile = [[notification userInfo] objectForKey:@"locations"];
        NSMutableDictionary* allSelectedData2 = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* theLocations2 = [[NSMutableDictionary alloc] init];
        for (NSDictionary* theLoc in profile) {
            [theLocations2 setObject:[theLoc objectForKey:@"location"] forKey:[theLoc objectForKey:@"id"]];
        }
        
        [allSelectedData2 setObject:theLocations2 forKey:@"locations"];
        [allSelectedData2 setObject:[[notification userInfo] objectForKey:@"help"] forKey:@"help"];
        [allSelectedData2 setObject:[[notification userInfo] objectForKey:@"interested"] forKey:@"interested"];
        [allSelectedData2 setObject:[[notification userInfo] objectForKey:@"bio"] forKey:@"bio"];
        [allSelectedData2 setObject:[[notification userInfo] objectForKey:@"personalInterests"] forKey:@"interests"];
        [allSelectedData2 setObject:[[notification userInfo] objectForKey:@"name"] forKey:@"name"];          
        [allSelectedData2 setObject:[[notification userInfo] objectForKey:@"imageURL"] forKey:@"image_url"];
        IntroSwipeController *introSwipe = [[IntroSwipeController alloc] initWithNibName:@"IntroSwipeController" bundle:nil];
        introSwipe.preStoredData = allSelectedData2;
        introSwipe.profileMode = profileMode;
        [self.navigationController pushViewController:introSwipe animated:NO];
        
    }];
    
    [req retrieveProfileData];


}

- (void)loadMainCardController {
    PeopleHuntRequests *req = [[PeopleHuntRequests alloc] init];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        NSArray *profile = [[notification userInfo] objectForKey:@"locations"];
        NSMutableDictionary* allSelectedData = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* theLocations = [[NSMutableDictionary alloc] init];
        for (NSDictionary* theLoc in profile) {
            [theLocations setObject:[theLoc objectForKey:@"location"] forKey:[theLoc objectForKey:@"id"]];
        }
        
        [allSelectedData setObject:theLocations forKey:@"locations"];
        [allSelectedData setObject:[[notification userInfo] objectForKey:@"help"] forKey:@"help"];
        [allSelectedData setObject:[[notification userInfo] objectForKey:@"interested"] forKey:@"interested"];
        MainCardController* mainCard = [[MainCardController alloc] initWithNibName:@"MainCardController" bundle:nil];
        NSLog(@"ALL SELECTED %@", allSelectedData);
        mainCard.selectedLocation = theLocations;
        mainCard.allSelectedData = allSelectedData;
        mainCard.loadAllLocations = true;
        [self.navigationController pushViewController:mainCard animated:NO];
        
    }];
    [req retrieveProfileData];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hunt_activated"];
	sleep(1);
	//[self startGeolocation];
    float delayHunt = 1.6;
    bool isCellConnection = [self checkConnectivity];
    if (isCellConnection) delayHunt = 1.8;
    
    [window setRootViewController:navigationController];
    [window makeKeyAndVisible];
    //[self retrieveUpdateLink];
    
    //Check if the application has been open from a push notification, then hunt!!
    NSString *activated = [[NSUserDefaults standardUserDefaults] objectForKey:@"hunt_activated"];
    UIViewController *visible = navigationController.visibleViewController;    
    for (id key in launchOptions) {
		if (key == UIApplicationLaunchOptionsRemoteNotificationKey) {
            activated = nil;
            if (![visible isKindOfClass:[MainCardController class]]) {
                [self loadMainCardController];
            }
            activated = nil;           
            [self initProtocolCommunicationMainThread];
            //[self performSelector:@selector(getLiveConnections) withObject:nil afterDelay:delayHunt];
            //[self performSelector:@selector(startHunting) withObject:nil afterDelay:delayHunt+ 0.5];
            
            /*PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
            [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
                [self performSelector:@selector(startHunting) withObject:nil afterDelay:delayHunt];
            }];
            [req disableNotifications];*/                        
        }
	}  
    
   
    //[self doPushNotifications];
    if (activated){
        //[self performSelector:@selector(startHunting) withObject:nil afterDelay:3.5];
        [self initProtocolCommunicationMainThread];
    }
    
    
    self.relanched = true;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_matchconnections"];
    //[Mixpanel sharedInstanceWithToken:@"0a43af19ab2cef99e306cf22c828b2bf"];
    [Stripe setDefaultPublishableKey:StripePublishableKey];
	

    return YES;
    
}	



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {   
    
    UIApplicationState state = [application applicationState];
    if (state != UIApplicationStateActive) {
        //check that NotificationController is not displayed
        float delayHunt = 1.6;
        bool isCellConnection = [self checkConnectivity];
        if (isCellConnection) delayHunt = 1.8;
        UIViewController *visible = navigationController.visibleViewController;
        if (![visible isKindOfClass:[MainCardController class]]) {
            [self loadMainCardController];
        }
        
        [self performSelector:@selector(initProtocolCommunicationMainThread) withObject:nil afterDelay:delayHunt];
        /*NSString *activated = [[NSUserDefaults standardUserDefaults] objectForKey:@"hunt_activated"];
        if (activated){
            PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
            [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
                //[self performSelector:@selector(startHunting) withObject:nil afterDelay:delayHunt];
            }];
            [req disableNotifications];            
        }*/
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_matchconnections"];
}


- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation *newLocation = [locations objectAtIndex:0];
    NSString *latitudeString = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.latitude];
    NSString *longitudeString = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.longitude];
    NSLog(@"Geolocation IPHONE %@, %@", latitudeString, longitudeString);
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          latitudeString, @"latitude",
                          longitudeString, @"longitude", nil];
    
    NSDictionary *storedLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_location"];
    if ([storedLocation count] == 0){
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"current_location"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"current_location"];
    CLGeocoder *geoCoder = [[[CLGeocoder alloc] init] autorelease];
    [geoCoder reverseGeocodeLocation: locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"LOC %@ %@", placemark.country, placemark.locality);
         [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.country] forKey:@"placemark"];
         [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", placemark.locality] forKey:@"locality"];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"placemark_ready" object:self];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"location_denied"];
     }];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"show_location"];
    [manager stopUpdatingLocation];
    [latitudeString release];
    [longitudeString release];
    [dict release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"location_ready" object:self];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    //[[NSUserDefaults standardUserDefaults] objectForKey:@"locality"];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"location_denied"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"location_denied" object:self];
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"the_token"];
    UIViewController *visible = navigationController.visibleViewController;
    if ([visible isKindOfClass:[LinkAccountsController class]]) {
        PeopleHuntRequests *peopleRequest = [[[PeopleHuntRequests alloc] init] autorelease];
        //[peopleRequest sendPushNotificationToken];
    }  
    
	NSLog(@"My token is: %@", deviceToken);    
}


- (void) displayAccessScreen:(NSString *) yourMatchName otherUsername:(NSString *) username {

    self.otherUsername = username;
    UIViewController *visible = navigationController.visibleViewController;
    UIView *giveAccessPop = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)] autorelease];
    giveAccessPop.backgroundColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:0.5];
    giveAccessPop.tag = 801117;
    [visible.view addSubview:giveAccessPop];
    
    UIView *greyBoxCorners = [[[UIView alloc] initWithFrame:CGRectMake(20, 50, 281, 257)] autorelease];
    greyBoxCorners.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    greyBoxCorners.layer.cornerRadius = 6.0;
    [giveAccessPop addSubview:greyBoxCorners];

    //[self.view addSubview:closeWarningPop];
    //NSDictionary *allData = [data userInfo];
    //NSString *theName2 = [[allData objectForKey:@"1"] objectForKey:@"name"];
    
    UILabel *giveAccessLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20,15,240,120)] autorelease];
    giveAccessLabel.backgroundColor = [UIColor clearColor];
    giveAccessLabel.textColor = [UIColor whiteColor];
    giveAccessLabel.lineBreakMode = UILineBreakModeWordWrap;
    giveAccessLabel.textAlignment = UITextAlignmentLeft;
    giveAccessLabel.numberOfLines = 0;
    giveAccessLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    giveAccessLabel.text = [NSString stringWithFormat:@"Did you have a good connection? \n\nShare the love by giving %@ access to your groups so they can get connected with more people.", yourMatchName];
    [greyBoxCorners addSubview:giveAccessLabel];
    
    UIButton *giveAccessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    giveAccessBtn.tag = 345671;
    [giveAccessBtn setFrame:CGRectMake(20, 145, 42, 42)];
    [giveAccessBtn addTarget:self action:@selector(giveAccessOn:) forControlEvents:UIControlEventTouchUpInside];
    [giveAccessBtn setSelected:YES];
    [giveAccessBtn setBackgroundImage:[UIImage imageNamed:@"knowUnpressed.png"] forState:UIControlStateNormal];
    [giveAccessBtn setBackgroundImage:[UIImage imageNamed:@"knowPressed.png"] forState:UIControlStateSelected];
    [greyBoxCorners addSubview:giveAccessBtn];
    
    UILabel *tickLabel = [[[UILabel alloc] initWithFrame:CGRectMake(62,155,200,20)] autorelease];
    tickLabel.backgroundColor = [UIColor clearColor];
    tickLabel.textColor = [UIColor whiteColor];
    tickLabel.lineBreakMode = UILineBreakModeWordWrap;
    tickLabel.textAlignment = UITextAlignmentLeft;
    tickLabel.numberOfLines = 0;
    tickLabel.tag = 182937;
    tickLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [greyBoxCorners addSubview:tickLabel];
    if (giveAccessBtn.selected){
        tickLabel.text = [NSString stringWithFormat:@"Yes, give access"];
    }
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(91, 190, 99, 46)];
    [saveButton addTarget:self action:@selector(saveAccess:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"save_large.png"] forState:UIControlStateNormal];
    [greyBoxCorners addSubview:saveButton];
    
    [greyBoxCorners setAlpha:0.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    
    [greyBoxCorners setAlpha:1.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    
}

- (void) giveAccessOn: (id) sender {
    
    UIViewController *visible = navigationController.visibleViewController;
    if (((UIButton *)sender).selected) {//don't give access
        NSLog(@"DONT GIVE ACCESS");
        ((UIButton *)sender).selected = NO;
        [(UIButton *)sender setBackgroundImage:[UIImage imageNamed:@"knowUnpressed.png"] forState:UIControlStateNormal];
        UILabel *labelBtn = (UILabel *)[visible.view viewWithTag:182937];
        labelBtn.text = [NSString stringWithFormat:@"No, don't give access"];
        
    } else {//give access
        NSLog(@"GIVE ACCESS");
        ((UIButton *)sender).selected = YES;
        [(UIButton *)sender setBackgroundImage:[UIImage imageNamed:@"knowPressed.png"] forState:UIControlStateSelected];
        UILabel *labelBtn = (UILabel *)[visible.view viewWithTag:182937];
        labelBtn.text = [NSString stringWithFormat:@"Yes, give access"];
    }

}

- (void) saveAccess:(id) sender {
    
    UIView *superView = [[((UIButton *)sender).superview retain] autorelease];
    [[self.navigationController.view viewWithTag:801117] removeFromSuperview];
    UIButton *accessButton = (UIButton *)[superView viewWithTag:345671];
    if (accessButton.selected){       
        PeopleHuntRequests *request = [[[PeopleHuntRequests alloc] init] autorelease];
        [request giveGroupAccess:self.otherUsername];
    }
    
    [self startHunting];
}

- (void) notifiyPhotoDone {

    UIViewController *visible = navigationController.visibleViewController;
    if ([visible isKindOfClass:[ProfileV2Controller class]]) {
        //[((ProfileV2Controller *) visible) setUserPhoto];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
   	NSLog(@"Failed to get token, error: %@", error);
}



- (UINavigationController*) retrieveMessageSegments {    
    
    ConnectionListController *prof = [[[ConnectionListController alloc] initWithNibName:@"ConnectionListController" bundle:nil] autorelease];
    CommunityActivityController* com = [[[CommunityActivityController alloc] initWithNibName:@"CommunityActivityController" bundle:nil] autorelease];
    
    NSArray * viewControllers = [NSArray arrayWithObjects:prof, com, nil];
    
    UINavigationController* theNavCotrol = [[[UINavigationController alloc] init] autorelease];
    self.segmentsCustom = [[SegmentsController alloc] initWithNavigationController:theNavCotrol viewControllers:viewControllers];
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:[viewControllers arrayByPerformingSelector:@selector(theTitle)]];
    self.segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    [self.segmentControl addTarget:self.segmentsCustom
                              action:@selector(indexDidChangeForSegmentedControl:)
                    forControlEvents:UIControlEventValueChanged];
    
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentsCustom indexDidChangeForSegmentedControl:self.segmentControl];

    return theNavCotrol;
}



- (void) applicationDidBecomeActive:(UIApplication *)application {
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"open the app"];
    if (!self.relanched) {               
        [self initProtocolCommunicationMainThread];
    }  
    
    //load_matchconnections
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_matchconnections"];
    UIViewController *visible = navigationController.visibleViewController;
    if ([visible isKindOfClass:[MainCardController class]]){
        [((MainCardController *)visible).matchCell getMessages];
        AsynchMessageController* chatScreen = ((MainCardController *)visible).soloMessage;
        if (chatScreen != nil){
            [chatScreen retrieveInbox];
        }
    }
    [FBSession.activeSession handleDidBecomeActive];
    //check for geolocation again
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"location_denied"]){
        [self startGeolocation];
        
    }
    
}


- (void) applicationDidEnterBackground:(UIApplication *)application {
	self.relanched = false;      
   
	UIViewController *visible = navigationController.visibleViewController;	
    if ([visible isKindOfClass:[MainCardController class]]){
        [[NSUserDefaults standardUserDefaults] setObject:@"main" forKey:@"last_active"];       
        [((MainCardController *)visible) viewWillDisappear:YES];        
    }    
   
    [self cancelHunting];
    if (protocol != nil){
        [protocol closeNetworkCommunication];
    }
    NSLog(@"LAST ACTIVE %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"last_active"]);        
}



- (void) startHunting {
  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"match_found" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"no_match" object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hunt_activated"];
        int profileId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue];
        if (self.matcherRequest == nil){
            self.matcherRequest = [[[TheMatcher alloc] init:profileId] autorelease];
        }
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startHunting)
                                                     name:@"match_found" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startHunting)
                                                     name:@"no_match" object:nil];        

        //[self.matcherRequest findMatch];
    }
}

#pragma - mark Open socket connection
- (void) initProtocolCommunicationMainThread {
 
    int theProfileId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue];
    if (theProfileId > 0) {        
        if (protocol == nil){
            protocol = [[[ProtocolCommunication alloc] init] retain];
            process = [[[ProcessingProtocol alloc] init] retain];
            protocol.delegate = process;
        }
    
        [protocol initNetworkCommunication];
        NSLog(@"SENDING REQUEST");
        [protocol sendMessage:[NSString stringWithFormat:@"1:%i:%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue], [[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"]]];
        
    }
}

- (void) checkHeartBeat {    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"heartbeat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(cancelReset)
                                                 name:@"heartbeat" object:nil];
    [protocol sendMessage:@"0:echo"];
    [self performSelector:@selector(repeatHeartBeat) withObject:[NSNumber numberWithInt:1000] afterDelay:2.9];
}

- (void) getLiveConnections {
    //[protocol sendMessage:@"80:getliveusers"];
}


- (void) repeatHeartBeat {
    [self resetConnection];
    [self checkHeartBeat];
}

- (void) cancelReset {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"heartbeatdone" object:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self startHunting];
}

- (void) resetConnection {   
    [protocol closeNetworkCommunication];
    protocol = nil;
    [self initProtocolCommunicationMainThread];
}


#pragma - mark view manipulation
- (void) cancelHunting {
    [self.matcherRequest killHunting];
    self.matcherRequest = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"match_found" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"no_match" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) displayPeopleSearch {
    
    UIViewController *visible = navigationController.visibleViewController;
    if ([visible isKindOfClass:[ProfileV2Controller class]] || [visible isKindOfClass:[HuntFeedController class]]){
        //FeedTableBase *theView = (FeedTableBase *)visible;
        //SearchingAnimations *anim = [[[SearchingAnimations alloc] init] autorelease];
        //[anim showFacesAnimation:theView.tableView];
    }
}

- (void) displayLanguageSelection {
    
    UIViewController *visible = navigationController.visibleViewController;
    if ([visible isKindOfClass:[IntroSwipeController class]] || [visible isKindOfClass:[IntroSwipeController class]]){
         [((IntroSwipeController *) visible) showLanguageSelection];
    }
}


- (void) showMissingLanguageView {
    MissingLangController* missing = [[MissingLangController alloc] initWithNibName:@"MissingLangController" bundle:nil];
    [navigationController presentViewController:missing animated:YES completion:nil];

}

- (void) displayMatch:(NSNotification *) data {
    
    [self cancelHunting];
    //kill people search
    UIViewController *visible = navigationController.visibleViewController;
    if ([visible isKindOfClass:[ProfileV2Controller class]] || [visible isKindOfClass:[HuntFeedController class]]){
        //FeedTableBase *theView = (FeedTableBase *)visible;
        //SearchingAnimations *anim = [[[SearchingAnimations alloc] init] autorelease];
        //[anim removeallhelpTitles:theView.tableView];
    }   
    
    
    NSDictionary *allData = [data userInfo];
    self.theMatch = [[[MatchViewController alloc] initWithNibName:@"MatchViewController" bundle:nil] autorelease];
    self.theMatch.allData = allData;
    bool displayedNow = false;
    do {
        if (visible.isViewLoaded && visible.view.window) {
            // viewController is visible
            [visible.navigationController pushViewController:self.theMatch animated:NO];
            displayedNow = true;            
        }
    } while (!displayedNow);   
   
}




- (void)dealloc {
    [segmentsCustom release];
    [segmentControl release];
    [otherUsername release];
	[navigationController release];
	[super dealloc];
}



@end
