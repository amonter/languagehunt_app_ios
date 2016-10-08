//
//  IntroSwipeController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#define IS_IPAD ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound)


#import "IntroSwipeController.h"
#import "PeopleHuntRequests.h"
#import "MainCardController.h"
//#import "Mixpanel.h"
#import "IOSUtility.h"
#import "MatchCardController.h"
#import "iphoneCrowdAppDelegate.h"
#import "MeetingInfoController.h"
#import "MessageConfirmationController.h"
#import "EditProfileController.h"

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;


@interface IntroSwipeController ()

@end

@implementation IntroSwipeController
@synthesize theScrollView, locationSearch, helpWith, interestedIn, facebooProfile, longProfile, allSelectedData;
@synthesize lastContentOffset, preStoredData,  hubLocations, loadingScreen;
@synthesize matchCardArray, textChatContainer, textView, languageMode, helpMode;
@synthesize matchDataArray, theInfo, checkList, mainProfile, profileMode, editController, selectedMatches;
@synthesize theMessage, displayedIndex;


-(id)init {
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}



- (void) addNavigationButton {
    
    //Add feeler buttons
    if ([self.view viewWithTag:2156113] == nil) {
        
        UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(69, 20, 182, 45)];
        backView.tag = 2156113;
        backView.backgroundColor = [UIColor clearColor];
        
        UIImageView *behindMenu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 182, 45)];
        behindMenu.image = [UIImage imageNamed:@"topmenu.png"];
        
        UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        profileBtn.tag = 801928;
        [profileBtn setFrame:CGRectMake(76.5, 8.5, 28, 28)];
        //[profileBtn setFrame:CGRectMake(47, 27.5, 27.5, 28)];
        [profileBtn addTarget:self action:@selector(goProfile) forControlEvents:UIControlEventTouchUpInside];
        [profileBtn setBackgroundImage:[UIImage imageNamed:@"icon_profnav.png"] forState:UIControlStateNormal];
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        messageBtn.tag = 7127121;
        //[messageBtn setFrame:CGRectMake(206.5, 27.5, 27.5, 28)];
        //137, 8.5, 28, 28
        [messageBtn setFrame:CGRectMake(137, 8.5, 28, 28)];
        [messageBtn addTarget:self action:@selector(goMessages) forControlEvents:UIControlEventTouchUpInside];
        [messageBtn setBackgroundImage:[UIImage imageNamed:@"icon_msgenav.png"] forState:UIControlStateNormal];
        
        UIButton *pinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pinBtn.tag = 7127122;
        //16.5, 8.5, 27.5, 28
        [pinBtn setFrame:CGRectMake(16.5, 8.5, 28, 28)];
        [pinBtn addTarget:self action:@selector(goLanguages) forControlEvents:UIControlEventTouchUpInside];
        [pinBtn setBackgroundImage:[UIImage imageNamed:@"icon_pinnav.png"] forState:UIControlStateNormal];
        
        
        [backView addSubview:behindMenu];
        [backView addSubview:messageBtn];
        [backView addSubview:profileBtn];
        [backView addSubview:pinBtn];
        [self.view addSubview:backView];
    }
    
}

