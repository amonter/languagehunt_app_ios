//
//  ShareAuthenticateController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 17/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "ShareAuthenticateController.h"
#import "iphoneCrowdAppDelegate.h"
#import "HuntProfileHelper.h"
#import "PeopleHuntRequests.h"
#import "LoadingAnimationView.h"
#import <QuartzCore/QuartzCore.h>


@interface ShareAuthenticateController ()

@end

@implementation ShareAuthenticateController
@synthesize twitterSubview, facebookSubview, authenticate, backgroundCurve, backgroundCurve2;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    UIButton *Button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 41)] autorelease];
    [Button setImage:[UIImage imageNamed:@"backArrow.png"] forState:UIControlStateNormal];
    [Button setImage:[UIImage imageNamed:@"backPressed.png"] forState:UIControlStateHighlighted];
    [Button setImage:[UIImage imageNamed:@"backPressed.png"] forState:UIControlStateSelected];
    [Button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView:Button] autorelease];
    self.navigationItem.leftBarButtonItem = backButton;
    
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
   
    
    if ([authenticate isEqualToString:@"facebook"]) {
         [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"facebook_btn"];
        self.facebookSubview.hidden = false;
        CGRect facebookFrame = self.facebookSubview.frame;
        facebookFrame.origin.y = 30;
        self.facebookSubview.frame = facebookFrame;
    }
    
    if ([authenticate isEqualToString:@"twitter"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"twitter_btn"];
        self.twitterSubview.hidden = false;
        CGRect twitterFrame = self.twitterSubview.frame;
        twitterFrame.origin.y = 30;
        self.twitterSubview.frame = twitterFrame;
    }
}


- (IBAction) doTwitterPop {

    [self addLoadingView];
    [HuntProfileHelper showTwitterPop:self];
}

- (void) setUpTwitter:(id)sender {
    
    UIButton *tButton = (UIButton *)sender;
    NSString *twitterHandle = tButton.titleLabel.text;
    //move this to twitter
    //[twitteradded setImage:[UIImage imageNamed:@"twitter_blue.png"] forState:UIControlStateNormal];
    //[twitterdone setText:@"Twitter"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"twitter_btn"];
    [[NSUserDefaults standardUserDefaults] setObject:twitterHandle forKey:@"twitter_handle"];
    PeopleHuntRequests *peopleReq = [[[PeopleHuntRequests alloc] init] autorelease];
    [peopleReq addTwitterHandle];
    [[self.view viewWithTag:69] removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void) addLoadingView {
    LoadingAnimationView *loadingViewObj = [[[LoadingAnimationView alloc] initWithFrame: CGRectMake(90, 110, 140, 80)] autorelease];
    loadingViewObj.tag = 612;
    [self.view addSubview:loadingViewObj];
    [self.view bringSubviewToFront:loadingViewObj];
}


- (IBAction) doFacebookConnect {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"publishaction_done"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"facebook_btn"];
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushBackController) name:FBSessionStateChangedNotification object:nil];
    [appDelegate openSessionWithAllowLoginUI:YES];
    
}


- (void) backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) pushBackController {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self performSelector:@selector(doPopController) withObject:self afterDelay:1.3];
}


- (void) doPopController {
      [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
    [authenticate release];
    [facebookSubview release];
    [twitterSubview release];
    [backgroundCurve release];
    [backgroundCurve2 release];
    [super dealloc];
}

@end
