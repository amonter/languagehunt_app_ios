//
//  MainCardController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 26/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "MainCardController.h"
#import "IndividualFeelerController.h"
#import "iphoneCrowdAppDelegate.h"
#import "IntroSwipeController.h"
#import "HuntProfileHelper.h"
//#import "Mixpanel.h"
#import "MatchCardController.h"
#import "PaymentTipControllerController.h"


typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface MainCardController ()

@end

@implementation MainCardController
@synthesize theScroll, theLocations, selectedLocation, mainCard, matchCell, lastContentOffset;
@synthesize soloMessage, textChatContainer, textView, otherProfileId, messageCount, loadingScreen, longProfile, nextScroll;
@synthesize indFeeler, allSelectedData, loadAllLocations, disableMatchScroll, tipController;


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




- (void)showProfileCard:(NSNotification *)data theScroll:(UIScrollView*) aScrollView {
    
    self.loadingScreen = nil;
    [self addLoadingScreen:true];
    
    [[aScrollView viewWithTag:12812831] removeFromSuperview];
    [[aScrollView viewWithTag:48388292] removeFromSuperview];
    [[aScrollView viewWithTag:9173] removeFromSuperview];
    NSDictionary* theData = [data userInfo];
    self.otherProfileId = [[theData objectForKey:@"other_id"] intValue];
    
    soloMessage = [[AsynchMessageController alloc] initWithNibName:@"AsynchMessageController" bundle:nil];
    
    soloMessage.otherProfileId = self.otherProfileId;
    soloMessage.matchCriteria = [theData objectForKey:@"match_criteria"];
    soloMessage.proficiency = [theData objectForKey:@"proficiency"];
    soloMessage.otherUserData = self.allSelectedData;
    longProfile = [[LongProfileController alloc] initWithNibName:@"LongProfileController" bundle:nil];
    
    
    
    
    CGRect soloCellFrame = self.soloMessage.view.frame;
    soloCellFrame.origin.x = 309;
    soloCellFrame.origin.y = 21;
    soloCellFrame.size.width = 298;
    soloCellFrame.size.height = 436;
    
    CGRect longCellFrame = self.longProfile.view.frame;
    longCellFrame.origin.x = 607;
    longCellFrame.origin.y = 21;
    longCellFrame.size.width = 398;
    longCellFrame.size.height = 530;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        soloCellFrame.size.height = 553;
        longCellFrame.size.height = 553;
    }
    
    self.soloMessage.view.frame = soloCellFrame;
    self.soloMessage.view.hidden = true;
    [aScrollView addSubview:self.soloMessage.view];
    self.longProfile.view.frame = longCellFrame;
    self.longProfile.view.hidden = true;
    [aScrollView addSubview:self.longProfile.view];
   
    
    
    [self.longProfile.view viewWithTag:237823].hidden = true;
    //11112
    [self.longProfile.view viewWithTag:11112].hidden = true;
    //notification when info is loaded
    UILabel* nameLabel = (UILabel*)[self.longProfile.view viewWithTag:200];
    CGRect nameFrame = nameLabel.frame;
    nameFrame.origin.y = 8;
    nameFrame.size.height = 40;
    nameLabel.frame = nameFrame;
    nameLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:32.0];
    //888111
    UILabel* photoView = (UILabel*)[self.longProfile.view viewWithTag:888111];
    CGRect photoFrame = photoView.frame;
    photoFrame.origin.y = 78;
    photoView.frame = photoFrame;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"inbox_loaded" object:self.soloMessage queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        
        NSMutableDictionary* theData = [[data userInfo] mutableCopy];
        NSArray *allMessages = [[[theData objectForKey:@"inbox"] reverseObjectEnumerator] allObjects];
        self.messageCount = [allMessages count];
        //[allData removeObjectForKey:@"locations"];
        //NSDictionary* theLocs = [[NSDictionary alloc] initWithDictionary:[allData objectForKey:@"locations"]];
        //[allData setObject:theLocs forKey:@"locations"];
        
        self.soloMessage.view.hidden = false;        
        
        //NSError *error = NULL;
        //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONReadingAllowFragments error:&error];
       // NSString *theResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       
       
        if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"payment_tip%i", [[[theData objectForKey:@"paymentType"] objectForKey:@"payment_type"] intValue]]]){
            
            self.tipController = [[PaymentTipControllerController alloc] initWithNibName:@"PaymentTipControllerController" bundle:nil];
            self.tipController.paymentType = [[[theData objectForKey:@"paymentType"] objectForKey:@"payment_type"] intValue];
            self.tipController.view.alpha = 0.7;
            self.tipController.view.backgroundColor = [UIColor blackColor];
            [self.view addSubview:self.tipController.view];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"payment_tip%i", [[[theData objectForKey:@"paymentType"] objectForKey:@"payment_type"] intValue]]];
        }
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"dissmiss_keyword" object:self.soloMessage queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
            
            NSNotification* theNot = [NSNotification notificationWithName:@"keyboard_hide" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], UIKeyboardAnimationCurveUserInfoKey, nil]];
            [self keyboardWillHide:theNot];
            
        }];
        
         [[NSNotificationCenter defaultCenter] addObserverForName:@"view_card" object:self.soloMessage queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
             
             
             if (![aScrollView viewWithTag:9173]){
             
                  NSLog(@"Profile DATA ---------------}}}}}} %@", theData);
                  
                  MatchCardController *matchCard = [[MatchCardController alloc] initWithNibName:@"MatchCardController" bundle:nil];
                  matchCard.matchCriteria = [theData objectForKey:@"match_criteria"];
                  matchCard.helpMode = false;
                  matchCard.view.tag = 9173;
                  matchCard.theName = [theData objectForKey:@"name"];
                  matchCard.theOtherUrl = [theData objectForKey:@"image_url"];
                  matchCard.interests = [theData objectForKey:@"interests"];
                  matchCard.ratings = [theData objectForKey:@"ratings"];
                  
                  CGRect soloCellFrame = matchCard.view.frame;
                  
                  soloCellFrame.origin.x = 607;
                  soloCellFrame.origin.y = 21;
                  soloCellFrame.size.width = 298;
                  soloCellFrame.size.height = 436;
                  
                  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                  if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
                  soloCellFrame.size.height = 553;
                  }
                  
                  matchCard.view.frame = soloCellFrame;
                     [matchCard createCard:theData];
                  #pragma mark - selection connect
                  [aScrollView addSubview:matchCard.view];
                 
             }
             
              CGSize contentSize = CGSizeMake(894, 400);
              //CGPoint offsettPoint = CGPointMake(298, 0);
              
              CGPoint offsettPoint = CGPointMake(596, 0);
              [aScrollView setContentSize:contentSize];
              [aScrollView setContentOffset:offsettPoint animated:YES];
            
             
         }];    
        
        


        //self.longProfile.profileData = allData;
        //[self.longProfile displayProfileData];
        //self.longProfile.view.hidden = false;

        ///self.soloMessage.view.hidden = false;

        CGSize contentSize = CGSizeMake(596, 400);
        CGPoint offsettPoint = CGPointMake(298, 0);


        [aScrollView setContentSize:contentSize];
        [aScrollView setContentOffset:offsettPoint animated:YES];
        [self removeLoadingView];
        //check the message status as msg seen
        iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.protocol sendMessage:[NSString stringWithFormat:@"89:%i", otherProfileId]];
        //notify that status has change for this user
    }];
}