- (void) goLanguages {
    
    if (mainProfile != nil) {
        [mainProfile.view removeFromSuperview];
        
        //interestedFrame.origin.x = 607;297.5
        /*CGRect languageModeFrame = languageMode.view.frame;
         languageModeFrame.origin.x = 11;
         languageModeFrame.origin.y = 38;
         languageModeFrame.size.width = 298;
         languageModeFrame.size.height = 530;
         languageMode.view.frame = languageModeFrame;
         [theScrollView addSubview:languageMode.view];*/
        //[self addLanguageMode];
        
    }
    
    [self addLanguageMode:0];
    [theScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

//TODO: check if profile view is set up or not
- (void) goProfile {
    
    //check if profile controller exists first
    
    if (mainProfile == nil && !profileMode) {
        CGRect profileFrame;
        [self setUpProfileController:&profileFrame];
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            profileFrame.size.height = 553;
        }
        self.mainProfile.view.frame = profileFrame;
    }
    
    
    [self.languageMode.view removeFromSuperview];
    
    self.mainProfile.dummyTable.delegate = self;
    [self.interestedIn.view removeFromSuperview];
    
    [theScrollView addSubview:self.mainProfile.view];
    
    [self.mainProfile displayProfileData];
    [theScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    profileMode = false;
    
    /* PeopleHuntRequests *req = [[PeopleHuntRequests alloc] init];
     [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
     
     NSDictionary* theDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"I'm an awesome designer from London, and I'm be going to Chile to live and then in istambul for sure", @"bio", @"Alex Murray", @"name", [NSDictionary dictionaryWithObjectsAndKeys:@"Spanish", [NSNumber numberWithInt:2], nil], @"help",  @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash2/t1.0-1/c36.8.95.95/p111x111/1003267_173795169462814_360186586_n.jpg", @"image_url", [NSDictionary dictionaryWithObjectsAndKeys:@"French", [NSNumber numberWithInt:3], nil], @"interested",[NSDictionary dictionaryWithObjectsAndKeys:@"San Francisco", [NSNumber numberWithInt:13], nil], @"locations", @"Soccer, Java, Running marathons", @"interests",  nil];
     
     self.mainProfile = [[MainProfileController alloc] initWithNibName:@"MainProfileController" bundle:nil];
     CGRect profileFrame = self.mainProfile.view.frame;
     profileFrame.origin.x = -298;
     self.mainProfile.view.frame = profileFrame;
     self.mainProfile.profileData = theDic;
     
     
     [theScrollView setContentOffset:CGPointMake(-298, 0) animated:YES];
     [theScrollView addSubview:self.mainProfile.view];
     //[self.mainProfile displayProfileData];
     
     
     }];
     [req retrieveProfileData];*/
    
    
    
    
}


- (void) goMessages {
    /*PeopleHuntRequests *req = [[PeopleHuntRequests alloc] init];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        
        
        NSArray *profile = [[notification userInfo] objectForKey:@"locations"];
        NSMutableDictionary* theSelectedData = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* theLocations = [[NSMutableDictionary alloc] init];
        for (NSDictionary* theLoc in profile) {
            [theLocations setObject:[theLoc objectForKey:@"location"] forKey:[theLoc objectForKey:@"id"]];
        }
        
        [theSelectedData setObject:theLocations forKey:@"locations"];
        [theSelectedData setObject:[[notification userInfo] objectForKey:@"help"] forKey:@"help"];
        [theSelectedData setObject:[[notification userInfo] objectForKey:@"interested"] forKey:@"interested"];
        MainCardController* mainCard = [[MainCardController alloc] initWithNibName:@"MainCardController" bundle:nil];
        
        //mainCard.selectedLocation = theLocations;
        //mainCard.allSelectedData = theSelectedData;
        mainCard.loadAllLocations = true;
        [self.navigationController pushViewController:mainCard animated:NO];
        
    }];
    [req retrieveProfileData];*/
    MainCardController* mainCard = [[MainCardController alloc] initWithNibName:@"MainCardController" bundle:nil];
    
    //mainCard.selectedLocation = theLocations;
    //mainCard.allSelectedData = theSelectedData;
    mainCard.loadAllLocations = true;
    [self.navigationController pushViewController:mainCard animated:NO];
    
    
    
}


- (void)collectUserData:(NSMutableDictionary *)selectedData {
    
    
    /*NSMutableDictionary* theLocDic = self.locationSearch.selectedDataDic;
    NSArray* newLocData = self.locationSearch.dataNew;
    [self addNewDataDic:theLocDic newData:newLocData];
    [selectedData setObject:theLocDic forKey:@"locations"];*/
    
    NSMutableArray *arrayLocations = [[NSMutableArray alloc] init];
    /*for (id theKey in [theLocDic allKeys]) {
        NSMutableDictionary* transformLoc = [[NSMutableDictionary alloc] init];
        [transformLoc setObject:[NSNumber numberWithInt:[theKey intValue]] forKey:@"id"];
        [transformLoc setObject:[theLocDic objectForKey:theKey] forKey:@"location"];
        [arrayLocations addObject:transformLoc];
    }*/
    
    
    [arrayLocations addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"default_location"]];
    [selectedData setObject:arrayLocations forKey:@"locations"];
    
    NSMutableDictionary* theInterestedDic = self.interestedIn.selectedDataDic;
    NSArray* newInterestedData = self.interestedIn.dataNew;
    [self addNewDataDic:theInterestedDic newData:newInterestedData];
    [selectedData setObject:theInterestedDic forKey:@"interested"];
    
    NSMutableDictionary* theHelpDic = self.helpWith.selectedDataDic;
    NSArray* newHelpData = self.helpWith.dataNew;
    [self addNewDataDic:theHelpDic newData:newHelpData];
    [selectedData setObject:theHelpDic forKey:@"help"];
    NSMutableDictionary* proficiencyDic = [[NSMutableDictionary alloc] initWithDictionary:self.helpWith.proficiencyResults];
    [selectedData setObject:proficiencyDic forKey:@"proficiency"];
    
    NSLog(@"SELECTED DATA %@", selectedData);
    
    NSError *error = NULL;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:selectedData options:NSJSONReadingAllowFragments error:&error];
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *theResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *msgProt = [NSString stringWithFormat:@"88:%i:%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue], theResult];
    
    NSLog(@"JSON TO SEND %@", msgProt);
    [theDelegate.protocol sendMessage:msgProt];
}

- (void)doLocationOperations {
    //[self showProfileCard:nil hasLocation:YES];
    //Check if location exists?
    //if it does then call server
    
    NSLog(@"DEFAULT LOCATION %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"default_location"]);
    NSString* theLocation = [[[NSUserDefaults standardUserDefaults] objectForKey:@"default_location"] objectForKey:@"location"];
    if ([theLocation isEqualToString:@"(null)"]) {
        
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"Please share your location, so we can give you better matches"
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];
        return;
    }   
    
    
    NSMutableDictionary *selectedData = [[NSMutableDictionary alloc] init];
    [self collectUserData:selectedData];
    [theScrollView setContentOffset:CGPointMake(298, 0) animated:YES];
    /*NSString* locality = [[NSUserDefaults standardUserDefaults] objectForKey:@"locality"];
     if (locality){
     [theScrollView setContentOffset:CGPointMake(298, 0) animated:YES];
     
     } else {
     //do the rest
     }*/
}

- (void)setUpProfileController:(CGRect *)mainProfleFrame_p {
    NSDictionary* theDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"I'm an awesome designer from London, and I'm be going to Chile to live and then in istambul for sure", @"bio", @"Alex Murray", @"name", [NSDictionary dictionaryWithObjectsAndKeys:@"Spanish", [NSNumber numberWithInt:2], nil], @"help",  @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash2/t1.0-1/c36.8.95.95/p111x111/1003267_173795169462814_360186586_n.jpg", @"image_url", [NSDictionary dictionaryWithObjectsAndKeys:@"French", [NSNumber numberWithInt:3], nil], @"interested",[NSDictionary dictionaryWithObjectsAndKeys:@"San Francisco", [NSNumber numberWithInt:13], nil], @"locations", @"Soccer, Java, Running marathons", @"interests",  nil];
    
    self.mainProfile = [[MainProfileController alloc] initWithNibName:@"MainProfileController" bundle:nil];
    
    mainProfleFrame_p->origin.x = 11;
    mainProfleFrame_p->origin.y = 22;
    mainProfleFrame_p->size.width = 298;
    mainProfleFrame_p->size.height = 530;
    self.mainProfile.profileData = self.preStoredData;
}

- (void)extracted_method:(NSDictionary *)dataDic {
    if ( [[dataDic objectForKey:@"is_selected"] boolValue]){
        self.checkList = ++checkList;
    } else {
        self.checkList = --checkList;
    }

    int theIndex = [[dataDic objectForKey:@"index"] intValue];
    NSLog(@"A MATCH %@ INDEX %i" , self.matchDataArray, theIndex);
    if (self.matchDataArray != nil) [self.selectedMatches addObject:[self.matchDataArray objectAtIndex:theIndex]];
    
    if (![[dataDic objectForKey:@"pre_select"] boolValue]){
        [self.matchCell selectTableCell:theIndex];
    }
    
    if ([[dataDic objectForKey:@"is_selected"] boolValue]){
        int x_value = 298;
        if (helpMode){
            x_value = x_value - 298;
        }
        
        [theScrollView setContentOffset:CGPointMake(x_value, 0) animated:YES];
        [self addConnectButton];
    }
    
    
    if (self.checkList == 0){
        iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[appDelegate.navigationController.visibleViewController.view viewWithTag:928] removeFromSuperview];
    }
}

