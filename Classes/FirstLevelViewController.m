//
//  FirstLevelViewController.m
//  Ousiastikos2
//
//  Created by Adrian Avendano on 27/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//  Path comfigured on /Developer/Headers/facebook-ios-sdk/src 

#import "FirstLevelViewController.h"


#import "CanShareController.h"
#import "AsyncronousView.h"
#import "StringEscapeUtil.h"
#import "SignupIntroController.h"
#import "PresentAnswersTableScroll.h"
#import "DummyViewController.h"
#import "IntroSwipeController.h"
#import "DummyScroll.h"
#import "MainCardController.h"

#import "HuntFeedController.h"
#import "MatchViewController.h"
#import "iphoneCrowdAppDelegate.h"
#import "ProfileV2Controller.h"
#import "DummyIos6.h"
#import "ProfileV2Controller.h"
#import "DummyAnimation.h"
#import "DummyNewTable.h"
#import "PaymentViewController.h"



@implementation UINavigationController(TheNavController)

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	for (UIViewController *viewCtrl in self.viewControllers) {		
		//[viewCtrl viewWillAppear:animated]; 
	}	 
}

- (void)viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
	for (UIViewController *viewCtrl in self.viewControllers) {		
		//[viewCtrl viewWillDisappear:animated];
	}	 
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	for (UIViewController *viewCtrl in self.viewControllers) {		
		[viewCtrl viewDidAppear:animated]; 
	}	 
}

- (void)viewDidDisappear:(BOOL)animated {
	
	[super viewDidDisappear:animated];
	for (UIViewController *viewCtrl in self.viewControllers) {		
		[viewCtrl viewDidDisappear:animated]; 
	}
}

@end

@implementation FirstLevelViewController

@synthesize theButton, splashReplica;


- (void)getMainProfile {
    
    ProfileV2Controller *profile = [[ProfileV2Controller alloc] initWithNibName:@"ProfileV2Controller" bundle:nil];
    [self.navigationController pushViewController:profile animated:NO];
    [profile release];
}



- (void)viewDidLoad {
   
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"add_donebtn"];
    //load_hubLocations
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_hubLocations"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //show_location   
    //UINavigationBar *navBar = [self.navigationController navigationBar];
    //UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    //[navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        splashReplica.image = [UIImage imageNamed:@"Default-568h.png"];
        [splashReplica setFrame:CGRectMake(0, -20, 320, 568)];
        
    } else {
        splashReplica.image = [UIImage imageNamed:@"Default.png"];
        [splashReplica setFrame:CGRectMake(0, -20, 320, 480)];
    }
    
    
    int profileId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue];
    NSString *storedVersion = [[[NSUserDefaults standardUserDefaults] objectForKey: @"version"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *theVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSLog(@"check version %@ stored %@", theVersion, storedVersion);
    if (storedVersion != nil && [theVersion intValue] > [storedVersion intValue]) {
        NSLog(@"VERSION UPDATED version %@ stored %@", theVersion, storedVersion);
        if (profileId > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"profile" forKey:@"new_version"];
            //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_active"];
        }        
    }   
    
   
    
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"new_version"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] forKey:@"version"];
    
    NSString *lastActiveView = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_active"];    
    if (profileId == 0) lastActiveView = nil;     
       
    
    NSLog(@"EMAILL %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"]);
    
    
	//prod code
    if (lastActiveView.length > 0) {
    //if (false) {
        //Check for active view
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"new_version"]){            
            IntroSwipeController *profile = [[IntroSwipeController alloc] initWithNibName:@"IntroSwipeController" bundle:nil];
            [self.navigationController pushViewController:profile animated:NO];
            [profile release];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"new_version"];
            
        } else {
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
            
            /*DummyNewTable* dummyTable = [[DummyNewTable alloc] initWithNibName:@"DummyNewTable" bundle:nil];
            CGRect matchFrame = dummyTable.view.frame;
            CGFloat finHeightDummy = [dummyTable calculateLayout];
            matchFrame.origin.x = 17;
            matchFrame.origin.y = 165;
            matchFrame.size.width = 264;
            matchFrame.size.height = finHeightDummy;
            dummyTable.view.frame = matchFrame;*/
            
            //PaymentViewController* pay = [[PaymentViewController alloc] initWithNibName:@"PaymentViewController" bundle:nil];
            [self.navigationController pushViewController:mainCard animated:NO];
            
        }];
        [req retrieveProfileData];
        }
        
	} else {
		//Production code
        //CanShareController *share = [[[CanShareController alloc] initWithNibName:@"CanShareController" bundle:nil] autorelease];
		//[self.navigationController pushViewController:share animated:YES];
        
        IntroSwipeController *profile = [[IntroSwipeController alloc] initWithNibName:@"IntroSwipeController" bundle:nil];
        profile.startMode = true;
        [self.navigationController pushViewController:profile animated:NO];
		[profile release];

        //SignupIntroController *dummyAnimation = [[SignupIntroController alloc] initWithNibName:@"SignupIntroController" bundle:nil];
        //[self.navigationController pushViewController:dummyAnimation animated:NO];
        //[dummyAnimation release];
        
        //DummyViewController *dum = [[DummyViewController alloc] initWithNibName:@"DummyViewController" bundle:nil];
        //[self.navigationController pushViewController:dum animated:NO];
        //[dum release];
	}     
    
    
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.theButton = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[theButton release];
    [splashReplica release];
    [super dealloc];
}


@end

