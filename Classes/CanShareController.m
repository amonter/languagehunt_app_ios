//
//  CanShareController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 19/02/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#import "CanShareController.h"
#import "AddAnswerAutoContoller.h"
#import "iphoneCrowdAppDelegate.h"
#import "HuntFeedController.h"
#import "PeopleHuntRequests.h"
#import "HuntProfileHelper.h"
#import "ActionProtocol.h"
#import "FacebookActionSharing.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FBRequest.h>
//#import "Mixpanel.h"

@interface CanShareController ()

@end

@implementation CanShareController

@synthesize feelerBtn, sharingView, selectionDone, feelerId, newFeeler, doneButton, helpView, shareLabel, providingIds;
@synthesize dissmissVersion, cancelMode, knowControl;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //check for back button version
    if (cancelMode){
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonTapped)];
        cancelButton.tintColor = [UIColor darkGrayColor];
        [cancelButton setBackgroundVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = cancelButton;    
    
       
    } else {
        UIButton *Button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 41)] autorelease];
         [Button setImage:[UIImage imageNamed:@"backArrow.png"] forState:UIControlStateNormal];
         [Button setImage:[UIImage imageNamed:@"backPressed.png"] forState:UIControlStateHighlighted];
         [Button setImage:[UIImage imageNamed:@"backPressed.png"] forState:UIControlStateSelected];
         [Button addTarget:self action:@selector(closeBackVersion) forControlEvents:UIControlEventTouchUpInside];
         UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView:Button] autorelease];
        self.navigationItem.leftBarButtonItem = backButton; 
    }
    
    feelerBtn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    feelerBtn.titleLabel.numberOfLines = 0;
    feelerBtn.layer.cornerRadius = 2.0;
    feelerBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
    sharingView.hidden = YES;
    
    [self createSharingView];
    if (selectionDone) {
        [feelerBtn setTitle:selectionDone forState:UIControlStateNormal];
        [self setFeeler];
    } else {
        [self startWiggle];
    }
}



- (void)createSharingView {
    
    //Twitter Button
    UIButton *twitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    twitterBtn.tag = 333;
    [twitterBtn setFrame:CGRectMake(232, 0, 59, 42)];
    [twitterBtn addTarget:self action:@selector(pushSharingAuthenticationScreen:) forControlEvents:UIControlEventTouchUpInside];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twitterOn.png"] forState:UIControlStateSelected];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twitterOff.png"] forState:UIControlStateNormal];
    twitterBtn.selected = false;
    //Fist check if its on or off
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_btn"] boolValue]) twitterBtn.selected = true;
    
    [sharingView addSubview:twitterBtn];   
   
}

- (void)setFeeler {
    // Do any additional setup after loading the view from its nib.
    helpView.hidden = YES;
    NSString *copy = feelerBtn.titleLabel.text;
    CGSize withinsize = CGSizeMake(276, 2000);
    CGSize stringsize = [copy sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap];
    
    [feelerBtn setFrame:CGRectMake(10,70,stringsize.width+12, stringsize.height+4)];
    feelerBtn.backgroundColor = [UIColor whiteColor];
    [feelerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    if (!newFeeler && [providingIds containsObject:[NSNumber numberWithInt:self.feelerId]]) {
        self.sharingView.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:@"Oops, you are already sharing %@. Please select another topic.", self.selectionDone]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        return;
    }
    
    CGRect sharingViewFrame = sharingView.frame;
    sharingViewFrame.origin.y = 270;
    if (selectionDone){
        self.sharingView.hidden = NO;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.0f && screenHeight == 568.0f) {
            sharingViewFrame.origin.y = 370;
            
        }
    }
    
    sharingView.frame = sharingViewFrame;
}