- (void)getLocation {
    //search for the location
    NSString* locality = [[NSUserDefaults standardUserDefaults] objectForKey:@"locality"];
    NSString* placeMark = [[NSUserDefaults standardUserDefaults] objectForKey:@"placemark"];
    //NSString* locality = @"New York, NY";   
    
    bool match = false;
    for (NSString* feelerDesc in [self.locationSearch.cachedSearchData allValues]) {
        if ([feelerDesc rangeOfString:locality options:NSCaseInsensitiveSearch].location != NSNotFound){
            match = true;
            NSLog(@"ADDDING %@", self.locationSearch);
            [self.locationSearch.selectedDataTable addTheElement:feelerDesc isNew:NO];
        }
    }
    
    if (!match) [self.locationSearch.dataNew addObject:placeMark];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self init];
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_profiledata"];
    // Do any additional setup after loading the view from its nib.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_matchconnections"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.theScrollView.delegate = self;
    self.theScrollView.clipsToBounds = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.allSelectedData = [[NSMutableDictionary alloc] init];
    self.matchCardArray = [[NSMutableArray alloc] init];
    self.selectedMatches = [NSMutableArray new];
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor = [UIColor colorWithRed:109/255.0 green:105/255.0 blue:96/255.0 alpha:1.0];
    
    
    self.languageMode = [[LanguageModeController alloc] initWithNibName:@"LanguageModeController" bundle:nil];
    self.languageMode.view.tag = 987263;
    self.languageMode.delegate = self;
    self.helpWith = [[HelpWithController alloc] initWithNibName:@"HelpWithController" bundle:nil];
    self.helpWith.hideDone = true;
    self.signUpController = [[SignupIntroController alloc] initWithNibName:@"SignupIntroController" bundle:nil];
    self.interestedIn = [[InterestedInController alloc] initWithNibName:@"InterestedInController" bundle:nil];
    self.longProfile = [[LongProfileController alloc] initWithNibName:@"LongProfileController" bundle:nil];
    self.locationSearch = [[LocationSearchController alloc] initWithNibName:@"LocationSearchController" bundle:nil];
    self.locationSearch.view.hidden = true;
    self.matchCell = [[FastConnectionsController alloc] initWithNibName:@"FastConnectionsController" bundle:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"do_commit" object:self.longProfile queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        
        //Mixpanel *mixpanel = [Mixpanel sharedInstance];
        //[mixpanel track:[NSString stringWithFormat:@"Start browsing"]];
        NSDictionary* theLocDic = [self.allSelectedData objectForKey:@"locations"];
        NSDictionary* theHelpDic = [self.allSelectedData objectForKey:@"help"];
        NSDictionary* theInterestLoc = [self.allSelectedData objectForKey:@"interested"];
        NSMutableString* message = [[NSMutableString alloc] init];
        if ([theLocDic count] == 0) [message appendString:@"location"];
        if ([theHelpDic count] == 0) {
            [message appendString:@", something you can help with!"];
        }
        if ([theInterestLoc count] == 0) {
            [message appendString:@", something you want to make!"];
        }
        
        if (([theHelpDic count] == 0 && [theInterestLoc count] == 0) || [theLocDic count] == 0){
            //Mixpanel *mixpanel = [Mixpanel sharedInstance];
            //[mixpanel track:[NSString stringWithFormat:@"Error not enough selected values to continue"]];
            UIAlertView* theAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"You need to select the following:\n%@", message] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [theAlert show];
            return;
        }
        
        MainCardController* mainCard = [[MainCardController alloc] initWithNibName:@"MainCardController" bundle:nil];
        mainCard.selectedLocation = [theLocDic mutableCopy];
        mainCard.loadAllLocations = false;
        mainCard.allSelectedData = self.allSelectedData;
        mainCard.theLocations = [self.locationSearch.cachedSearchData mutableCopy];
        [self.navigationController pushViewController:mainCard animated:NO];     
        
    }];
    
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(11, 10, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *welcome;
    UIImageView *text1;
    UIImageView *text2;
    UIImageView *middleCard;
    UIImageView *bottomCard;
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(11, 38, 297.5, 472)];
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(11, 510, 297.5, 28)];
        welcome = [[UIImageView alloc] initWithFrame:CGRectMake(24.5, 0, 248.5, 44)];
        text1 = [[UIImageView alloc] initWithFrame:CGRectMake(47, 70, 203.5, 284.5)];
        text2 = [[UIImageView alloc] initWithFrame:CGRectMake(27, 417, 243, 52)];
        
    } else {
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(11, 38, 297.5, 384)];
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(11, 422, 297.5, 28)];
        welcome = [[UIImageView alloc] initWithFrame:CGRectMake(24.5, 0, 248.5, 44)];
        text1 = [[UIImageView alloc] initWithFrame:CGRectMake(47, 43, 203.5, 284.5)];
        text2 = [[UIImageView alloc] initWithFrame:CGRectMake(27, 329, 243, 52)];
        
    }
    
    welcome.image = [UIImage imageNamed:@"welcome.png"];
    text1.image = [UIImage imageNamed:@"text1.png"];
    text2.image = [UIImage imageNamed:@"text2.png"];
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    bottomCard.image = [UIImage imageNamed:@"cardback_bottom.png"];
    
    
    
    CGRect languageModeFrame = self.languageMode.view.frame;
    CGRect mainProfleFrame = self.mainProfile.view.frame;
    if (profileMode) {
        [self setUpProfileController:&mainProfleFrame];
    } else {
        
        languageModeFrame.origin.x = 11;
        languageModeFrame.origin.y = 25;
        if (IS_IPAD) languageModeFrame.origin.y = 42;
        languageModeFrame.size.width = 298;
        languageModeFrame.size.height = 530;
    }
    
    
    CGRect interestedFrame = self.interestedIn.view.frame;
    //interestedFrame.origin.x = 607;297.5
    interestedFrame.origin.x = 11;
    interestedFrame.origin.y = 0;
    interestedFrame.size.width = 298;
    interestedFrame.size.height = 530;
    
    
    CGRect helpFrame = self.helpWith.view.frame;
    //helpFrame.origin.x = 1203;905
    helpFrame.origin.x = 11;
    helpFrame.origin.y = 607;
    helpFrame.size.width = 298;
    helpFrame.size.height = 530;
    
    
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        helpFrame.size.height = 553;
        interestedFrame.size.height = 553;
        languageModeFrame.size.height = 553;
        mainProfleFrame.size.height = 553;
        //signInFrame.size.height = 553;
    }
    
    
    self.interestedIn.view.frame = interestedFrame;
    self.helpWith.view.frame = helpFrame;
    self.languageMode.view.frame = languageModeFrame;
    self.mainProfile.view.frame = mainProfleFrame;
    //self.signUpController.view.frame = signInFrame;
    
    self.hubLocations.delegate = self;
    
    self.languageMode.mode = 0;
    if (profileMode) {
        NSLog(@"DUMMYYYYY %@", self.mainProfile.dummyTable);
        self.mainProfile.delegate = self;
        [theScrollView addSubview:self.mainProfile.view];
        [self.mainProfile displayProfileData];
        [theScrollView setContentSize:CGSizeMake(298, 400)];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"navigation_btn"];
        
    } else  {        
        if (self.startMode){
            [theScrollView addSubview:self.languageMode.view];
            [theScrollView setContentSize:CGSizeMake(596, 400)];
        } else {
            [self showLanguageSelection];
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"navigation_btn"]){
        [self addNavigationButton];
    }
    
    //[theScrollView addSubview:self.interestedIn.view];
    //self.interestedIn.view.hidden = true;
    
    
    //for 6 1788 /for 4 1192/ for 2 596
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"first_load" object:self.interestedIn queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        if ([preStoredData count] > 0){
            NSMutableArray *selectedData = [[[self.preStoredData objectForKey:@"interested"] allValues] mutableCopy];
            self.interestedIn.selectedData = selectedData;
            [self.interestedIn doRestData];
            //[self.interestedIn resizeLayout:[self.interestedIn.selectedData count]];
            [self.interestedIn.selectedDataDic addEntriesFromDictionary:[self.preStoredData objectForKey:@"interested"]];
        }
        //ask for the user location now
        iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"placemark_ready" object:theDelegate queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
            
            /*[[NSNotificationCenter defaultCenter] addObserverForName:@"second_load" object:self.locationSearch queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
                if ([preStoredData count] > 0){
                    NSMutableArray *selectedData = [[[self.preStoredData objectForKey:@"locations"] allValues] mutableCopy];
                    self.locationSearch.selectedData = selectedData;
                    //[self.locationSearch doRestData];
                    //[self.locationSearch resizeLayout:[self.locationSearch.selectedData count]];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"display_profile"];
                    [self.locationSearch.selectedDataDic addEntriesFromDictionary:[self.preStoredData objectForKey:@"locations"]];
                }
                
                [self getLocation];
            }];
            
            [self.locationSearch retrieveLocationData];*/
            
        }];
        
        //location_denied
        [[NSNotificationCenter defaultCenter] addObserverForName:@"location_denied" object:theDelegate queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
            
             [[NSNotificationCenter defaultCenter] addObserverForName:@"second_load" object:self.locationSearch queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
                  [self getLocation];
             }];
                
             //[self.locationSearch retrieveLocationData];
         
         }];
        
        NSLog(@"COMING HERE GEO LOC");
        [theDelegate startGeolocation];
    }];
    
    [self.interestedIn loadInterestedInData];
    
    
    //----Might not be used anymore------///
    //tap match load
    [[NSNotificationCenter defaultCenter] addObserverForName:@"tap_done" object:self.interestedIn queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [self doLocationOperations];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"tap_done" object:self.helpWith queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [self doLocationOperations];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"selection_done" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        NSDictionary* dataDic = [data userInfo];
        [self extracted_method:dataDic];
    }];
    
}




