//
//  DummyAnimation.m
//  CrowdScannerMindField
//
//  Created by ellie's macbook on 02/12/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "DummyAnimation.h"
#import "iphoneCrowdAppDelegate.h"
#import "HuntProfileHelper.h"
#import "ProfileV2Controller.h"
#import "OpenGroupSelectionController.h"
#import "GroupSelectionController.h"
#import "HuntFeedController.h"
#import <QuartzCore/QuartzCore.h>

@interface DummyAnimation ()


@end

@implementation DummyAnimation
@synthesize boxView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)checkPreloaded:(UIImageView *)boxView1 {
    //Check if its preloaded
    UIView *theImageView = [self.boxView viewWithTag:boxView1.tag];
    if (theImageView == nil) {
        NSLog(@"LOADING IMAGE");
        [self.boxView addSubview:boxView1];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    framePosition = 1;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"screen %f", screenHeight );
    NSLog(@"scale %f", [UIScreen mainScreen].scale );
    if ([UIScreen mainScreen].scale == 2.0f && screenHeight == 568.0f) {
        CGRect frameRect = CGRectMake(0, 00, 1618, 568);
        boxView = [[[UIView alloc] initWithFrame:frameRect] autorelease];
        UIImageView *boxView1 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)] autorelease];
        boxView1.image = [UIImage imageNamed:@"landingPageScreen-568h.png"];
        boxView1.tag = 10;
        [self checkPreloaded:boxView1];
        
        UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(150,175,170,16)] autorelease];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.textAlignment = NSTextAlignmentLeft;
        infoLabel.numberOfLines = 0;
        infoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        infoLabel.text = [NSString stringWithFormat:@"Find and be found"];
        //[boxView1 addSubview:infoLabel];
        
        UILabel *infoLabel2 = [[[UILabel alloc] initWithFrame:CGRectMake(20,175,280,15)] autorelease];
        infoLabel2.backgroundColor = [UIColor clearColor];
        infoLabel2.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        infoLabel2.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel2.textAlignment = NSTextAlignmentLeft;
        infoLabel2.numberOfLines = 0;
        infoLabel2.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        infoLabel2.text = [NSString stringWithFormat:@"share your knowledge with curious people"];
        [boxView1 addSubview:infoLabel2];


       
    } else {
        CGRect frameRect = CGRectMake(0, 0, 1618, 460);
        boxView = [[[UIView alloc] initWithFrame:frameRect] autorelease];
        UIImageView *boxView1 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
        boxView1.tag = 10;
        boxView1.image = [UIImage imageNamed:@"landingPageScreen.png"];
        [self checkPreloaded:boxView1];
        
        UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30,90,260,16)] autorelease];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.numberOfLines = 0;
        infoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        infoLabel.text = [NSString stringWithFormat:@"One-on-One Q&A, in real time"];
        //[boxView1 addSubview:infoLabel];
        
        UILabel *infoLabel2 = [[[UILabel alloc] initWithFrame:CGRectMake(20,90,280,15)] autorelease];
        infoLabel2.backgroundColor = [UIColor clearColor];
        infoLabel2.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        infoLabel2.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel2.textAlignment = NSTextAlignmentCenter;
        infoLabel2.numberOfLines = 0;
        infoLabel2.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        infoLabel2.text = [NSString stringWithFormat:@"share your knowledge with curious people"];
        [boxView1 addSubview:infoLabel2];       

    }
    [self.view addSubview:boxView];
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
	[theDelegate startGeolocation];
    [theDelegate doPushNotifications];    

    
    UIButton *getStarted = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].scale == 2.0f && screenHeight == 568.0f) {
        [getStarted setFrame:CGRectMake(39, 453, 242,55)];
    } else {
        [getStarted setFrame:CGRectMake(39, 365, 242,55)];
    }
    
    getStarted.tag = 1122;
    [getStarted addTarget:self action:@selector(nextView) forControlEvents:UIControlEventTouchUpInside];
    [getStarted setBackgroundImage:[UIImage imageNamed:@"getStarted.png"] forState:UIControlStateNormal];
    [self.view addSubview:getStarted];

    
    UIButton *whyInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].scale == 2.0f && screenHeight == 568.0f) {
        [whyInfoBtn setFrame:CGRectMake(55,508, 100,42)];
    } else {
        [whyInfoBtn setFrame:CGRectMake(55,420, 100,42)];
    }
    whyInfoBtn.tag = 9992;
    [whyInfoBtn addTarget:self action:@selector(whyInfoTap) forControlEvents:UIControlEventTouchUpInside];
    [whyInfoBtn setTitle:@"Why Facebook?" forState:UIControlStateNormal];
    whyInfoBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
    [whyInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    whyInfoBtn.backgroundColor = [UIColor clearColor];
    whyInfoBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    whyInfoBtn.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    //[self.view addSubview:whyInfoBtn];
    
    /*[NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self
                                   selector:@selector(moveRight)
                                   userInfo:nil
                                    repeats:YES];*/
    
    // Do any additional setup after loading the view from its nib.
}

