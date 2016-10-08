//
//  SignupIntroController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 17/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#define IS_WIDESCREEN ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define IS_IPHONE     ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD       ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )


#import "SignupIntroController.h"
#import "iphoneCrowdAppDelegate.h"
#import "IntroSwipeController.h"
//#import "Mixpanel.h"
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "ModalOfferCardsController.h"

@interface SignupIntroController ()

@end

@implementation SignupIntroController{
    LIALinkedInHttpClient *_client;
    
}


- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://peoplehunt.me"
                                                                                    clientId:@"36798xcst656"
                                                                                clientSecret:@"68KozgDtyQqeTvEl"
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_basicprofile", @"r_emailaddress"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.theScrollView.delegate = self;
    self.theScrollView.clipsToBounds = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = [UIColor clearColor];
    _client = [self client];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //Card One 
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(11, 10, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];  
         
    UIImageView *pphBalloon;
    UIImageView *pphLogo;
    UIImageView *pphSlogan;
    UIImageView *background;
    UIImageView *middleCard;
    UIImageView *bottomCard;
    
    NSLog(@"HEIGHT %f SCALE %f", screenHeight, [UIScreen mainScreen].scale);
    
    if ([UIScreen mainScreen].scale == 2.f && (screenHeight == 568.0f || IS_IPAD)){
        background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 548)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(11, 38, 297.5, 472)];
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(11, 510, 297.5, 28)];
        pphBalloon = [[UIImageView alloc] initWithFrame:CGRectMake(51.25, 15, 205, 204)];
        pphLogo = [[UIImageView alloc] initWithFrame:CGRectMake(32.75, 205, 232, 201.5)];
        pphSlogan = [[UIImageView alloc] initWithFrame:CGRectMake(77.75, 425, 142, 38)];
        
    } else {
        
        background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 460)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(11, 38, 297.5, 384)];
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(11, 422, 297.5, 28)];
        pphBalloon = [[UIImageView alloc] initWithFrame:CGRectMake(51.25, 0, 205, 204)];
        pphLogo = [[UIImageView alloc] initWithFrame:CGRectMake(32.75, 165, 232, 201.5)];
        pphSlogan = [[UIImageView alloc] initWithFrame:CGRectMake(77.75, 340, 142, 38)];
    }
    
    pphLogo.image = [UIImage imageNamed:@"02name.png"];
    pphSlogan.image = [UIImage imageNamed:@"03slogan.png"];
    pphBalloon.image = [UIImage imageNamed:@"01hotairballon.png"];
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    bottomCard.image = [UIImage imageNamed:@"cardback_bottom.png"];
    background.image = [UIImage imageNamed:@"background.png"];
    
     //Card Two    
    UIImageView *topCardPg2 = [[UIImageView alloc] initWithFrame:CGRectMake(309, 10, 297.5, 28)];
    topCardPg2.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *manifesto;
    UIImageView *text1;
    UILabel *text2;
    UIImageView *backgroundPg2;
    UIImageView *middleCardPg2;
    UIImageView *bottomCardPg2;
    
    if ([UIScreen mainScreen].scale == 2.f && (screenHeight == 568.0f || IS_IPAD)){
        backgroundPg2 = [[UIImageView alloc] initWithFrame:CGRectMake(307.5, 0, 297.5, 548)];
        middleCardPg2 = [[UIImageView alloc] initWithFrame:CGRectMake(309, 38, 297.5, 472)];
        bottomCardPg2 = [[UIImageView alloc] initWithFrame:CGRectMake(309, 510, 297.5, 28)];
        manifesto = [[UIImageView alloc] initWithFrame:CGRectMake(20.25, 0, 249, 106)];
        text1 = [[UIImageView alloc] initWithFrame:CGRectMake(74, 150, 149.5, 171)];
        text2 = [[UILabel alloc] initWithFrame:CGRectMake(26, 416, 245.5, 54)];
        
    }else{
        backgroundPg2 = [[UIImageView alloc] initWithFrame:CGRectMake(307.5, 0, 297.5, 460)];
        middleCardPg2 = [[UIImageView alloc] initWithFrame:CGRectMake(309, 38, 297.5, 384)];
        bottomCardPg2 = [[UIImageView alloc] initWithFrame:CGRectMake(309, 422, 297.5, 28)];
        manifesto = [[UIImageView alloc] initWithFrame:CGRectMake(20.25, 0, 249, 106)];
        text1 = [[UIImageView alloc] initWithFrame:CGRectMake(74, 120, 149.5, 171)];
        text2 = [[UILabel alloc] initWithFrame:CGRectMake(26, 328, 245.5, 54)];
        
    }
    
    manifesto.image = [UIImage imageNamed:@"01top.png"];
    text1.image = [UIImage imageNamed:@"02text.png"];
    text2.backgroundColor = [UIColor clearColor];
    text2.lineBreakMode = UILineBreakModeWordWrap;
    text2.textAlignment = NSTextAlignmentCenter;
    text2.numberOfLines = 0;
    text2.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1.0];
    text2.font = [UIFont fontWithName:@"Delicious-Heavy" size:23.0];
    text2.text = @"and make or do something cool";
    
    
    middleCardPg2.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    bottomCardPg2.image = [UIImage imageNamed:@"cardback_bottom.png"];
    backgroundPg2.image = [UIImage imageNamed:@"background.png"];
    
    //Card Three
    UILabel *FBLabel;
    
    UIImageView *topCardPg3 = [[UIImageView alloc] initWithFrame:CGRectMake(11, 10, 297.5, 28)];
    topCardPg3.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *bottomCardPg3;
    UIImageView *middleCardPg3;
    UIImageView *backgroundPg3;
    UIImageView *text1FB;
    
    if ([UIScreen mainScreen].scale == 2.f && (screenHeight == 568.0f || IS_IPAD)){
        text1FB = [[UIImageView alloc] initWithFrame:CGRectMake(26, 416, 245.5, 54.5)];
        backgroundPg3 = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 548)];
        middleCardPg3 = [[UIImageView alloc] initWithFrame:CGRectMake(11, 38, 297.5, 472)];
        bottomCardPg3 = [[UIImageView alloc] initWithFrame:CGRectMake(11, 510, 297.5, 28)];
        FBLabel = [[UILabel alloc] initWithFrame:CGRectMake(22.75,288.5,252,30)];
        
    }else{
        text1FB = [[UIImageView alloc] initWithFrame:CGRectMake(20, 328, 245.5, 54.5)];
        backgroundPg3 = [[UIImageView alloc] initWithFrame:CGRectMake(605.5, 0, 297.5, 460)];
        middleCardPg3 = [[UIImageView alloc] initWithFrame:CGRectMake(607, 38, 297.5, 384)];
        bottomCardPg3 = [[UIImageView alloc] initWithFrame:CGRectMake(607, 422, 297.5, 28)];
        FBLabel = [[UILabel alloc] initWithFrame:CGRectMake(22.75,238.5,252,30)];
    }
    
    FBLabel.backgroundColor = [UIColor clearColor];
    FBLabel.font = [UIFont fontWithName:@"Delicious-Roman" size:12.0];
	FBLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    FBLabel.numberOfLines = 0;
    FBLabel.textAlignment = UITextAlignmentCenter;
    FBLabel.text = @"FACEBOOK HELPS US TO ENSURE THAT PEOPLEHUNT USERS ARE MEETING REAL PEOPLE";
    
    
    middleCardPg3.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    bottomCardPg3.image = [UIImage imageNamed:@"cardback_bottom.png"];
    backgroundPg3.image = [UIImage imageNamed:@"background.png"];
    text1FB.image = [UIImage imageNamed:@"02FBtext.png"];
    
    UIView *signFacebook = [[UIView alloc] initWithFrame:CGRectMake(11, 0, 297.5, 530)];
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *signLinkedin = [UIButton buttonWithType:UIButtonTypeCustom];
    [signLinkedin setBackgroundImage:[UIImage imageNamed:@"login_linkedin.png"] forState:UIControlStateNormal];
    
    if ([UIScreen mainScreen].scale == 2.f && (screenHeight == 568.0f || IS_IPAD)){
        [actionButton setFrame:CGRectMake(22.75, 120, 252, 198.5)];
        [signLinkedin setFrame:CGRectMake(37, 319, 247, 42)];
    }else{
        [actionButton setFrame:CGRectMake(22.75, 70, 252, 198.5)];
       
    }
    //01facebtn.png
    [actionButton setBackgroundImage:[UIImage imageNamed:@"01facebtn.png"] forState:UIControlStateNormal];
    [actionButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [actionButton addTarget:self action:@selector(doFacebookConnect) forControlEvents:UIControlEventTouchUpInside];
    [signLinkedin addTarget:self action:@selector(didTapConnectWithLinkedIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [signFacebook addSubview:actionButton];
    
    //[self.theScrollView addSubview:background];
    //[self.theScrollView addSubview:topCard];
    //[self.theScrollView addSubview:middleCard];
    //[self.theScrollView addSubview:bottomCard];
    
    [middleCard addSubview:pphLogo];
    [middleCard addSubview:pphBalloon];
    [middleCard addSubview:pphSlogan];
    
    
    //[self.theScrollView addSubview:backgroundPg2];
    
    //[self.theScrollView addSubview:topCardPg2];
    //[self.theScrollView addSubview:middleCardPg2];
    //[self.theScrollView addSubview:bottomCardPg2];
    
    [middleCardPg2 addSubview:manifesto];
    [middleCardPg2 addSubview:text1];
    [middleCardPg2 addSubview:text2];
    
    //[self.theScrollView addSubview:backgroundPg3];
    [self.theScrollView addSubview:topCardPg3];
    [self.theScrollView addSubview:middleCardPg3];
    [self.theScrollView addSubview:bottomCardPg3];
    
    [middleCardPg3 addSubview:text1FB];
    //[middleCardPg3 addSubview:FBLabel];
    
    [self.theScrollView addSubview:signFacebook];
    [self.theScrollView addSubview:signLinkedin];
    [self.theScrollView setContentSize:CGSizeMake(298, 400)];
    
    
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"About to sign up!"];
}



- (IBAction)didTapConnectWithLinkedIn:(id)sender {
    [self.client getAuthorizationCode:^(NSString *code) {
        [HuntProfileHelper addLoadingView:self.view];
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
        [[self.view viewWithTag:9876510] removeFromSuperview];
    }                     failure:^(NSError *error) {
        [[self.view viewWithTag:9876510] removeFromSuperview];
        NSLog(@"Authorization failed %@", error);
    }];
}


- (void)requestMeWithToken:(NSString *)accessToken {
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,public-profile-url,skills,languages:(language,proficiency),summary)?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        
        NSLog(@"RES %@", result);
        [[self.view viewWithTag:9876510] removeFromSuperview];
        [[self.navigationController.view viewWithTag:1728393] removeFromSuperview];
                   //Login data
        [HuntProfileHelper setLoginVariables:result type:@"linkedin"];
        [self addTheProfile:@"linkedin"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failed to fetch current user %@", error);
        [HuntProfileHelper doAlertError];
    }];
}