- (void) liveMessage {
    
    UIImageView* newMessage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newmessage.png"]];
    newMessage.frame = CGRectMake(160, 8, 12, 12);
    [[self.view viewWithTag:2156113] addSubview:newMessage];
}




// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)prepareChatView:(CGRect) theFrame heightText:(int) theHeight {
    
    [self.textChatContainer removeFromSuperview];
    self.textChatContainer = nil;
    textChatContainer = [[UIView alloc] initWithFrame:theFrame];
    textChatContainer.backgroundColor = [UIColor redColor];
    textChatContainer.tag = 4566111;
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, theHeight)];
    //textView.text = @"Hello there is is mt actuall mommmy data for noe and I will love some input for now";
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 10;
    // you can also set the maximum height in points with maxHeight
    textView.returnKeyType = UIReturnKeyGo; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController.visibleViewController.view addSubview:textChatContainer];
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, textChatContainer.frame.size.width, textChatContainer.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [textChatContainer addSubview:imageView];
    [textChatContainer addSubview:textView];
    [textChatContainer addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(textChatContainer.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitle:@"Send" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(sendChatMessage) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    [textChatContainer addSubview:doneBtn];
    textChatContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    CGRect moveFrame = CGRectMake(0, theFrame.origin.y - 40, 320, 40);
    [self chatAnimation:moveFrame];
    
    
}



- (void)createEditController {
    
    //call methods for display and stuff
    self.editController = [[EditProfileController alloc] initWithNibName:@"EditProfileController" bundle:nil];
    self.editController.profileData = self.preStoredData;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"changes_done" object:self.editController queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [theScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        NSLog(@"INTERESTS %@", editController.interestView.text);
        [self.mainProfile.profileData setValue:editController.aboutView.text forKey:@"bio"];
        [self.mainProfile.profileData setValue:editController.interestView.text forKey:@"interests"];
        [self.mainProfile redisplayDummyTable];
        [self.mainProfile.dummyTable.theTable reloadData];
        [self.editController.view removeFromSuperview];
        
        NSDictionary* elements = [NSDictionary dictionaryWithObjectsAndKeys:editController.aboutView.text, @"bio", editController.interestView.text, @"interests",  nil];
        PeopleHuntRequests* req = [[PeopleHuntRequests alloc] init];
        [req updateProfileInfo:elements];
        
    }];
    
    
    CGRect editFrame = self.editController.view.frame;
    editFrame.origin.x = 309;
    editFrame.origin.y = 22;
    self.editController.view.frame = editFrame;
    
    [theScrollView addSubview:self.editController.view];
    [theScrollView setContentSize:CGSizeMake(596, 400)];
    [theScrollView setContentOffset:CGPointMake(298, 0) animated:YES];
}

- (void) goSelected:(int)element {
    
    [self.interestedIn.view removeFromSuperview];
    [self.helpWith.view removeFromSuperview];
    CGRect interestedFrame = self.interestedIn.view.frame;
    CGRect helpFrame = self.helpWith.view.frame;
    
    
    switch (element) {
        case 0:
            [self createEditController];
            break;
        case 1:
            //call methods for display and stuff
            if (self.editController != nil) [self.editController.view removeFromSuperview];
            interestedFrame.origin.x = 309;
            self.interestedIn.view.frame = interestedFrame;
            [theScrollView addSubview:self.interestedIn.view];
            [theScrollView setContentSize:CGSizeMake(596, 400)];
            [theScrollView setContentOffset:CGPointMake(298, 0) animated:YES];
            break;
        case 2:
            //call methods for display and stuff
            helpFrame.origin.x = 309;
            self.helpWith.view.frame = helpFrame;
            if (self.editController != nil) [self.editController.view removeFromSuperview];
            [self helpSelected:596 scrollValue:298];
            //[theScrollView addSubview:self.helpWith.view];
            //[theScrollView setContentSize:CGSizeMake(596, 400)];
            //[theScrollView setContentOffset:CGPointMake(298, 0) animated:YES];
            break;
        case 3:
            //call methods for display and stuff
            [self createEditController];
            break;
            
    }
    NSLog(@"EDIT CLICKKKEEDDDDDD El %i", element);
}