- (void) addTheNewFeeler {
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *controllers = appDelegate.navigationController.viewControllers;
    NSLog(@"SEGMENT %i", knowControl.selectedSegmentIndex);
    for (UIViewController *controller in controllers) {
        if ([controller isKindOfClass:[HuntFeedController class]]){
            ((HuntFeedController *)controller).feelerData = selectionDone;
            ((HuntFeedController *)controller).searchBar.text = @"";
            [((HuntFeedController *)controller).searchBar resignFirstResponder];
            [((HuntFeedController *)controller) resetTable];
            [((HuntFeedController *)controller) shareFriendsPop:FALSE];
            //help me here
            [((HuntFeedController *)controller) insertTheFeeler:TRUE];
            break;
        }
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}


- (void) addExistingFeeler {

    PeopleHuntRequests *request = [[[PeopleHuntRequests alloc] init] autorelease];
    [HuntProfileHelper addLoadingView:self.view];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:request queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [HuntProfileHelper removeLoadingView:self.view];
        iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSArray *controllers = appDelegate.navigationController.viewControllers;
        for (UIViewController *controller in controllers) {
            if ([controller isKindOfClass:[HuntFeedController class]]){
                ((HuntFeedController *)controller).feelerData = selectionDone;
                ((HuntFeedController *)controller).showExitingFeelerAdded = true;
                [((HuntFeedController *)controller) shareFriendsPop:FALSE];
                [((HuntFeedController *)controller) updateData];
                break;
            }
        }
        if (dissmissVersion) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }     
    }];
    [request addFeelerState:feelerId statusType:@"looking"];
    
}




#pragma pushSharing
- (void) pushSharingAuthenticationScreen:(id)sender {
    
    NSString *defaultShare = @"twitter";
    int theTag = ((UIButton *)sender).tag;
    if (theTag == 777) defaultShare = @"facebook";
    //Check if selected
    bool selection = ((UIButton *)sender).selected;
    
    helpView.hidden = YES;
    
    if (((UIButton *)sender).selected) ((UIButton *)sender).selected = NO;
    else ((UIButton *)sender).selected = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@_btn" ,defaultShare]];
    if (!selection){//post
        
        bool continueAction = false;
        NSString *publishedAction = [[NSUserDefaults standardUserDefaults] objectForKey:@"publishaction_done"];
        NSLog(@"%@", publishedAction);
        if (theTag == 333 && ![[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_handle"]) {
            continueAction = true;
            //then check if the authenticatin has been made
        } else if (theTag == 777 && !publishedAction) { // no it hasn't
            continueAction = true;
        }
        
        if (continueAction) {
            //If yes stay if not pushController
            [self.navigationController.view viewWithTag:888].hidden = true;
            ShareAuthenticateController *theAuthentication = [[[ShareAuthenticateController alloc] initWithNibName:@"ShareAuthenticateController" bundle:nil] autorelease];
            theAuthentication.authenticate = defaultShare;
            [self.navigationController pushViewController:theAuthentication animated:YES];
        }
        
    } else { // do not post
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%@_btn" ,defaultShare]];
    }
}

- (void) showLoginFacebook {
    
    UIControl *addInfoPop = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)] autorelease];
    addInfoPop.backgroundColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:0.5];
    addInfoPop.tag = 162738;
    [self.view addSubview:addInfoPop];
    
    UIView *addInfoImage = [[[UIView alloc] initWithFrame:CGRectMake(20,70, 280,288)] autorelease];
    addInfoImage.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    addInfoImage.layer.cornerRadius = 6.0;
    [addInfoPop addSubview:addInfoImage];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setFrame:CGRectMake(148, 230, 116, 41)];
    [actionButton addTarget:self action:@selector(doFacebookConnect) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 25.0f, 0.0f, 0.0f)];
    [actionButton setTitle:@"Log in" forState:UIControlStateNormal];
    [actionButton setBackgroundImage:[UIImage imageNamed:@"facebookBtn.png"] forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19];
    [addInfoImage addSubview:actionButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(16, 230, 116, 41)];
    [cancelButton addTarget:self action:@selector(showLoginRemove) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Not now" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19];
    [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"greyBasic.png"] forState:UIControlStateNormal];
    [addInfoImage addSubview:cancelButton];
    
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15,14,250,210)] autorelease];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.numberOfLines = 0;
	infoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    infoLabel.text = [NSString stringWithFormat:@"Please log in with Facebook to post to the community. \n\nWe use Facebook to make sure our users are real people. And we never post to your wall without your permission."];
    [addInfoImage addSubview:infoLabel];
    [addInfoPop setAlpha:0.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    
    [addInfoPop setAlpha:1.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
}

- (void) showLoginRemove {

       [[self.view viewWithTag:162738] removeFromSuperview];
}



- (void) backButtonTapped {
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) closeBackVersion {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectFeeler {
    if (cancelMode) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)doneAdding {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"]){
        if (newFeeler) {
            [self addTheNewFeeler];
        
        } else {
            [self addExistingFeeler];
        }
    
        //post to twitter
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_btn"] boolValue]) {
            [HuntProfileHelper postToTwitter:[NSString stringWithFormat:@"I'm interested in %@. Connect with me using @peoplehuntme, http://peoplehunt.me", selectionDone]];
            
        }
    } else {
        [self showLoginFacebook];
    }
}