- (void) whyInfoTap{
    [self.view viewWithTag:9992].hidden = true;
    [self.view viewWithTag:1029].hidden = true;
    
    UIView *whyFacebookPop = [[[UIView alloc] initWithFrame:CGRectMake(21, 140, 278, 162)] autorelease];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.0f && screenHeight == 568.0f) {
        [whyFacebookPop setFrame:CGRectMake(21, 228, 278, 162)];
    } else {
        [whyFacebookPop setFrame:CGRectMake(21, 140, 278, 162)];
    }
    
    whyFacebookPop.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"facebookPop.png"]];
    whyFacebookPop.tag = 812987;
    [self.view addSubview:whyFacebookPop];
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(34,11,210,140)] autorelease];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:1];
    infoLabel.lineBreakMode = UILineBreakModeWordWrap;
    infoLabel.textAlignment = UITextAlignmentCenter;
    infoLabel.numberOfLines = 0;
	infoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    infoLabel.text = [NSString stringWithFormat:@"PeopleHunt uses Facebook so the people you connect with are real people. \n\nWe promise we'll never post to your account without your permission."];
    [whyFacebookPop addSubview:infoLabel];
    
    UIButton *closeItButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeItButton setFrame:CGRectMake(0, 0, 42, 42)];
    [closeItButton addTarget:self action:@selector(whyInfoTapRemove) forControlEvents:UIControlEventTouchUpInside];
    [closeItButton setBackgroundImage:[UIImage imageNamed:@"closeCross.png"] forState:UIControlStateNormal];
    [whyFacebookPop addSubview:closeItButton];

    
    [whyFacebookPop setAlpha:0.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    
    [whyFacebookPop setAlpha:1.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];

}

- (void) whyInfoTapRemove{
    [[self.view viewWithTag:812987] removeFromSuperview];
    [self.view viewWithTag:9992].hidden = false;
    [self.view viewWithTag:1029].hidden = false;
}

- (void) nextView {    
    [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"last_active"];   
    HuntFeedController *feedController = [[[HuntFeedController alloc] initWithNibName:@"HuntFeedController" bundle:nil] autorelease];
    [self.navigationController pushViewController:feedController animated:YES];
}