- (void) addLanguageMode:(int) mode {
    
    //self.languageMode = nil;
    if (self.interestedIn == nil){
        self.interestedIn = [[InterestedInController alloc] initWithNibName:@"InterestedInControllern" bundle:nil];
        
        
    }
    
    CGRect languageModeFrame = interestedIn.view.frame;
    languageModeFrame.origin.x = 11;
    languageModeFrame.origin.y = 17;
    //self.interestedIn.view.frame = languageModeFrame;
    
   [self.theScrollView addSubview:self.interestedIn.view];
    
}




- (void) sendChatMessage {
    
    NSMutableArray* selectedIds = [NSMutableArray new];
    for (NSDictionary* selectedElement in self.selectedMatches) {
        [selectedIds addObject:[NSNumber numberWithInt:[[selectedElement objectForKey:@"profile_id"] intValue]]];
    }
    
    
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *myChatResponse = nil;
    if ([theDelegate.protocol checkStreamStatus]) {
        
        NSMutableArray *filteredArray = [[[[NSOrderedSet alloc] initWithArray:selectedIds] array] mutableCopy];
        NSString *msgProt = [NSString stringWithFormat:@"40:%@:%@:%i", [filteredArray componentsJoinedByString:@","], self.textView.text, 1];
        [theDelegate.protocol sendMessage:msgProt];
        
        /*NSString *fullName = @"Adrian";
         long long milliseconds = [[NSDate date] timeIntervalSince1970] * 1000;
         myChatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:fullName, @"name", theChatMessage, @"encodedContent", @"mine", @"reference", [NSNumber numberWithLongLong:milliseconds], @"dateSent", nil] autorelease];*/
        
    } else {
        
    }
    [self removeElements:theDelegate];
    
    //[self addLanguageMode:2];
    UIView* aView = [[UIView alloc] init];
    aView.tag = 333;
    aView.frame = self.view.frame;
    aView.backgroundColor = [UIColor blackColor];
    aView.alpha = 0.8;
    [self.view addSubview:aView];
    
    self.theMessage = [[MessageConfirmationController alloc] initWithNibName:@"MessageConfirmationController" bundle:nil];
    self.theMessage.checkList = self.checkList;
    self.theMessage.view.tag = 1233442;
    self.theMessage.helpMode = self.helpMode;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"connection_info" object:self.theMessage queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [[self.view viewWithTag:1233442]removeFromSuperview];
        [[self.view viewWithTag:333]removeFromSuperview];
        [self helpSelected:298 scrollValue:0];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"go_inbox" object:self.theMessage queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [[self.view viewWithTag:1233442]removeFromSuperview];
        [[self.view viewWithTag:333]removeFromSuperview];
        [self goInbox];
    }];
    
    [self.view addSubview:self.theMessage.view];
    
    [textChatContainer removeFromSuperview];
    textChatContainer = nil;
    NSString* textMessage = textView.text;
    textView = nil;
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"navigation_btn"];
    
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = textChatContainer.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    textChatContainer.frame = r;
}


- (void)chatAnimation:(CGRect)moveFrame {
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         NSLog(@"MOVE FRAME %f", moveFrame.origin.y);
                         textChatContainer.frame = moveFrame;
                     }
                     completion:^(BOOL finished) {}];
}



- (void) showCards:(NSDictionary*) theData {
    
    self.matchCell = [[FastConnectionsController alloc] initWithNibName:@"FastConnectionsController" bundle:nil];
    
    
    CGRect matchCellFrame = self.matchCell.view.frame;
    self.matchCell.view.tag = 192910;
    matchCellFrame.origin.x = 309;
    matchCellFrame.origin.y = 20;
    matchCellFrame.size.width = 298;
    matchCellFrame.size.height = 530;
    
    if (profileMode){
        matchCellFrame.origin.x = 905;
    }
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) matchCellFrame.size.height = 553;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"connection_selected" object:self.matchCell queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        
        if ([self.matchCardArray count] > 0){
            [((UIViewController*)[self.matchCardArray objectAtIndex:0]).view removeFromSuperview];
            self.matchCardArray = [NSMutableArray new];
        }
        
        
        NSDictionary* userData = [data userInfo];
        NSLog(@"Main Data %@", userData);
        bool hasLocation = YES;
        //if (![[NSUserDefaults standardUserDefaults] objectForKey:@"locality"]) hasLocation = NO;
        [self showProfileCard:userData hasLocation:hasLocation index:[[userData objectForKey:@"row"] intValue]];
        
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"keyboard_down" object:self.matchCell queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [textView resignFirstResponder];
        
    }];
    
    
    self.matchCell.helpMode = self.helpMode;
    
    //check values depending on location and what help mode
    int x_value = 596;
    int content_offset = 298;
    if (profileMode) {
        x_value = 894;
        content_offset = 596;
    }
    
    NSString* language = [self.interestedIn.selectedDataTable.theSelectedData objectAtIndex:0];
    self.matchCell.headerConnect = language;
    /*if (helpMode) {
     matchCellFrame.origin.x =  matchCellFrame.origin.x - 298;
     x_value = x_value - 298;
     content_offset = content_offset - 298;
     }*/
    
    //if (!helpMode) self.matchCell.headerConnect = @"People who can help you";
    
    self.matchCell.view.frame = matchCellFrame;
    [theScrollView setContentSize:CGSizeMake(x_value, 400)];
    [theScrollView setContentOffset:CGPointMake(content_offset, 0) animated:YES];
    [[theScrollView viewWithTag:192910] removeFromSuperview];
    [theScrollView addSubview:self.matchCell.view];
    self.matchDataArray = [[theData objectForKey:@"newOnes"] copy];
    
    self.matchCell.connectionData = [theData objectForKey:@"newOnes"];
    [self.matchCell.theTable reloadData];
    
    
    if (self.theInfo == nil) self.theInfo = [[MeetingInfoController alloc] initWithNibName:@"MeetingInfoController" bundle:nil];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"guide_tips"]){
        [self.view addSubview:self.theInfo.view];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"guide_tips"];
    }
    
    /*[UIView animateWithDuration:0.3 animations:^{
     self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
     refreshLabel.text = @"Loading...";
     refreshArrow.hidden = YES;
     [refreshSpinner startAnimating];
     }];*/
    /*for (NSDictionary* match in matches) {
     [self showProfileCard:match hasLocation:YES index:index];
     index++;
     }*/
}