- (void)reloadMatching {
    [self addLoadingScreen:false];
    PeopleHuntRequests* req = [[PeopleHuntRequests alloc] init];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [self removeLoadingView];
    }];
    [req retrieveProfileData];
}



- (void)addNavigationButton {
    
    //Add feeler buttons
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(69, 20, 182, 45)];
    backView.tag = 2156113;
    backView.backgroundColor = [UIColor clearColor];
    
    UIImageView *behindMenu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 182, 45)];
    behindMenu.image = [UIImage imageNamed:@"topmenu.png"];
    
    UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.tag = 801928;
    [profileBtn setFrame:CGRectMake(76.5, 8.5, 28, 28)];
    //[profileBtn setFrame:CGRectMake(47, 27.5, 27.5, 28)];
    [profileBtn addTarget:self action:@selector(goProfileView) forControlEvents:UIControlEventTouchUpInside];
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

- (void) goLanguages {
    [HuntProfileHelper addLoadingView:self.mainCard.view];
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [theDelegate goIntroSwipe:false];
}

- (void) goMessages {
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:[NSString stringWithFormat:@"Show Messages from menu"]];
    
    
    [theScroll scrollRectToVisible:CGRectMake(298, theScroll.frame.origin.y, theScroll.frame.size.width, theScroll.frame.size.height) animated:YES];
    CGSize contentSize = CGSizeMake(894, 400);
    CGPoint offsettPoint = CGPointMake(0, 0);
    [theScroll setContentSize:contentSize];
    [theScroll setContentOffset:offsettPoint animated:YES];
}
- (void) goProfileView {
    
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:[NSString stringWithFormat:@"Show Intro from menu"]];
    
    [HuntProfileHelper addLoadingView:self.mainCard.view];
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [theDelegate goIntroSwipe:true];
    
    /*PeopleHuntRequests *req = [[PeopleHuntRequests alloc] init];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        
        NSArray *profile = [[notification userInfo] objectForKey:@"locations"];
        NSMutableDictionary* allSelectedData2 = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* theLocations2 = [[NSMutableDictionary alloc] init];
        for (NSDictionary* theLoc in profile) {
            [theLocations2 setObject:[theLoc objectForKey:@"location"] forKey:[theLoc objectForKey:@"id"]];
        }
        
        [allSelectedData2 setObject:theLocations2 forKey:@"locations"];
        [allSelectedData2 setObject:[[notification userInfo] objectForKey:@"help"] forKey:@"help"];
        [allSelectedData2 setObject:[[notification userInfo] objectForKey:@"interested"] forKey:@"interested"];
        IntroSwipeController *introSwipe = [[IntroSwipeController alloc] initWithNibName:@"IntroSwipeController" bundle:nil];
        introSwipe.preStoredData = allSelectedData2;
        introSwipe.showProfile = true;
        [self.navigationController pushViewController:introSwipe animated:NO];
        
    }];
    [req retrieveProfileData];*/
    
}





- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self init];
    
    self.disableMatchScroll = false;
    
    self.view.backgroundColor = [UIColor colorWithRed:109/255.0 green:105/255.0 blue:96/255.0 alpha:1.0];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.theScroll.delegate = self;
    self.theScroll.clipsToBounds = NO;
    
  
    self.mainCard = [[MainFeelersCardController alloc] initWithNibName:@"MainFeelersCardController" bundle:nil];
    
    
    self.matchCell = [[ConnectionsCardController alloc] initWithNibName:@"ConnectionsCardController" bundle:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"connection_selected" object:self.matchCell queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [self showProfileCard:data theScroll:self.theScroll];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"new_feeler" object:self.mainCard queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        
        NSMutableDictionary* helpDic = [[self.allSelectedData objectForKey:@"interested"] mutableCopy];
        [helpDic addEntriesFromDictionary:[data userInfo]];
        [self.allSelectedData setObject:helpDic forKey:@"interested"];
        [self doMatchRequest];
    }];
  
    
    CGRect mainFrame = self.mainCard.view.frame;
    mainFrame.origin.x = 11;
    mainFrame.origin.y = 20;
    mainFrame.size.width = 298;
    mainFrame.size.height = 530;
    
    CGRect matchCellFrame = self.matchCell.view.frame;
    matchCellFrame.origin.x = 11;
    matchCellFrame.origin.y = 22;
    matchCellFrame.size.width = 298;    
    matchCellFrame.size.height = 530;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {       
        mainFrame.size.height = 553;
        matchCellFrame.size.height = 553;
    }
    
    self.mainCard.view.frame = mainFrame;
    //[theScroll addSubview:self.mainCard.view];
    
    self.matchCell.view.frame = matchCellFrame;
    [theScroll addSubview:self.matchCell.view];
    
    [self.matchCell getMessages];
    
    [theScroll setContentSize:CGSizeMake(298, 400)];
    
    [self addNavigationButton];
}


- (void) incomingMessage:(NSArray *) response {
    [self.soloMessage incomingMessage:response];
}

- (void) userLive:(NSDictionary *) user {
    [self.matchCell userLive:user];
}