#pragma - mark Facebook methods
- (IBAction) doFacebookConnect {
    
    
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
    [FBRequestConnection startWithGraphPath:@"/me?fields=id,name,email,bio,picture.type(normal).height(90).width(90),friends.fields(name,id,picture.type(normal).height(90).width(90))"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              [[self.view viewWithTag:9876510] removeFromSuperview];
                              if (error) {                                 
                                  NSLog(@"Error: %@", [error localizedDescription]);
                                  [self doAlertError];
                              } else {
                                  //Login data
                                  NSString *theName = [result objectForKey:@"name"];
                                  NSString *theId = [result objectForKey:@"id"];
                                  NSString *theEmail = [result objectForKey:@"email"];
                                  NSString *theBio = [result objectForKey:@"bio"];
                                  NSArray *friendData = [[result objectForKey:@"friends"] objectForKey:@"data"];
                                  [[NSUserDefaults standardUserDefaults] setObject:friendData forKey:@"all_friends"];
                                  
                                  [self setLoginVariables:theName userId:theId email:theEmail bio:theBio];

                                  NSString *imageUrl = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                                  [[NSUserDefaults standardUserDefaults] setObject:imageUrl forKey:@"my_image"];
                                  
                                  AvatarImageView *theImage = [[[AvatarImageView alloc] init] autorelease];
                                  [theImage checkIfImageExists:[NSURL URLWithString:imageUrl] theImageFrame:CGRectMake(0, 0, 90, 90)];
                                  
                                  PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
                                  [HuntProfileHelper addLoadingView:self.view];
                                  [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
                                      [HuntProfileHelper removeLoadingView:self.view];
                                      //[self.tableGroups removeAllObjects];
                                      int myProfile = [[[notification userInfo] objectForKey:@"profileid"] intValue];
                                      if (myProfile > 0){
                                          [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"last_active"];
                                          [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:myProfile] forKey:@"profileid"];
                                          HuntFeedController *feedController = [[[HuntFeedController alloc] initWithNibName:@"HuntFeedController" bundle:nil] autorelease];
                                          [self.navigationController pushViewController:feedController animated:YES];
                                          
                                      } else {
                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_active"];
                                          [self doAlertError];
                                      }
                                  }];
                                  
                                  [[NSNotificationCenter defaultCenter] addObserverForName:@"error_happened" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
                                      [HuntProfileHelper removeLoadingView:self.view];
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_active"];
                                      [self doAlertError];
                                  }];
                                  
                                  NSMutableArray *groupsArray = [[[NSMutableArray alloc] init] autorelease];                                  
                                  NSDictionary *jsonStruc = [[[NSDictionary alloc] initWithObjectsAndKeys:groupsArray, @"groupdata", nil] autorelease];
                                  
                                  NSError *error = NULL;
                                  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonStruc options:NSJSONReadingAllowFragments error:&error];
                                  NSString *theResult = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
                                  
                                  [req addSimpleProfile:theResult];                              
                              }
                          }];
    
}


- (void)doAlertError {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Oops, Something went wrong while creating your account. Please try again!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


- (void)setLoginVariables:(NSString *) theName userId:(NSString*) facebookId email:(NSString *) theEmail bio:(NSString *) theBio {
    
    NSData *tempName = [theName dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *nameConverted = [[[NSString alloc] initWithData:tempName encoding:NSASCIIStringEncoding] autorelease];    
    NSMutableString *theUsername = [NSMutableString stringWithFormat:@"%@", nameConverted];
	[theUsername replaceOccurrencesOfString:@" "  withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, [theUsername length])];
	theUsername = [NSString stringWithFormat:@"%@_%@@meetforeal.com", theUsername, facebookId];
    
	[[NSUserDefaults standardUserDefaults] setObject:nameConverted forKey:@"fullname"];
	[[NSUserDefaults standardUserDefaults] setObject:theUsername forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:theEmail forKey:@"user_email"];
    if(theBio) [[NSUserDefaults standardUserDefaults] setObject:theBio forKey:@"bio"];
}



- (void)transformPosition:(float)floatFactor {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    boxView.transform = CGAffineTransformMakeTranslation(floatFactor, 0);
    [UIView commitAnimations];
}

- (void)startAgain {
    [self.view viewWithTag:812987].hidden = true;
    [self.view viewWithTag:1122].hidden = true;
    [self.view viewWithTag:9992].hidden = true;
    [self.view viewWithTag:1029].hidden = true;
    [self.view viewWithTag:12529].hidden = true;
    [self.view viewWithTag:333].hidden = false;
    [self.view viewWithTag:33399].hidden = false;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    boxView.transform = CGAffineTransformMakeTranslation(0, 0);
    [UIView commitAnimations];    
    framePosition = 1;
}

-(void) moveRight
{
    
    if (framePosition == 1) {
        [self transformPosition:(-323)];
        [self.view viewWithTag:12529].hidden = false;
         CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.0f && screenHeight == 568.0f) {
            UIImageView *boxView2 = [[[UIImageView alloc] initWithFrame:CGRectMake(323, 0, 320, 548)] autorelease];
            boxView2.image = [UIImage imageNamed:@"imageSlide2-568h.png"];
            boxView2.tag = 20;
            [self checkPreloaded:boxView2];

        } else {
            UIImageView *boxView2 = [[[UIImageView alloc] initWithFrame:CGRectMake(323, 0, 320, 460)] autorelease];
            boxView2.image = [UIImage imageNamed:@"imageSlide2.png"];
            boxView2.tag = 20;
            [self checkPreloaded:boxView2];           
        }
    }
    
    if (framePosition == 2) {
        [self transformPosition:(-647)];
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.0f && screenHeight == 568.0f) {
            UIImageView *boxView3 = [[[UIImageView alloc] initWithFrame:CGRectMake(647, 0, 320, 548)] autorelease];
            boxView3.image = [UIImage imageNamed:@"imageSlide3-568h.png"];
            boxView3.tag = 30;
            [self checkPreloaded:boxView3];
         } else {
             UIImageView *boxView3 = [[[UIImageView alloc] initWithFrame:CGRectMake(647, 0, 320, 460)] autorelease];
             boxView3.image = [UIImage imageNamed:@"imageSlide3.png"];
             boxView3.tag = 30;
             [self checkPreloaded:boxView3];
         }
       
    }
    
    if (framePosition == 3) {
        [self showLastPage];
      
    }
    
    framePosition ++;
    //NSLog(@"frame position after move right %i",framePosition);
}