- (void)showProfileCard:(NSDictionary *)theData hasLocation:(BOOL) location index:(int) theIndex {
    
    int var_x = 596;
    int scroll_x = 894;
    if (helpMode){
        var_x = var_x - 298;
        scroll_x = scroll_x - 298;
    }
    /*if (!location) {
     var_x = 1192;
     scroll_x = 1490;
     }*/
    self.displayedIndex = theIndex;
    
    MatchCardController *soloMessage = [[MatchCardController alloc] initWithNibName:@"MatchCardController" bundle:nil];
    soloMessage.matchCriteria = [theData objectForKey:@"match_criteria"];
    soloMessage.helpMode = self.helpMode;
    soloMessage.view.tag = theIndex;
    
    soloMessage.language = [self.interestedIn.selectedDataTable.theSelectedData objectAtIndex:0];
    soloMessage.proficiency = [theData objectForKey:@"proficiency"];
    soloMessage.theName = [[theData objectForKey:@"profile_data"] objectForKey:@"name"];
    soloMessage.theOtherUrl = [[theData objectForKey:@"profile_data"] objectForKey:@"image_url"];
    soloMessage.interests = [[theData objectForKey:@"profile_data"] objectForKey:@"interests"];
    soloMessage.ratings = [theData objectForKey:@"ratings"];
    
    CGRect soloCellFrame = soloMessage.view.frame;
    
    soloCellFrame.origin.x = self.matchCell.view.frame.origin.x + 298;
    soloCellFrame.origin.y = 20;
    soloCellFrame.size.width = 298;
    soloCellFrame.size.height = 436;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        soloCellFrame.size.height = 553;
    }
    
    soloMessage.view.frame = soloCellFrame;
    [soloMessage createCard:theData];
    [self.matchCardArray addObject:soloMessage];
    
#pragma mark - selection connect
    [theScrollView addSubview:((UIViewController*)[self.matchCardArray objectAtIndex:0]).view];
    //for 6 1788 /for 4 1192/ for 2 596
    [theScrollView setContentSize:CGSizeMake(scroll_x, 400)];
    [theScrollView setContentOffset:CGPointMake(var_x, 0) animated:YES];
    
}

#pragma mark - addConnectButton
- (void) addSelectButton {
    
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![appDelegate.navigationController.visibleViewController.view viewWithTag:3333]) {
        
        UIButton *closeItButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeItButton.tag = 3333;
        [closeItButton setFrame:CGRectMake(26.25, 598, 267.5, 41.5)];
        if (IS_IPAD) [closeItButton setFrame:CGRectMake(26.25, 480, 267.5, 41.5)];
        [closeItButton addTarget:self action:@selector(makeOffer) forControlEvents:UIControlEventTouchUpInside];
        [closeItButton setBackgroundImage:[UIImage imageNamed:@"add_to_list.png"] forState:UIControlStateNormal];
        
        [appDelegate.navigationController.visibleViewController.view addSubview:closeItButton];
        
        [UIView animateWithDuration:.35 animations:^(void) {
            if (IS_IPAD){
                closeItButton.frame = CGRectMake (26.25, 440, 267.5, 41.5);
            } else {
                closeItButton.frame = CGRectMake (26.25, 528, 267.5, 41.5);
            }
        }];
    }
}


#pragma mark - Show Languages
- (void) showLanguageSelection {
    //[theScrollView setContentOffset:CGPointMake(596, 0) animated:YES];
    [self.signUpController.view removeFromSuperview];
    [self.languageMode.view removeFromSuperview];
    [theScrollView setContentSize:CGSizeMake(0, theScrollView.frame.size.height)];
    [theScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [theScrollView addSubview:self.interestedIn.view];
    if (!self.startMode) [self addNavigationButton];
}

- (void) addConnectButton {
    
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate.navigationController.visibleViewController.view viewWithTag:928]){
        UIButton *startBrowsing = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBrowsing setBackgroundImage:[UIImage imageNamed:@"connect_btn.png"] forState:UIControlStateNormal];
        startBrowsing.tag = 928;
        //70 more
        //CGRect posFrameShort = CGRectMake (26.25, 418, 267.5, 41.5);
        //if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) posFrameShort = CGRectMake (26.25, 439, 267.5, 41.5);
        CGRect posFrameShort = CGRectMake (26.25, 439, 267.5, 41.5);
        [startBrowsing setFrame:posFrameShort];
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            //CGRect posFrame = CGRectMake (26.25, 508, 267.5, 41.5);
            //if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) posFrame = CGRectMake (26.25, 598, 267.5, 41.5);
            CGRect posFrame = CGRectMake (26.25, 598, 267.5, 41.5);
            [startBrowsing setFrame:posFrame];
        } else if (IS_IPAD){
            CGRect posFrame = CGRectMake (26.25, 480, 267.5, 41.5);
            [startBrowsing setFrame:posFrame];
        }
        
        
        [startBrowsing addTarget:self action:@selector(sendConnection) forControlEvents:UIControlEventTouchUpInside];
        [appDelegate.navigationController.visibleViewController.view addSubview:startBrowsing];
        
        
        [UIView animateWithDuration:.35 animations:^(void) {
            if (IS_IPAD){
                startBrowsing.frame = CGRectMake (26.25, 440, 267.5, 41.5);
            } else {
                startBrowsing.frame = CGRectMake (26.25, 528, 267.5, 41.5);
            }
        }];
    }
    
}


- (void) makeOffer {
    
    NSDictionary* allData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.displayedIndex], @"index", [NSNumber numberWithBool:YES], @"is_selected",  nil];
    [self extracted_method:allData];
    
}

- (void) sendConnection {
    
    CGSize withinsize = CGSizeMake(240, 1000);
    NSMutableDictionary* interestsDic = [NSMutableDictionary new];
    
    [HuntProfileHelper getProfileInterests:interestsDic];
    NSMutableArray* anArray = [NSMutableArray new];
    [HuntProfileHelper formatInterests:anArray];
    
    NSArray* subArray = anArray;
    if ([anArray count] > 2) subArray = [anArray subarrayWithRange:NSMakeRange(1, 2)];
    
    NSMutableDictionary* theInterestedDic = self.interestedIn.selectedDataDic;
    NSString *language = [theInterestedDic objectForKey:[[theInterestedDic allKeys] objectAtIndex:0]];
    NSString* message = [NSString stringWithFormat:@"Hi, I would like to practice my %@. Are you free today or when are you available this week? I am free at", language];
    //if (helpMode) message = [NSString stringWithFormat:@"Hello, I would like to help you with %@ and I'm also really interested in %@. Let's meet for coffee.", language,[subArray componentsJoinedByString:@" and "]];
    
    
    CGSize providingSize = [IOSUtility checkSizeWithFont:withinsize theFont:[UIFont systemFontOfSize:15.0f] theText:message];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    int y_up;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
            y_up = screenHeight - providingSize.height + 62;
    } else if (IS_IPAD){
        y_up = 470;
    }
    
    
    [self prepareChatView:CGRectMake(0, y_up, 320, 40) heightText:providingSize.height + 35];
    self.textView.text = message;
    CGRect r = textChatContainer.frame;
    r.size.height = providingSize.height + 35;
   	textChatContainer.frame = r;
    
    
}