- (void) doFacebookConnect {
    [[self.view viewWithTag:1728393] removeFromSuperview];
    UIActivityIndicatorView *activityIndObj = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    activityIndObj.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 );
    activityIndObj.tag = 9876510;
    [self.view addSubview:activityIndObj];
    [activityIndObj startAnimating];
    
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFacebookQuery) name:FBSessionStateChangedNotification object:nil];
    [appDelegate openSessionReadWithAllowLoginUI:YES];
    //[appDelegate displayLanguageSelection];
    
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"Pressed facebook connect"];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page == 2){
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"do_push"]){
            iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate doPushNotifications];            
            [[NSUserDefaults standardUserDefaults] setObject:@"push" forKey:@"do_push"];
        }
    }
}


- (void)addTheProfile:(NSString*) profileType {
    
    PeopleHuntRequests *req = [[PeopleHuntRequests alloc] init];
    [HuntProfileHelper addLoadingView:self.view];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        [HuntProfileHelper removeLoadingView:self.view];
        
        NSLog(@"LOCA LOCA %@", [[notification userInfo] objectForKey:@"location"]);
        
        int myProfile = [[[notification userInfo] objectForKey:@"profileid"] intValue];
        if (myProfile > 0){
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hunt_activated"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"last_active"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:myProfile] forKey:@"profileid"];
            [[NSUserDefaults standardUserDefaults] setObject:[[notification userInfo] objectForKey:@"location"] forKey:@"default_location"];
            //IntroSwipeController *profile = [[IntroSwipeController alloc] initWithNibName:@"IntroSwipeController" bundle:nil];
            //[self.navigationController pushViewController:profile animated:NO];
            
            iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate initProtocolCommunicationMainThread];
            [appDelegate displayLanguageSelection];
            
            //Mixpanel *mixpanel = [Mixpanel sharedInstance];
            //[mixpanel track:@"Success with addingUser connect"];
            
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_active"];
            [HuntProfileHelper doAlertError];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"error_happened" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        [HuntProfileHelper removeLoadingView:self.view];
        [HuntProfileHelper doAlertError];
    }];                                  
    
    [req addSimpleProfile:profileType];
}


- (void) addInterests {
    
       
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
                              [[self.navigationController.view viewWithTag:1728393] removeFromSuperview];
                              if (error) {
                                  NSLog(@"Error: %@", error);
                                  [HuntProfileHelper doAlertError];
                              } else {
                                  //Login data
                                  NSLog(@"FACEBOOK RESSS %@", result);
                                  [HuntProfileHelper setLoginVariables:result type:@"facebook"];
                                  [self addTheProfile:@"facebook"];
                              }
                          }];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