- (void) populateMessages:(NSArray*) msgs {
    [self.matchCell populateUsers:msgs];
}

- (void) loadMessages:(NSString*) allMessages {
    
}

- (void) profileSelection:(NSNotification*) data {
    [self showProfileCard:data theScroll:self.nextScroll];
}

- (void)addNewDataDic:(NSMutableDictionary *)theDic newData:(NSArray *)newData {
    int count = -1;
    for (NSString* theData in newData){
        [theDic setObject:theData forKey:[NSString stringWithFormat:@"%i",count]];
        count--;
    }
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

- (void)removeLoadingView {
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
}

- (void)doMatchRequest {
    
    [self addLoadingScreen:false];
    NSMutableDictionary *copyAllSelectedData = [self.allSelectedData mutableCopy];
    NSMutableDictionary* theLocationsArray = [[self.allSelectedData objectForKey:@"locations"] mutableCopy];
    //alohas
    
    //NSLog(@"Location array %@", theLocationsArray);
    [copyAllSelectedData removeObjectForKey:@"locations"];
    NSMutableArray *arrayLocations = [[NSMutableArray alloc] init];
    for (id theKey in [theLocationsArray allKeys]) {        
        NSMutableDictionary* transformLoc = [[NSMutableDictionary alloc] init];
        [transformLoc setObject:[NSNumber numberWithInt:[theKey intValue]] forKey:@"id"];
        [transformLoc setObject:[theLocationsArray objectForKey:theKey] forKey:@"location"];
        [arrayLocations addObject:transformLoc];
    }
    
    [copyAllSelectedData setObject:arrayLocations forKey:@"locations"];  
    NSMutableDictionary* theDic = [[NSMutableDictionary alloc] initWithDictionary:copyAllSelectedData];
    //NSLog(@"THE LOC %@", theDic);
  
    NSError *error = NULL;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theDic options:NSJSONReadingAllowFragments error:&error];
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *theResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *msgProt = [NSString stringWithFormat:@"88:%i:%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue], theResult];
    
    NSLog(@"JSON TO SEND %@", msgProt);
    //[theDelegate.protocol sendMessage:msgProt];
}

- (void)doMatchScroll:(UIScrollView *)scrollView {
    scrollView.scrollEnabled = NO;
    scrollView.scrollEnabled = YES;
    self.disableMatchScroll = false;
    [self doMatchRequest];
}


- (void) loadNewMatches:(NSDictionary*) jsonData {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"load_profiledata"]) {
        PeopleHuntRequests *req = [[PeopleHuntRequests alloc] init];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
            NSLog(@"Loading NEW PROFILE");
            NSArray *profile = [[notification userInfo] objectForKey:@"locations"];
            NSMutableDictionary* allSelectedData2 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary* theLocations2 = [[NSMutableDictionary alloc] init];
            for (NSDictionary* theLoc in profile) {
                [theLocations2 setObject:[theLoc objectForKey:@"location"] forKey:[theLoc objectForKey:@"id"]];
            }
        
            [allSelectedData2 setObject:theLocations2 forKey:@"locations"];
            [allSelectedData2 setObject:[[notification userInfo] objectForKey:@"help"] forKey:@"help"];
            [allSelectedData2 setObject:[[notification userInfo] objectForKey:@"interested"] forKey:@"interested"];
            self.allSelectedData = allSelectedData2;
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"load_profiledata"];
        }];
        [req retrieveProfileData];
    }
    
    self.matchCell.connectionData = [[jsonData objectForKey:@"newOnes"] mutableCopy];
    self.matchCell.oldConnectionData = [[jsonData objectForKey:@"old"] mutableCopy];
    [self.matchCell.theTable reloadData];
    
    if (!disableMatchScroll){
        [theScroll scrollRectToVisible:CGRectMake(298, theScroll.frame.origin.y, theScroll.frame.size.width, theScroll.frame.size.height) animated:YES];
    }
    [self removeLoadingView];
}

- (void) chatConfirmed:(int) data {
    [self.soloMessage chatConfirmed:data];
}