- (void) justDismiss {
    [[self.view viewWithTag:3172182] removeFromSuperview];
}


#pragma mark - keyboard
//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = textChatContainer.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    textChatContainer.frame = containerFrame;
    //add the rest of the animations
	   
    // commit animations
    [UIView commitAnimations];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"keyboard_down"];
}

-(void) keyboardWillHide:(NSNotification *)note {
    
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = textChatContainer.frame;
    CGFloat theHeight = self.theScrollView.bounds.size.height + 35;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) theHeight = theHeight + 55;
    
    
    containerFrame.origin.y = theHeight - containerFrame.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    textChatContainer.frame = containerFrame;
    
    [textView resignFirstResponder];
    
    // commit animations
    [UIView commitAnimations];
    [textChatContainer removeFromSuperview];
    textChatContainer = nil;
    textView = nil;
}


- (void)addNewDataDic:(NSMutableDictionary *)theDic newData:(NSArray *)newData {
    int count = -1;
    for (NSString* theData in newData){
        [theDic setObject:theData forKey:[NSString stringWithFormat:@"%i",count]];
        count--;
    }
}

//TODO:Add nice remove procedure
- (void)removeElements:(iphoneCrowdAppDelegate *)appDelegate {
    //[textChatContainer removeFromSuperview];
    textChatContainer = nil;
    textView = nil;
    //4566111
    [[appDelegate.navigationController.visibleViewController.view viewWithTag:4566111] removeFromSuperview];
    [[appDelegate.navigationController.visibleViewController.view viewWithTag:928] removeFromSuperview];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    ScrollDirection scrollDirection = ScrollDirectionCrazy;
    if (self.lastContentOffset > scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionLeft;
    
    else if (self.lastContentOffset < scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionRight;
    
    
    self.lastContentOffset = scrollView.contentOffset.x;
    
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    //loading hub locations
    int pageCount = 0;
    //int startConnectionsLeft = 560;
    //int startConnectionsRight = 396;
   
    
    if (scrollDirection == ScrollDirectionLeft){
        NSLog(@"LEFT %i",  self.lastContentOffset);
        
        if (lastContentOffset <= 580 && lastContentOffset > 298){
            if (checkList > 0){
                [self addConnectButton];
            }
        }
        if (profileMode && lastContentOffset > 0 && lastContentOffset <= 276){
            [UIView animateWithDuration:.4 animations:^(void) {
                CGRect theFrame = [self.view viewWithTag:2156113].frame;
                theFrame.origin.y = 20;
                //[self.view viewWithTag:2156113].frame = theFrame;
            }];
        }
        
        if (lastContentOffset > 276 && lastContentOffset <= 531){
            [[appDelegate.navigationController.visibleViewController.view viewWithTag:3333] removeFromSuperview];
        }
        
       
        
        
    }
    
    if (scrollDirection == ScrollDirectionRight){
        if (lastContentOffset <= 298 && lastContentOffset > 38){
            if (checkList > 0){
                [self addConnectButton];
            }
        }
        
        [UIView animateWithDuration:.4 animations:^(void) {
            CGRect theFrame = [self.view viewWithTag:2156113].frame;
            theFrame.origin.y = -50;
            //[self.view viewWithTag:2156113].frame = theFrame;
        }];
        
         NSLog(@"RIGHT %i",  self.lastContentOffset);
        
        if (lastContentOffset > 300){
            [self addSelectButton];
        }
        
        
    }
    
    NSLog(@"PAGE %i", page);
    
    if(page == pageCount ) {
        [self removeElements:appDelegate];
    }
    
    if (page == pageCount + 2) {
        [self removeElements:appDelegate];
    }
    
    [textView resignFirstResponder];
}

#pragma mark - delegate method language selector
- (void) helpSelected:(int) x_value scrollValue:(int) scroll_x {
    self.helpMode = true;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"help_load" object:self.helpWith queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        
        [self.languageMode.view removeFromSuperview];
        //987263
        [[theScrollView viewWithTag:987263] removeFromSuperview];
        [self.interestedIn.view removeFromSuperview];
        [self.locationSearch.view removeFromSuperview];
        iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        [self removeElements:theDelegate];
        [theScrollView addSubview:self.helpWith.view];
        [theScrollView setContentSize:CGSizeMake(x_value, theScrollView.frame.size.height)];
        [theScrollView setContentOffset:CGPointMake(scroll_x, 0) animated:YES];
        self.checkList = 0;
        if (self.matchCell != nil) {
            [self.matchCell.view removeFromSuperview];
            self.matchCell = nil;
        }
        
    }];
    //second_load
    [self.helpWith retrieveHelpData];
}

- (void) goInbox {
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self removeElements:theDelegate];
    [self goMessages];
}

- (void) learnSelected {
    
    self.helpMode = false;
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [theDelegate doPushNotifications];
    
    [theScrollView setContentOffset:CGPointMake(298, 0) animated:YES];
   
    CGRect signInFrame = self.signUpController.view.frame;
    signInFrame.origin.x = 298;
    signInFrame.origin.y = 0;
    //if (IS_IPAD) signInFrame.origin.y = 1;
    signInFrame.size.width = 298;
    signInFrame.size.height = 530;
    
    self.signUpController.view.frame = signInFrame;
    
    [theScrollView addSubview:self.signUpController.view];
   
}