#pragma - mark facebook methods
- (void) doFacebookConnect {
    [[self.view viewWithTag:162738] removeFromSuperview];
    UIActivityIndicatorView *activityIndObj = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    activityIndObj.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 );
    activityIndObj.tag = 9876510;
    [self.view addSubview:activityIndObj];
    [activityIndObj startAnimating];
    
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFacebookQuery) name:FBSessionStateChangedNotification object:nil];
    [appDelegate openSessionReadWithAllowLoginUI:YES];
}

- (void) doFacebookQuery {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [FBRequestConnection startWithGraphPath:FACEBOOK_QUERY
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              [[self.view viewWithTag:9876510] removeFromSuperview];
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                                  [HuntProfileHelper doAlertError];
                              } else {
                                  //Login data
                                  [HuntProfileHelper setLoginVariables:result];    
                                                                  
                                  PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
                                  [HuntProfileHelper addLoadingView:self.view];
                                  [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
                                      [HuntProfileHelper removeLoadingView:self.view];                                   
                                      int myProfile = [[[notification userInfo] objectForKey:@"profileid"] intValue];
                                      if (myProfile > 0){
                                          [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"last_active"];
                                          [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:myProfile] forKey:@"profileid"];
                                          //ACTION HERE
                                          if (newFeeler) {
                                              [self addTheNewFeeler];
                                              
                                          } else {
                                              [self addExistingFeeler];
                                          }
                                          
                                      } else {
                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_active"];
                                          [HuntProfileHelper doAlertError];
                                      }
                                  }];
                                  
                                  [[NSNotificationCenter defaultCenter] addObserverForName:@"error_happened" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
                                      [HuntProfileHelper removeLoadingView:self.view];                                      
                                      [HuntProfileHelper doAlertError];
                                  }];             
                                
                                  
                                  [req addSimpleProfile];
                              }
                          }];   

}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    UIButton *facebookBtn = (UIButton *)[self.view viewWithTag:777];
    UIButton *twitterBtn = (UIButton *)[self.view viewWithTag:333];
    facebookBtn.selected = false;
    twitterBtn.selected = false;
    
    NSLog(@"select %i %i",[[[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_btn"] boolValue],
          [[[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_btn"] boolValue]);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_btn"] boolValue]) facebookBtn.selected = true;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_btn"] boolValue]) twitterBtn.selected = true;
    //[self.sharingView setNeedsDisplay];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"DISSAPEEAR");
}


- (void)dealloc {
    [knowControl release];
    [providingIds release];
    [selectionDone release];
    [doneButton release];
    [sharingView release];
    [feelerBtn release];
    [shareLabel release];
    [helpView release];
    [super dealloc];
}

@end