- (void)chatAnimation:(CGRect)moveFrame {
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         textChatContainer.frame = moveFrame;
                     }
                     completion:^(BOOL finished) {}];
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)prepareChatView:(CGRect) theFrame {
	
    textChatContainer = [[UIView alloc] initWithFrame:theFrame];
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    textView.returnKeyType = UIReturnKeyGo; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:textChatContainer];
	
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
	[self.soloMessage showKeyboard];
    
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note {
    
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
	// get a rect for the textView frame
	CGRect containerFrame = textChatContainer.frame;
    CGFloat theHeight = self.theScroll.bounds.size.height;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) theHeight = theHeight + 20;
    
    
    containerFrame.origin.y = theHeight - containerFrame.size.height;
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:[curve intValue]];
	
    // set views with new info
	textChatContainer.frame = containerFrame;
    [self.soloMessage hideKeyboard];
    [textView resignFirstResponder];
    
	// commit animations
	[UIView commitAnimations];
}



- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    NSLog(@"CAllig this guy");
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = textChatContainer.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	textChatContainer.frame = r;
}


- (void) sendChatMessage {
    [self.soloMessage sendChatMessage:self.textView];
}



- (void)hideChat {
    int hideY = 461;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) hideY = 481;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        hideY = 549;
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) hideY = 569;
    }
    
    CGRect moveFrame = CGRectMake(0, hideY, 320, 40);
    [self chatAnimation:moveFrame];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    int y_up = 461;
    int y_down = 421;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        y_up = 481;
        y_down = 441;
    }
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        y_up = 549;
        y_down = 509;
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            y_up = 569;
            y_down = 529;
        }
    }
    
    ScrollDirection scrollDirection = ScrollDirectionCrazy;
    if (self.lastContentOffset > scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionLeft;
    
    else if (self.lastContentOffset < scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionRight;
    
    self.lastContentOffset = scrollView.contentOffset.x;
   
    //NSLog(@"OFFSET %i" , self.lastContentOffset);
    if (lastContentOffset >= 9){
        /*if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"load_matchconnections"] boolValue]){
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:[NSString stringWithFormat:@"swipe right: New matches requested"]];
            [self doMatchScroll:scrollView];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"load_matchconnections"];
        }*/
    }

    if (scrollDirection == ScrollDirectionRight){
        [self.mainCard.searchBar resignFirstResponder];
        if (lastContentOffset >= 302 && lastContentOffset < 595){
            //[self.matchCell.theTable reloadData];
        }
        
        
        /*[UIView animateWithDuration:.4 animations:^(void) {
            CGRect theFrame = [self.view viewWithTag:2156113].frame;
            theFrame.origin.y = -50;
            [self.view viewWithTag:2156113].frame = theFrame;
        }];*/
        
        //if (lastContentOffset >= 402 && lastContentOffset < 618){
        if (lastContentOffset >= 102 && lastContentOffset < 320){
            if (self.textChatContainer == nil){
                [self prepareChatView:CGRectMake(0, y_up, 320, 40)];
            } else {
                CGRect moveFrame = CGRectMake(0, y_down, 320, 40);
                [self chatAnimation:moveFrame];
            }
        } else {
            [self hideChat];
            [textView resignFirstResponder];
        }
    }

    if (scrollDirection == ScrollDirectionLeft){
        [self.mainCard.searchBar resignFirstResponder];
        if (lastContentOffset < 513 && lastContentOffset > 304 ){
            CGRect moveFrame = CGRectMake(0, y_down, 320, 40);
            [self chatAnimation:moveFrame];
        }
        if (lastContentOffset < 102){
            [self hideChat];
            [textView resignFirstResponder];
        }
        if (lastContentOffset > 1 && lastContentOffset < 6){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_matchconnections"];
        }
        
        if (lastContentOffset > 0 && lastContentOffset <= 276){
            /*[UIView animateWithDuration:.4 animations:^(void) {
                CGRect theFrame = [self.view viewWithTag:2156113].frame;
                theFrame.origin.y = 20;
                [self.view viewWithTag:2156113].frame = theFrame;
            }];*/
        }
    }
    
}


- (void) triggerMatch {
    [self doMatchScroll:self.theScroll];
}


- (void) viewDidAppear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"load_matchconnections"];
    //[self doMatchRequest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end