- (void) addLoadingScreen:(bool) isLoading {
    
    if (self.loadingScreen == nil){
        
        self.loadingScreen = [[UIView alloc] initWithFrame:CGRectMake(320, 180, 25.5, 114.5)];
        self.loadingScreen.tag = 234683;
        self.loadingScreen.backgroundColor = [UIColor clearColor];
        UIImageView *calculatingBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25.5, 114.5)];
        calculatingBack.image = [UIImage imageNamed:@"calculating_btn.png"];
        [self.loadingScreen addSubview:calculatingBack];
        
        UIImage* theImage = [UIImage imageNamed:@"calculating_txt.png"];
        CGRect frame = CGRectMake(6, 22, 19, 69);
        if (isLoading) {
            theImage = [UIImage imageNamed:@"Loading.png"];
            frame = CGRectMake(8, 22, 15, 69);
        }
        
        UIImageView *calculatingText = [[UIImageView alloc] initWithFrame:frame];
        calculatingText.image = theImage;
        [self.loadingScreen addSubview:calculatingText];
        
        [self.view addSubview:self.loadingScreen];
        [[NSNotificationCenter defaultCenter] removeObserver:self.hubLocations];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"remove_loadingview" object:self.hubLocations queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
            [UIView animateWithDuration:0.3f
                                  delay:0
                                options:(UIViewAnimationOptionAllowUserInteraction|
                                         UIViewAnimationOptionBeginFromCurrentState)
                             animations:^(void) {
                                 self.loadingScreen.frame = CGRectMake(320, 180, 25.5, 114.5);
                                 [[self.view viewWithTag:234683] removeFromSuperview];
                                 self.loadingScreen = nil;
                             }
                             completion:^(BOOL finished) {}];
        }];
        
    }
    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         self.loadingScreen.frame = CGRectMake(294.5, 180, 25.5, 114.5);
                         
                     }
                     completion:^(BOOL finished) {
                         //[[self.view viewWithTag:234683] removeFromSuperview];
                         //self.loadingScreen = nil;
                     }];
    
}


- (void) populateHubLocations:(NSArray*) locations {
    
    NSMutableArray *locCoord = [NSMutableArray new];
    for (NSDictionary* theLoc in locations) {
        NSArray* theKeys = [theLoc allKeys];
        NSMutableDictionary* dicCoord = [NSMutableDictionary new];
        for (NSDictionary* cachedDic in self.locationSearch.sortedData) {
            if ([[cachedDic objectForKey:@"id"] intValue] == [[theKeys objectAtIndex:0] intValue]){
                [dicCoord addEntriesFromDictionary:cachedDic];
                [dicCoord setObject:[cachedDic objectForKey:@"latitude"] forKey:@"latitude"];
                [dicCoord setObject:[cachedDic objectForKey:@"longitude"] forKey:@"longitude"];
                [locCoord addObject:dicCoord];
                break;
            }
        }
    }
    NSLog(@"RES %@", locCoord);
    
    NSDictionary *storedLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_location"];
    //CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[[storedLocation objectForKey:@"latitude"] doubleValue] longitude:[[storedLocation objectForKey:@"longitude"] doubleValue]];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:-34.603723 longitude:-58.381593];
    NSMutableArray* sortedLocArray = [NSMutableArray new];
    for (int i = 0; i < [locCoord count]; i++) {
        NSDictionary* theLoc = [locCoord objectAtIndex:i];
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[[theLoc objectForKey:@"latitude"] doubleValue] longitude:[[theLoc objectForKey:@"longitude"] doubleValue]];
        CLLocationDistance dist = [currentLocation distanceFromLocation:loc2];
        NSLog(@"RES DIST %f %@", dist, [theLoc objectForKey:@"description"]);
        if (dist <= 20000){
            NSLog(@"ADDED %f %@", dist, [theLoc objectForKey:@"description"]);
            [sortedLocArray addObject:theLoc];
        }
        //[locDist addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:dist], @"dist", [theLoc objectForKey:@"description"], @"description",[theLoc objectForKey:@"id"], @"id", nil]];
    }
    
    NSMutableArray* mutableLocs = [locations mutableCopy];
    for (int a = 0; a < [sortedLocArray count]; a++){
        id theKey = [[sortedLocArray objectAtIndex:a] objectForKey:@"id"];
        for (int b = 0; b < [mutableLocs count]; b++) {
            NSDictionary* theInLoc = [mutableLocs objectAtIndex:b];
            if ([theInLoc objectForKey:[theKey stringValue]]){
                NSLog(@"CHANGED %@", theInLoc);
                [mutableLocs removeObjectAtIndex:b];
                [mutableLocs insertObject:theInLoc atIndex:0];
                break;
            }
        }
    }
    
    [self.hubLocations populateLocatons:mutableLocs];
    
}


- (void) dataSelected:(NSString *)theElement {
    
    
    NSArray* feelerId = [self.locationSearch.cachedSearchData allKeysForObject: [theElement stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSMutableArray* selectedKeys = [[self.locationSearch.selectedDataDic allKeys] mutableCopy];
    if ([self.locationSearch.selectedData count] > 0) {
        for (NSString* selectedElement in self.locationSearch.selectedData) {
            NSArray* feelerId = [self.locationSearch.cachedSearchData allKeysForObject:selectedElement];
            if ([feelerId count] > 0){
                [selectedKeys addObject:[feelerId objectAtIndex:0]];
            }
        }
    }
    
    // NSLog(@"ELEMENT SELECTED %@ feelerId %i", theElement, feelerId);
    if ([selectedKeys containsObject:[feelerId objectAtIndex:0]]){
        UIAlertView* theAlert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Sorry, you have already selected %@!", theElement] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [theAlert show];
        return;
    }
    
    self.locationSearch.selectedDataTable.view.hidden = false;
    [self.locationSearch.selectedDataTable addTheElement:theElement isNew:NO];
    UIAlertView* theAlert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"You have been added to %@ as a Location!", theElement] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [theAlert show];
    
}

- (void) deleteElement:(NSString *)theElement {
    
}


- (void) searchHubLocations {
    
    NSMutableDictionary *selectedData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* theLocDic = self.locationSearch.selectedDataDic;
    NSArray* newLocData = self.locationSearch.dataNew;
    [self addNewDataDic:theLocDic newData:newLocData];
    NSMutableArray *arrayLocations = [[NSMutableArray alloc] init];
    for (id theKey in [theLocDic allKeys]) {
        NSMutableDictionary* transformLoc = [[NSMutableDictionary alloc] init];
        [transformLoc setObject:[NSNumber numberWithInt:[theKey intValue]] forKey:@"id"];
        [transformLoc setObject:[theLocDic objectForKey:theKey] forKey:@"location"];
        [arrayLocations addObject:transformLoc];
    }
    
    [selectedData setObject:arrayLocations forKey:@"locations"];
    
    NSMutableDictionary* theInterestedDic = self.interestedIn.selectedDataDic;
    NSArray* newInterestedData = self.interestedIn.dataNew;
    [self addNewDataDic:theInterestedDic newData:newInterestedData];
    [selectedData setObject:theInterestedDic forKey:@"interested"];
    NSLog(@"ALL SELECTED Data %@",selectedData);
    self.hubLocations.selectedData = selectedData;
    
    NSError *error = NULL;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:selectedData options:NSJSONReadingAllowFragments error:&error];
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *theResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *msgProt = [NSString stringWithFormat:@"55:%i:%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue], theResult];
    
    NSLog(@"JSON TO SEND %@", msgProt);
    [theDelegate.protocol sendMessage:msgProt];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