-(void) moveLeft{
   
    if (framePosition == 2) {
        [self startAgain];
    }
    framePosition = framePosition -2;
    if (framePosition == 1) {
        [self.view viewWithTag:12529].hidden = true;
    }
    if (framePosition == -1) {
        [self.view viewWithTag:12529].hidden = true;
        framePosition = 0;
    }
    [self.view viewWithTag:1122].hidden = true;
    [self.view viewWithTag:1029].hidden = true;
    [self.view viewWithTag:9992].hidden = true;
    [self.view viewWithTag:812987].hidden = true;
    [self.view viewWithTag:333].hidden = false;
    [self.view viewWithTag:33399].hidden = false;
   // NSLog(@"frame position after move left %i",framePosition);
    [self moveRight];
}

-(void) skipEnd{
    [self showLastPage];
    [self.view viewWithTag:12529].hidden = true;
    [self.view viewWithTag:1029].hidden = false;
    [self.view viewWithTag:1122].hidden = false;
    [self.view viewWithTag:9992].hidden = false;
    framePosition = 4;
}

-(void) showLastPage{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.0f && screenHeight == 568.0f) {
        UIImageView *boxView4 = [[[UIImageView alloc] initWithFrame:CGRectMake(971, 0, 320, 548)] autorelease];
        boxView4.image = [UIImage imageNamed:@"imageSlide4-568h.png"];
        boxView4.tag = 50;
        [self checkPreloaded:boxView4];

    }else {
            
        UIImageView *boxView4 = [[[UIImageView alloc] initWithFrame:CGRectMake(971, 0, 320, 460)] autorelease];
        boxView4.image = [UIImage imageNamed:@"imageSlide4.png"];
        boxView4.tag = 50;
        [self checkPreloaded:boxView4];
    }

    [self transformPosition:(-971)];
    [self performSelector:@selector(showFBButton) withObject:nil afterDelay:1.2];
    [self.view viewWithTag:12529].hidden = true;
    [self.view viewWithTag:33399].hidden = true;
    [self.view viewWithTag:333].hidden = true;
    framePosition = 3;
    
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
	[theDelegate startGeolocation];
    [theDelegate doPushNotifications];
    
}

- (void) showFBButton{
    [self.view viewWithTag:1029].hidden = false;
    [self.view viewWithTag:1122].hidden = false;
    [self.view viewWithTag:1029].hidden = false;
    [self.view viewWithTag:9992].hidden = false;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [boxView release];
    // Dispose of any resources that can be recreated.
}

@end
