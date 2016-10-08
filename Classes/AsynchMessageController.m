//
//  AsynchMessageController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 12/01/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#ifdef __IPHONE_7_0
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
#else
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
#endif



#import "AsynchMessageController.h"
#import "PeopleHuntRequests.h"
#import "AvatarImageView.h"
#import "iphoneCrowdAppDelegate.h"
#import "ChatCell.h"
#import "LocationImageView.h"
#import "HuntProfileHelper.h"
#import "StringEscapeUtil.h"
#import "FacebookActionSharing.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
//#import "Mixpanel.h"
#import "IOSUtility.h"
#import "Constants.h"
#import "AFNetworking.h"

@interface AsynchMessageController ()

@end

@implementation AsynchMessageController
@synthesize theOtherUrl, matchedUsername, messages, otherProfileId, theName, myMapView;
@synthesize theyHaveSharedLocation, iHaveSharedLocation, theirSharedLocation, matchContent;
@synthesize matchCriteria, matchLayout, currentUserData, backView, bottomImage, proficiency, paymentType, ratings, userEmail;

static int const DATELABEL_TAG = 1;
static int const MESSAGELABEL_TAG = 2;//44477779
static int const TIMESTAMPLABEL_TAG = 44477779;
static int const IMAGEVIEW_TAG_1 = 3;
static int const IMAGEVIEW_TAG_2 = 4;
static int const IMAGEVIEW_TAG_3 = 5;
static int const IMAGEVIEW_TAG_4 = 6;
static int const IMAGEVIEW_TAG_5 = 7;
static int const IMAGEVIEW_TAG_6 = 8;
static int const IMAGEVIEW_TAG_7 = 9;
static int const IMAGEVIEW_TAG_8 = 10;
static int const IMAGEVIEW_TAG_9 = 11;

int bubble_left_column_width; int bubble_middle_column_width; int bubble_right_column_width;
int bubble_top_row_height; int bubble_middle_row_height; int bubble_bottom_row_height;
int bubble_x, bubble_y;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = 48388292;
    
    CGRect tableFrame = theTableView.frame;
    tableFrame.size.width = 298;   
    
    // Do any additional setup after loading the view from its nib.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"location_10"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"location_249"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"location_452"];
   
    self.view.backgroundColor = [UIColor clearColor];
    self.backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardback_middle.png"]];
 
    //mine
    //---location to display the bubble fragment---
	bubble_x = 0;
	bubble_y = 10;
	
	//---size of the bubble fragment---
	bubble_left_column_width = 15;
	bubble_middle_column_width = 5;
    bubble_right_column_width = 15;
    
    bubble_top_row_height = 25;
    bubble_middle_row_height = 5;
    bubble_bottom_row_height = 8;
    self.matchLayout = [[MatchDataTableController alloc] initWithNibName:@"MatchDataTableController" bundle:nil];
    
 
    [self retrieveInbox];
}

- (UIControl *)createCardView {
    
    //white screen holding match data        
    CGRect layoutFrame = self.matchLayout.view.frame;
    layoutFrame.origin.x = 17;
    layoutFrame.origin.y = 165;
    layoutFrame.size.width = 264;
    CGFloat finHeight = [self.matchLayout calculateLayout];
    //NSLog(@"HEIIIHE %f", finHeight);
    //layoutFrame.size.height = finHeight + 100;
    layoutFrame.size.height =  40;
    self.matchLayout.view.frame = layoutFrame;
    self.matchLayout.inverseOrder = true;
    
    
    UIControl *matchView = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 297.5, 110)] autorelease];
    matchView.backgroundColor = [UIColor clearColor];
    matchView.tag = 244;
    [matchView addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];
    //[matchView addSubview:matchLayout.view];
    
    UIView* patchView = [[[UIView alloc] initWithFrame:CGRectMake(0, 15, 297.5, 102)] autorelease];
    patchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardback_middle.png"]];
    [matchView addSubview:patchView];
    
    
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    [matchView addSubview:topCard];
    
    
    UIView *middleBackGround = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 139)];
    UIImageView *middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 24)];
    middleCard.image = [UIImage imageNamed:@"cardback_middle.png"];
    middleBackGround.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardback_middle.png"]];
    //[matchView addSubview:middleBackGround];
    
    
    UIView *middleBackGround2 = [[UIView alloc] initWithFrame:CGRectMake(0, 270, 297.5, 139)];
    UIImageView *middleCard2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 24)];
    middleCard2.image = [UIImage imageNamed:@"cardback_middle.png"];
    middleBackGround2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardback_middle.png"]];
    //[matchView addSubview:middleBackGround];
    
    //TheirProfileImage - distance between this and above - 11
    
    UIImageView *photoBG = [[UIImageView alloc] initWithFrame:CGRectMake(5, 29, 72, 72)];
    photoBG.image = [UIImage imageNamed:@"back_pictureChat.png"];
    AvatarImageView *asyncImageView = [[[AvatarImageView alloc] initWithFrame:CGRectMake(5.25,5.25, 122, 122)] autorelease];
    asyncImageView.userInteractionEnabled = NO;
    asyncImageView.tag = 12;
    //asyncImageView.layer.cornerRadius = 2.0;
    asyncImageView.layer.masksToBounds = YES;
    asyncImageView.displayUImage = true;
    [matchView addSubview:photoBG];
    [photoBG addSubview:asyncImageView];
    [asyncImageView checkIfImageExists:self.theOtherUrl theImageFrame:CGRectMake(0,0, 60, 60)];
    
    UIButton *showCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showCardButton addTarget:self action:@selector(showCardView) forControlEvents:UIControlEventTouchUpInside];
    [showCardButton setFrame:CGRectMake(5, 29, 60, 60)];
    [matchView addSubview:showCardButton];
    
    
    UILabel *nameBold = [[[UILabel alloc] initWithFrame:CGRectMake(80,30, 150, 26)] autorelease];
    nameBold.backgroundColor = [UIColor clearColor];
    nameBold.lineBreakMode = LINE_BREAK_WORD_WRAP;
    nameBold.numberOfLines = 1;
    nameBold.font = [UIFont fontWithName:@"Delicious-Heavy" size:22.0];
    nameBold.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
    nameBold.textAlignment = NSTextAlignmentLeft;
    nameBold.text = [NSString stringWithFormat:@"%@",self.theName];
    [matchView addSubview:nameBold];
    
    
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(150, 50, 119, 35)] autorelease];
    int thePaymentType = [[paymentType objectForKey:@"payment_type"] intValue];
    
    switch (thePaymentType) {
        case 1:
            [button setImage:[UIImage imageNamed:@"pay_for_coffee@2x.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [button setImage:[UIImage imageNamed:@"pay_guide@2x.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [button setImage:[UIImage imageNamed:@"pay_for_food@2x.png"] forState:UIControlStateNormal];
            break;
    }
   
    [button addTarget:self action:@selector(payNow) forControlEvents:UIControlEventTouchDown];
    [matchView addSubview:button];
    
    
    UILabel *rate = [[[UILabel alloc] initWithFrame:CGRectMake(150,80, 150, 26)] autorelease];
    rate.backgroundColor = [UIColor clearColor];
    rate.lineBreakMode = LINE_BREAK_WORD_WRAP;
    rate.numberOfLines = 1;
    rate.font = [UIFont fontWithName:@"Delicious-Heavy" size:15.0];
    rate.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
    rate.textAlignment = NSTextAlignmentLeft;
    rate.text = [NSString stringWithFormat:@"Total $%i", [[paymentType objectForKey:@"amount"] intValue]];
    [matchView addSubview:rate];
    
    
    //dotted line
    UIImageView* theView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    theView.frame = CGRectMake(4, 100, 354.5, 3.5);
    [matchView addSubview:theView];
    
    return matchView;
    
}


#pragma mark - Stripe Checkout
- (void) payNow {
    NSLog(@"PAYYYYYYYY %@",paymentType);
    STPCheckoutOptions *options = [[STPCheckoutOptions alloc] init];
    options.publishableKey = [Stripe defaultPublishableKey];
    options.purchaseDescription = [NSString stringWithFormat:@"%@ plus fees" , [paymentType objectForKey:@"description"]];
    options.purchaseAmount = [[paymentType objectForKey:@"amount"] intValue] * 100;
    self.amountToPay = options.purchaseAmount;
    options.logoColor = [UIColor blueColor];
    options.customerEmail = self.userEmail;
    STPCheckoutViewController *checkoutViewController = [[STPCheckoutViewController alloc] initWithOptions:options];
    checkoutViewController.checkoutDelegate = self;
    iphoneCrowdAppDelegate *del = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [del.navigationController presentViewController:checkoutViewController animated:YES completion:nil];
}

- (void)checkoutController:(STPCheckoutViewController *)controller didCreateToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion {
    [self createBackendChargeWithToken:token completion:completion];
}

- (void)checkoutController:(STPCheckoutViewController *)controller didFinishWithStatus:(STPPaymentStatus)status error:(NSError *)error {
    switch (status) {
        case STPPaymentStatusSuccess:
            [self paymentSucceeded:controller];
            break;
        case STPPaymentStatusError:
            [self presentError:error];
            break;
        case STPPaymentStatusUserCancelled:
            // do nothing
            break;
    }
    
    iphoneCrowdAppDelegate *del = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [del.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentError:(NSError *)error {
    
    NSLog(@"Error %@", [error localizedDescription]);
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)paymentSucceeded:(STPCheckoutViewController *)controller {
    
    [[[UIAlertView alloc] initWithTitle:@"Success!"
                                message:@"Payment successfully created!"
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
    
    NSDictionary* paymentDetails = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:controller.options.purchaseAmount], @"amount", [NSNumber numberWithInt:self.otherProfileId], @"guide_id", [[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"], @"learner_id", nil];
    
    //conver to Json
    NSError *error = NULL;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paymentDetails options:NSJSONReadingAllowFragments error:&error];
    NSString *theResult = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [req addTransaction:theResult];
    
}


#pragma mark - STPBackendCharging

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion {
    
    NSDictionary *chargeParams = @{ @"stripeToken": token.tokenId, @"amount": [NSString stringWithFormat:@"%i", self.amountToPay]};
    
    if (!BackendChargeURLString) {
        NSError *error = [NSError
                          errorWithDomain:StripeDomain
                          code:STPInvalidRequestError
                          userInfo:@{
                                     NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Good news! Stripe turned your credit card into a token: %@ \nYou can follow the "
                                                                 @"instructions in the README to set up an example backend, or use this "
                                                                 @"token to manually create charges at dashboard.stripe.com .",
                                                                 token.tokenId]
                                     }];
        completion(STPBackendChargeResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:[BackendChargeURLString stringByAppendingString:@"/charge"]
       parameters:chargeParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) { completion(STPBackendChargeResultSuccess, nil); }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) { completion(STPBackendChargeResultFailure, error); }];
}




- (void)doMatchLayout:(NSDictionary *)matchingArray {
    
    if ([matchingArray count] == 0) {
        NSMutableDictionary* finalRes = [[NSMutableDictionary alloc] init];
        NSDictionary* locations = [self.otherUserData objectForKey:@"locations"];
        NSDictionary* interested = [self.otherUserData objectForKey:@"interested"];
        NSDictionary* help = [self.otherUserData objectForKey:@"help"];
        [self quickSearch:@"locations" finalRes:finalRes searchArray:locations];
        [self quickSearch:@"help" finalRes:finalRes searchArray:help];
        [self quickSearch:@"interested" finalRes:finalRes searchArray:interested];
        matchingArray = finalRes;                        
    }
    
    NSLog(@"FINAL MATCH ARRAY %@", matchingArray);
    
    matchLayout.locations = [matchingArray objectForKey:@"locations"];
    matchLayout.help = [matchingArray objectForKey:@"help"];
    matchLayout.interested = [matchingArray objectForKey:@"interested"];
    matchLayout.proficiency = self.proficiency;
    
    int numberSections = 0;
    if ([[matchingArray objectForKey:@"locations"] count] > 0) numberSections++;
    if ([[matchingArray objectForKey:@"help"] count] > 0) numberSections++;
    if ([[matchingArray objectForKey:@"interested"] count] > 0) numberSections++;
    matchLayout.numberSections = numberSections;
}

- (void)retrieveInbox {
    
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        
        [HuntProfileHelper removeLoadingView:self.view];
        NSDictionary *allData = [data userInfo];
        
        NSLog(@"DATA DATA----______----> %@", allData);
        
        //do the message lines
        NSArray *allMessages = [[[allData objectForKey:@"inbox"] reverseObjectEnumerator] allObjects];
        self.messages = [[allMessages mutableCopy] autorelease];
        
        if([self.messages count] > 6){
            CGRect midFrame = self.backView.frame;
            midFrame.size.height = 45 * [self.messages count];
            self.backView.frame = midFrame;
        }
        
        
        self.theOtherUrl = [allData objectForKey:@"otherurl"];
        self.matchedUsername = [allData objectForKey:@"otherusername"];
        self.theName = [allData objectForKey:@"name"];
        self.ratings = [allData objectForKey:@"ratings"];
        self.paymentType = [allData objectForKey:@"paymentType"];
        self.userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* setLocations = [[NSMutableDictionary alloc] init];
        for (NSDictionary* theDic in [allData objectForKey:@"locations"]) {
            [setLocations setObject:[theDic objectForKey:@"location"] forKey:[NSString stringWithFormat:@"%i", [[theDic objectForKey:@"id"] intValue]]];
        }
        
        [userData setObject:setLocations forKey:@"locations"];
        //[userData setObject:[allData objectForKey:@"help"] forKey:@"help"];
        //[userData setObject:[allData objectForKey:@"interested"] forKey:@"interested"];
        [userData setObject:[allData objectForKey:@"match_criteria"] forKey:@"match_criteria"];
        [userData setObject:[allData objectForKey:@"otherurl"] forKey:@"image_url"];
        [userData setObject:[allData objectForKey:@"name"] forKey:@"name"];
        [userData setObject:[allData objectForKey:@"ratings"] forKey:@"ratings"];
        [userData setObject:[allData objectForKey:@"paymentType"] forKey:@"paymentType"];
        [userData setObject:[allData objectForKey:@"personalInterests"] forKey:@"personalInterests"];
        
        
        NSString* theBio = @"";
        if ([allData objectForKey:@"bio"])theBio = [allData objectForKey:@"bio"];
        [userData setObject:theBio forKey:@"bio"];
        [userData setObject:[allData objectForKey:@"inbox"] forKey:@"inbox"];
        NSLog(@"USERDATE %@", userData);
        self.currentUserData = userData;   
        
        //if match criteria is empty
        #pragma mark MATCH_CRITERI TODO
        NSLog(@"PRE MATCH ARRAY %@ %@", self.otherUserData, self.currentUserData);
        NSDictionary *matchingArray = self.matchCriteria;
        [self doMatchLayout:matchingArray];
       
        UIControl *matchView = [self createCardView];
        self.matchContent = [allData objectForKey:@"matchMessage"];
        theTableView.tableHeaderView = matchView;
        
        
        [theTableView reloadData];
        if ([self.messages count] > 0) {
            [theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
        //check for open connection
        iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];       
        if (![appDelegate.protocol checkStreamStatus]) [appDelegate initProtocolCommunicationMainThread:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"inbox_loaded" object:self userInfo:userData];
        
    }];
    
    [HuntProfileHelper addLoadingView:self.view];
    [req retrieveInbox:self.otherProfileId];
}

- (void) removeMyMapLocation{

    self.myMapView.hidden = true;
    [self.view viewWithTag:919].hidden = false;
    [self.view viewWithTag:920].hidden = false;
    [self.view viewWithTag:921].hidden = true;
}


- (void) doFacebookPermissions {
    [[self.view viewWithTag:179283] removeFromSuperview];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"all_friends"]){
        HuntProfileHelper *helper = [HuntProfileHelper new];
        helper.delegate = self;
        [helper retrieveFriends];
        return;
    }
    
    [self sendFacebookRequest];
}

- (void)quickSearch:(NSString *)searchString finalRes:(NSMutableDictionary *)finalRes searchArray:(NSDictionary *)theSeachArray {
    NSMutableDictionary* searchRes = [[NSMutableDictionary alloc] init];
    for (id key in theSeachArray) {
        NSDictionary *searchObj = [self.currentUserData objectForKey:searchString];
        if ([[self.currentUserData objectForKey:searchString] objectForKey:key]){
            [searchRes setObject:[searchObj objectForKey:key] forKey:key];
        }
    }
    [finalRes setObject:searchRes forKey:searchString];
    
}
- (void)setAskLabel:(UIControl *)matchView szBioCopy:(CGSize)szBioCopy {
    //yValueChange
    int yvalueAsk = 170;
    int addOnBioHeight = szBioCopy.height - 80;
    if (addOnBioHeight > 0) yvalueAsk += addOnBioHeight;
    
    UILabel *askNameAbout = [[[UILabel alloc] initWithFrame:CGRectMake(10,yvalueAsk, 300, 16)] autorelease];
    askNameAbout.backgroundColor = [UIColor clearColor];
    askNameAbout.lineBreakMode = UILineBreakModeClip;
    askNameAbout.numberOfLines = 1;
    askNameAbout.textColor = [UIColor colorWithRed:25/255.0 green:136/255.0 blue:222/255.0 alpha:1.0];
    askNameAbout.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    askNameAbout.textAlignment = UITextAlignmentLeft;
    askNameAbout.text = [NSString stringWithFormat:@"%@ can help with",self.theName];
    [matchView addSubview:askNameAbout];
}

- (void)addProvidingLabels:(UIControl *)matchView askCopy:(NSString *)askCopy allData:(NSDictionary *)allData szBioCopy:(CGSize)szBioCopy {
    //yValueChange
    float y_valueAskLabels = 186;
    int addOnBioHeight = szBioCopy.height - 80;
    if (addOnBioHeight > 0) y_valueAskLabels += addOnBioHeight;
    
    int maxLimit = 0;
    for (NSString *providing in [allData objectForKey:@"providing"]) {
        
        CGSize withinsize = CGSizeMake(280, 1000);
        CGSize providingSize = [IOSUtility checkSizeWithFont:withinsize theFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0] theText:providing];
        UIImageView *lightBulbHelp = [[[UIImageView alloc] initWithFrame:CGRectMake(10, y_valueAskLabels, 12, 16)] autorelease];
        lightBulbHelp.image = [UIImage imageNamed:@"ellenKnows.png"];
        [matchView addSubview:lightBulbHelp];
        
        UILabel *askContent = [[[UILabel alloc] initWithFrame:CGRectMake(25, y_valueAskLabels, 280, providingSize.height)] autorelease];
        askContent.backgroundColor = [UIColor clearColor];
        askContent.textColor = [UIColor blackColor];
        askContent.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        askContent.textAlignment = UITextAlignmentLeft;
        askContent.text = providing;
        askContent.numberOfLines = 0;
        askContent.lineBreakMode = LINE_BREAK_WORD_WRAP;
        [matchView addSubview:askContent];
        y_valueAskLabels += providingSize.height + 5;
        if (maxLimit == 42)  break;
        maxLimit++;
        //NSLog(@"askContent Height %f", y_valueAskLabels);
    }
}

- (void)setHelpLabel:(CGSize)szAskCopy matchView:(UIControl *)matchView countProviding:(int)thecount szBioCopy:(CGSize)szBioCopy{
    
    float y_value2;
    int yvalueAskPlusPadding = 190;
    int addOnBioHeight = szBioCopy.height - 80;
    
    if (szAskCopy.height == 0) y_value2 = 170;
    else  y_value2 = szAskCopy.height + (4.2*thecount)+ yvalueAskPlusPadding;
    
    if (addOnBioHeight > 0) y_value2 += addOnBioHeight;
    
    UILabel *helpNameWith = [[[UILabel alloc] initWithFrame:CGRectMake(10,y_value2, 300, 16)] autorelease];
    helpNameWith.backgroundColor = [UIColor clearColor];
    helpNameWith.lineBreakMode = UILineBreakModeClip;
    helpNameWith.numberOfLines = 1;
    helpNameWith.textColor = [UIColor colorWithRed:25/255.0 green:136/255.0 blue:222/255.0 alpha:1.0];
    helpNameWith.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    helpNameWith.textAlignment = UITextAlignmentLeft;
    helpNameWith.text = [NSString stringWithFormat:@"Help %@ with",self.theName];
    [matchView addSubview:helpNameWith];
    
}

- (void)addLookingLabels:(CGSize)szAskCopy matchView:(UIControl *)matchView helpCopy:(NSString *)helpCopy szHelpCopy:(CGSize)szHelpCopy allData:(NSDictionary *)allData countProviding:(int)thecount szBioCopy:(CGSize)szBioCopy{
    //yValueChange
    float y_value2HelpLabels;
    float paddingAndAskLabels = 206;
    int addOnBioHeight = szBioCopy.height - 80;
    
    if (szAskCopy.height == 0) y_value2HelpLabels = 186;
    else  y_value2HelpLabels = szAskCopy.height + (4.2*thecount)+ paddingAndAskLabels;
    
    if (addOnBioHeight > 0) y_value2HelpLabels += addOnBioHeight;
    
    int maxLimit = 0;
    for (NSString *looking in [allData objectForKey:@"looking"]) {
        //NSLog(@"y_vale %f", y_value2HelpLabels);
        CGSize withinsize = CGSizeMake(280, 1000);
        CGSize lookingSize = [IOSUtility checkSizeWithFont:withinsize theFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0] theText:looking];
        
        UIImageView *lightBulbAsk = [[[UIImageView alloc] initWithFrame:CGRectMake(10, y_value2HelpLabels, 12, 16)] autorelease];
        lightBulbAsk.image = [UIImage imageNamed:@"askEllen.png"];
        [matchView addSubview:lightBulbAsk];
        
        UILabel *helpContent = [[[UILabel alloc] initWithFrame:CGRectMake(25, y_value2HelpLabels, 280, lookingSize.height)] autorelease];
        helpContent.backgroundColor = [UIColor clearColor];
        helpContent.textColor = [UIColor blackColor];
        helpContent.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        helpContent.textAlignment = UITextAlignmentLeft;
        helpContent.text = looking;
        helpContent.numberOfLines = 0;
        helpContent.lineBreakMode = LINE_BREAK_WORD_WRAP;
        [matchView addSubview:helpContent];
        y_value2HelpLabels += lookingSize.height + 5;
        if (maxLimit == 42) break;
        maxLimit++;
        //NSLog(@"helpContent Height %f", y_value2HelpLabels);
    }
}

- (void) facebookActionDone {
    [[self.view viewWithTag:1728393] removeFromSuperview];
    [[self.navigationController.view viewWithTag:1728393] removeFromSuperview];
    [self sendFacebookRequest];
}

- (void) sendFacebookRequest {
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFacebookSharingPop) name:FBSessionStateChangedNotification object:nil];
    [appDelegate openSessionWithAllowLoginUI:YES];
}


- (void) doFacebookSharingPop {
   
    
    FacebookActionSharing *sharing = [[[FacebookActionSharing alloc] initWithNibName:@"FacebookActionSharing" bundle:nil] autorelease];
    sharing.theMessage = [NSString stringWithFormat:@"I just connected with %@ and I thought you should connect too", self.theName];
    sharing.selectedFeeler = @"Introduction";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sharing];
    UINavigationBar *navBar = [navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    //now present this navigation controller as modally
    [self presentModalViewController:navigationController  animated:YES];    
}



- (void) backButtonTapped {
    [self dismissModalViewControllerAnimated:YES];
}



- (void) showKeyboard {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        theTableView.contentInset = UIEdgeInsetsMake(0, 0, theTableView.frame.size.height - 260, 0);
    } else {        
        theTableView.contentInset = UIEdgeInsetsMake(0, 0, theTableView.frame.size.height - 170, 0);
    }
    
    if ([self.messages count] > 0) {       
        [theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else {
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            [theTableView scrollRectToVisible:CGRectMake(0, theTableView.frame.size.height - 755, 320, theTableView.frame.size.height) animated:YES];
        } else {
            [theTableView scrollRectToVisible:CGRectMake(0, theTableView.frame.size.height -436, 320, theTableView.frame.size.height) animated:YES];
        }
    }
}


- (void) hideKeyboard {
    //add the rest of animations
    theTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.messages count] > 0) {
        [theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}




- (void) dismissKeyboard {
    NSLog(@"release");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissmiss_keyword" object:self];
    
    
}

#pragma - mark Custom chatInput view
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}


#pragma - mark Message methods
- (void) sendChatMessage:(HPGrowingTextView*) aTextView {
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"chatMessage Sent"];
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (aTextView.text > 0){
        //recycleMatch = false;
        //send the message to protocol
        NSMutableString* theChatMessage =  [[aTextView.text mutableCopy] autorelease];
        NSDictionary *myChatResponse = nil;
        if ([theDelegate.protocol checkStreamStatus]) {
           
            [theChatMessage replaceOccurrencesOfString:@":"  withString:@"=$$=" options:NSLiteralSearch range:NSMakeRange(0, [theChatMessage length])];

            NSString *msgProt = [NSString stringWithFormat:@"40:%i:%@:%i", self.otherProfileId, theChatMessage, [messages count] + 1];
            [theDelegate.protocol sendMessage:msgProt];
            [self performSelector:@selector(onRequestTimeout:) withObject:[NSNumber numberWithInt:[messages count] + 1] afterDelay:5.0]; // 5 secs
            
            NSString *fullName = @"Adrian";
            long long milliseconds = [[NSDate date] timeIntervalSince1970] * 1000;
            myChatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:fullName, @"name", theChatMessage, @"encodedContent", @"mine", @"reference", [NSNumber numberWithLongLong:milliseconds], @"dateSent", nil] autorelease];
            
        } else {
            NSString *fullName = @"Adrian";
            myChatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:fullName, @"name", [NSString stringWithFormat:@"Connection Error! Could not sent the message: %@", theChatMessage], @"encodedContent", @"none", @"reference", nil] autorelease];
        }
        
        //add it to the cell
        [self addNewRow:myChatResponse];
        aTextView.text = @"";
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"You didn't input any text!"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        return;

    }
    //[_chatInput fitText];
}

- (void) onRequestTimeout:(NSNumber *) code {
    NSLog(@"REQUEST TIME OURRRR");
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"heartbeatdone" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resendMessage) name:@"heartbeatdone" object:nil];
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [theDelegate checkHeartBeat];
}


- (void) resendMessage {
    NSLog(@"resending");
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *theMessage = [messages objectAtIndex:[messages count] -1];
    [theDelegate.protocol sendMessage:theMessage];
}

- (void)addNewRow: (NSDictionary *) myChatResponse {
    
    NSMutableArray *rowArray = [[[NSMutableArray alloc] init] autorelease];
    int initCount = [messages count];
    [rowArray addObject:[NSIndexPath indexPathForRow:initCount inSection:0]];
    [messages addObject:myChatResponse];    
    
    [theTableView beginUpdates];
    [theTableView insertRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationFade];
    [theTableView endUpdates];
    initCount = [messages count] - 1;
    
    [theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:initCount inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void) updateData {
    [self retrieveInbox];
}

#pragma mark - process messages 
- (void) incomingMessage:(NSArray *) response {
    
    NSDictionary *chatResponse = nil;
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *content = [[response objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"CANCEL count %i", [response count]);
    if ([response count] == 3) {        
        //chatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:self.theName, @"name", @"Oops. the message was not delivered but will be stored in his/her inbox", @"content", @"other", @"reference", nil] autorelease];    
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    } else {
        [theDelegate.protocol sendMessage:[NSString stringWithFormat:@"101:%i:%i", self.otherProfileId, [[response objectAtIndex:3] intValue]]];
        chatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:self.theName, @"name", content, @"encodedContent", @"other", @"reference", nil] autorelease];
         [[NSUserDefaults standardUserDefaults] setObject:content forKey:[NSString stringWithFormat:@"message_%i", self.otherProfileId]];
    }
    
    //add the tableRow now
    if (chatResponse != nil){
        [self addNewRow:chatResponse];        
    }
}

- (void) chatConfirmed:(int) data {
    NSLog(@"RECEIVED %i", data);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onRequestTimeout:) object:[NSNumber numberWithInt:data]];
}


#pragma mark - share location method
- (void) locationWarningPop{
    iHaveSharedLocation = false;
    UIView *locationWarningPop = [[[UIView alloc] initWithFrame:CGRectMake(20, 10, 281, 197)] autorelease];
    locationWarningPop.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noFeelerPop.png"]];
    locationWarningPop.tag = 808714;
    [self.view  addSubview:locationWarningPop];
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,11,261,115)] autorelease];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:1];
    infoLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    infoLabel.textAlignment = UITextAlignmentCenter;
    infoLabel.numberOfLines = 0;
    infoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0.1" options:NSNumericSearch] != NSOrderedAscending) {
        infoLabel.text = [NSString stringWithFormat:@"Whoops! \nTurn on Location Services to share your location: \n \nSettings>General>Privacy> \nLocation Services"];
    }else{
        infoLabel.text = [NSString stringWithFormat:@"Whoops! \nTurn on Location Services to share your location: \n \nSettings>Privacy>Location Services"];
    }
    
    [locationWarningPop addSubview:infoLabel];
    
    UIButton *closeItButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeItButton setFrame:CGRectMake(91, 135, 99, 46)];
    [closeItButton addTarget:self action:@selector(removeLocationWarning) forControlEvents:UIControlEventTouchUpInside];
    [closeItButton setBackgroundImage:[UIImage imageNamed:@"close_large.png"] forState:UIControlStateNormal];
    [locationWarningPop addSubview:closeItButton];
    
    [locationWarningPop setAlpha:0.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    
    [locationWarningPop setAlpha:1.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
}



- (void) incomingMapLocation:(NSArray *) data {
    
    [NSNotification notificationWithName:@"location_sent" object:self];
    
    self.theirSharedLocation = [data objectAtIndex:2];
    [[NSUserDefaults standardUserDefaults] setObject:self.theirSharedLocation forKey:[NSString stringWithFormat:@"location_%i", self.otherProfileId]];
    NSDictionary *chatResponse = nil;
    if (!iHaveSharedLocation){
        chatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:[data objectAtIndex:1], @"name", @"I just shared my location. Share yours to see mine", @"encodedContent", @"other", @"reference", nil] autorelease];
    } else {
        //otherwise display the map
        [self postTheMap:self.theirSharedLocation];
    }
    
    //add the tableRow now
    if (chatResponse != nil){
        [self addNewRow:chatResponse];
        
    }
}


- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {      
    if ([views count] == 2) {
        MKMapRect zoomRect = MKMapRectNull;
       
        for (MKAnnotationView *annot in views) {            
            MKMapPoint annotationPoint = MKMapPointForCoordinate([[annot annotation] coordinate]);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
        
        [mv setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    NSString *annotationIdentifier = @"PinViewAnnotation";
    LocationImageView *pinView = (LocationImageView *) [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!pinView) {
        
        if ([[annotation title] isEqualToString:@"yours"]) {
            pinView = [[[LocationImageView alloc]
                        initWithAnnotation:annotation
                        reuseIdentifier:annotationIdentifier imageUrl:self.theOtherUrl] autorelease];
            
        } else {
            pinView = [[[LocationImageView alloc]
                        initWithAnnotation:annotation
                        reuseIdentifier:annotationIdentifier] autorelease];
            
        }
        
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}


- (void) postTheMap:(NSString *) data {
    
    self.myMapView.hidden = false;
    [self.myMapView viewWithTag:8229].hidden = false;
    [self.view viewWithTag:919].hidden = true;
    [self.view viewWithTag:920].hidden = true;
   
    NSArray *theLoc = [data componentsSeparatedByString:@","];
    
    NSDictionary *theDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_location"];
    
    CLLocationCoordinate2D userCoordinate = CLLocationCoordinate2DMake([[theDic objectForKey:@"latitude"] doubleValue], [[theDic objectForKey:@"longitude"] doubleValue]);
    MKPointAnnotation *point = [[[MKPointAnnotation alloc] init] autorelease];
    point.title = @"mine";
    [point setCoordinate:userCoordinate];
    
    CLLocationCoordinate2D userCoordinate2 = CLLocationCoordinate2DMake([[theLoc objectAtIndex:0] doubleValue], [[theLoc objectAtIndex:1] doubleValue]);
    MKPointAnnotation *point2 = [[[MKPointAnnotation alloc] init] autorelease];
    point2.title = @"yours";
    [point2 setCoordinate:userCoordinate2];
    
    NSArray *allPoints = [[[NSArray alloc] initWithObjects:point, point2, nil] autorelease];
    [self.myMapView addAnnotations:allPoints];
    
}

- (void) sendMapProtocol {
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSDictionary *theDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_location"];
    [theDelegate.protocol sendMessage:[NSString stringWithFormat:@"50:%i:%@", self.otherProfileId, [NSString stringWithFormat:@"%@,%@", [theDic objectForKey:@"latitude"], [theDic objectForKey:@"longitude"]]]];
    
}

- (void) shareMyMapLocation:(id) sender {
    
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
   
    UIButton *theButton = ((UIButton *)sender);
    [theButton setBackgroundImage:[UIImage imageNamed:@"sharedLocationLoading.png"] forState:UIControlStateNormal];   
    
  
    [[NSNotificationCenter defaultCenter] addObserverForName:@"location_ready" object:theDelegate queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        iHaveSharedLocation = true;
        self.theirSharedLocation = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"location_%i", self.otherProfileId]];
        NSLog(@"LOCATION %@", self.theirSharedLocation);
        if (self.theirSharedLocation) {
            theButton.hidden = true;
            self.myMapView.hidden = false;
            [self postTheMap:self.theirSharedLocation];
            
        } else {
            //[theButton setImage:[UIImage imageNamed:@"shareLocationDone.png"] forState:UIControlStateNormal];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSDictionary *theDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_location"];
        [theDelegate.protocol sendMessage:[NSString stringWithFormat:@"50:%i:%@", self.otherProfileId, [NSString stringWithFormat:@"%@,%@", [theDic objectForKey:@"latitude"], [theDic objectForKey:@"longitude"]]]];      
        
    }];
    
    //location_fail
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(locationWarningPop)
                                                 name:@"location_fail" object:theDelegate];
	[theDelegate startGeolocation];
    [self.view viewWithTag:921].hidden = false;
}


#pragma mark - Table methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *) aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //mine
    static NSString *CellIdentifier = @"ChatCell";
    
    UILabel* messageLabel = nil;
    UILabel* timeStampLabel = nil;
	UIImageView *imageView_top_left = nil;
	UIImageView *imageView_top_middle = nil;
	UIImageView *imageView_top_right = nil;
    
	UIImageView *imageView_middle_left = nil;
	UIImageView *imageView_middle_right = nil;
	UIImageView *imageView_middle_middle = nil;
	
	UIImageView *imageView_bottom_left = nil;
	UIImageView *imageView_bottom_middle = nil;
	UIImageView *imageView_bottom_right = nil;
    int labelPadding = 0;
    
    AvatarImageView *otherPersonsPhoto = [[[AvatarImageView alloc] initWithFrame:CGRectMake(6, 12, 30, 30)] autorelease             ];
    otherPersonsPhoto.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    otherPersonsPhoto.layer.shadowRadius = 1.0;

    ChatCell *cell = (ChatCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *cellContent = [self.messages objectAtIndex:[indexPath row]];
    NSString *theContent = [StringEscapeUtil urlDecoder:[cellContent objectForKey:@"encodedContent"]];

    if (cell == nil) {
        cell = [[[ChatCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;      
        
        //---top left---
		imageView_top_left = [[[UIImageView alloc] init] autorelease];
        imageView_top_left.tag = IMAGEVIEW_TAG_1;
        [cell.contentView addSubview: imageView_top_left];
		
		//---top middle---
		imageView_top_middle = [[[UIImageView alloc] init] autorelease];
        imageView_top_middle.tag = IMAGEVIEW_TAG_2;
        [cell.contentView addSubview: imageView_top_middle];
		
		//---top right---
		imageView_top_right = [[[UIImageView alloc] init] autorelease];
        imageView_top_right.tag = IMAGEVIEW_TAG_3;
		[cell.contentView addSubview: imageView_top_right];
        
		//---middle left---
		imageView_middle_left = [[[UIImageView alloc] init] autorelease];
        imageView_middle_left.tag = IMAGEVIEW_TAG_4;
        [cell.contentView addSubview: imageView_middle_left];
		
		//---middle middle---
		imageView_middle_middle = [[[UIImageView alloc] init] autorelease];
        imageView_middle_middle.tag = IMAGEVIEW_TAG_5;
        [cell.contentView addSubview: imageView_middle_middle];
		
		//---middle right---
		imageView_middle_right = [[[UIImageView alloc] init] autorelease];
        imageView_middle_right.tag = IMAGEVIEW_TAG_6;
		[cell.contentView addSubview: imageView_middle_right];
		
		//---bottom left---
		imageView_bottom_left = [[[UIImageView alloc] init] autorelease];
        imageView_bottom_left.tag = IMAGEVIEW_TAG_7;
        [cell.contentView addSubview: imageView_bottom_left];
		
		//---bottom middle---
		imageView_bottom_middle = [[[UIImageView alloc] init] autorelease];
        imageView_bottom_middle.tag = IMAGEVIEW_TAG_8;
        [cell.contentView addSubview: imageView_bottom_middle];
		
		//---bottom right---
		imageView_bottom_right = [[[UIImageView alloc] init] autorelease];
        imageView_bottom_right.tag = IMAGEVIEW_TAG_9;
        [cell.contentView addSubview: imageView_bottom_right];
		
		//---message---
        messageLabel = [[[UILabel alloc] init] autorelease];
        messageLabel.tag = MESSAGELABEL_TAG;
        [cell.contentView addSubview: messageLabel];        
        //---message timestamp-------
        timeStampLabel = [[[UILabel alloc] init] autorelease];
        timeStampLabel.frame = CGRectMake(10, 2, 180, 30);
        timeStampLabel.tag = TIMESTAMPLABEL_TAG;
        //[cell.contentView addSubview: timeStampLabel];
        cell.tag = 99;
        if ([[cellContent objectForKey:@"reference"] isEqualToString:@"mine"]){
            
            int labelWidth = [self labelWidth:theContent];
            //labelWidth -= bubbleFragment_width;
            //if (labelWidth<0) labelWidth = 0;
            labelPadding = 10;
            bubble_x = 290 - (bubble_left_column_width + bubble_middle_column_width) - (labelWidth+ 10);
            //NSLog(@"bubble_x %i", bubble_x);
            //---set the images to display for each UIImageView---
            imageView_top_left.image = [UIImage imageNamed:@"bubble_top_left.png"];
            imageView_top_middle.image = [UIImage imageNamed:@"bubble_top_middle.png"];
            imageView_top_right.image = [UIImage imageNamed:@"bubble_top_right.png"];
            
            imageView_middle_left.image = [UIImage imageNamed:@"bubble_middle_left.png"];
            imageView_middle_middle.image = [UIImage imageNamed:@"bubble_middle_middle.png"];
            imageView_middle_right.image = [UIImage imageNamed:@"bubble_middle_right.png"];
            
            imageView_bottom_left.image = [UIImage imageNamed:@"bubble_bottom_left.png"];
            imageView_bottom_middle.image = [UIImage imageNamed:@"bubble_bottom_middle.png"];
            imageView_bottom_right.image = [UIImage imageNamed:@"bubble_bottom_right.png"];
            
        } else if ([[cellContent objectForKey:@"reference"] isEqualToString:@"other"]) {
            cell.tag = 88;
            bubble_x = 40;
            labelPadding = 18;            
           
            otherPersonsPhoto.tag = 9384;
            [cell.contentView addSubview: otherPersonsPhoto];
            [otherPersonsPhoto checkIfImageExists:self.theOtherUrl theImageFrame:CGRectMake(0, 0, 30, 30)];
            
            
            //---set the images to display for each UIImageView---
            imageView_top_left.image = [UIImage imageNamed:@"bubble_grey_top_left.png"];
            imageView_top_middle.image = [UIImage imageNamed:@"bubble_grey_top_middle.png"];
            imageView_top_right.image = [UIImage imageNamed:@"bubble_grey_top_right.png"];
            
            imageView_middle_left.image = [UIImage imageNamed:@"bubble_grey_middle_left.png"];
            imageView_middle_middle.image = [UIImage imageNamed:@"bubble_grey_middle_middle.png"];
            imageView_middle_right.image = [UIImage imageNamed:@"bubble_grey_middle_right.png"];
            
            imageView_bottom_left.image = [UIImage imageNamed:@"bubble_grey_bottom_left.png"];
            imageView_bottom_middle.image = [UIImage imageNamed:@"bubble_grey_bottom_middle.png"];
            imageView_bottom_right.image = [UIImage imageNamed:@"bubble_grey_bottom_right.png"];
            
        }
		
		
	} else {
		//---reuse the old views---
       
        messageLabel = (UILabel*)[cell.contentView viewWithTag: MESSAGELABEL_TAG];
        timeStampLabel = (UILabel*)[cell.contentView viewWithTag: TIMESTAMPLABEL_TAG];
		
		imageView_top_left = (UIImageView*)[cell.contentView viewWithTag: IMAGEVIEW_TAG_1];
		imageView_top_middle = (UIImageView*)[cell.contentView viewWithTag: IMAGEVIEW_TAG_2];
		imageView_top_right = (UIImageView*)[cell.contentView viewWithTag: IMAGEVIEW_TAG_3];
        
		imageView_middle_left = (UIImageView*)[cell.contentView viewWithTag: IMAGEVIEW_TAG_4];
		imageView_middle_middle = (UIImageView*)[cell.contentView viewWithTag: IMAGEVIEW_TAG_5];
		imageView_middle_right = (UIImageView*)[cell.contentView viewWithTag: IMAGEVIEW_TAG_6];
        
		imageView_bottom_left = (UIImageView*)[cell.contentView viewWithTag: IMAGEVIEW_TAG_7];
		imageView_bottom_middle = (UIImageView*)[cell.contentView viewWithTag: IMAGEVIEW_TAG_8];
		imageView_bottom_right = (UIImageView*)[cell.contentView viewWithTag: IMAGEVIEW_TAG_9];
        
        otherPersonsPhoto = (AvatarImageView*)[cell.contentView viewWithTag: 9384];
        [otherPersonsPhoto removeImageView];
        
        if (cell.tag == 88 && [[cellContent objectForKey:@"reference"] isEqualToString:@"mine"]){
            cell.tag = 99;
            int labelWidth = [self labelWidth:theContent];
            //labelWidth -= bubbleFragment_width;
            //if (labelWidth<0) labelWidth = 0;
            labelPadding =10;
            bubble_x = 290 - (bubble_left_column_width + bubble_middle_column_width) - (labelWidth + 10);
           
            //NSLog(@"bubble_x %i", bubble_x);
            //---set the images to display for each UIImageView---
            imageView_top_left.image = [UIImage imageNamed:@"bubble_top_left.png"];
            imageView_top_middle.image = [UIImage imageNamed:@"bubble_top_middle.png"];
            imageView_top_right.image = [UIImage imageNamed:@"bubble_top_right.png"];
            
            imageView_middle_left.image = [UIImage imageNamed:@"bubble_middle_left.png"];
            imageView_middle_middle.image = [UIImage imageNamed:@"bubble_middle_middle.png"];
            imageView_middle_right.image = [UIImage imageNamed:@"bubble_middle_right.png"];
            
            imageView_bottom_left.image = [UIImage imageNamed:@"bubble_bottom_left.png"];
            imageView_bottom_middle.image = [UIImage imageNamed:@"bubble_bottom_middle.png"];
            imageView_bottom_right.image = [UIImage imageNamed:@"bubble_bottom_right.png"];

            
        } else if (cell.tag == 99 && [[cellContent objectForKey:@"reference"] isEqualToString:@"other"]) {
            cell.tag = 88;           
            [cell setOtherPhoto:self.theOtherUrl];
            bubble_x = 40;
            labelPadding = 18;
            [otherPersonsPhoto checkIfImageExists:self.theOtherUrl theImageFrame:CGRectMake(0, 0, 30, 30)];
            
            //---set the images to display for each UIImageView---
            imageView_top_left.image = [UIImage imageNamed:@"bubble_grey_top_left.png"];
            imageView_top_middle.image = [UIImage imageNamed:@"bubble_grey_top_middle.png"];
            imageView_top_right.image = [UIImage imageNamed:@"bubble_grey_top_right.png"];
            
            imageView_middle_left.image = [UIImage imageNamed:@"bubble_grey_middle_left.png"];
            imageView_middle_middle.image = [UIImage imageNamed:@"bubble_grey_middle_middle.png"];
            imageView_middle_right.image = [UIImage imageNamed:@"bubble_grey_middle_right.png"];
            
            imageView_bottom_left.image = [UIImage imageNamed:@"bubble_grey_bottom_left.png"];
            imageView_bottom_middle.image = [UIImage imageNamed:@"bubble_grey_bottom_middle.png"];
            imageView_bottom_right.image = [UIImage imageNamed:@"bubble_grey_bottom_right.png"];
            
        } else if ([[cellContent objectForKey:@"reference"] isEqualToString:@"none"]){
            cell.tag = 88;
            bubble_x = 10;
            labelPadding = 18;
        }
	}
	
	//---calculate the height for the label---
   
    NSString *thecellContentItself = theContent;
	int labelHeight = [self labelHeight:thecellContentItself];
	//labelHeight -= bubbleFragment_height;
	if (labelHeight<0) labelHeight = 0;
    
    //---calculate the width for the label---
   	int labelWidth = [self labelWidth:thecellContentItself];
	//labelWidth -= bubbleFragment_width;
	if (labelWidth<0) labelWidth = 0;
	
    //---top left---
	imageView_top_left.frame = CGRectMake(bubble_x, bubble_y, bubble_left_column_width, bubble_top_row_height);
	//---top middle---
	imageView_top_middle.frame = CGRectMake(bubble_x + bubble_left_column_width, bubble_y, labelWidth , bubble_top_row_height);
	//---top right---
	imageView_top_right.frame = CGRectMake(bubble_x + bubble_left_column_width + labelWidth, bubble_y, bubble_right_column_width, bubble_top_row_height);
	//---middle left---
	imageView_middle_left.frame = CGRectMake(bubble_x, bubble_y + bubble_top_row_height, bubble_left_column_width, labelHeight-16);
	//---middle middle---
	imageView_middle_middle.frame = CGRectMake(bubble_x + bubble_left_column_width, bubble_y + bubble_top_row_height, labelWidth , labelHeight-16);
	//---middle right---
	imageView_middle_right.frame = CGRectMake(bubble_x + bubble_left_column_width +labelWidth, bubble_y + bubble_top_row_height, bubble_right_column_width, labelHeight-16);
	//---bottom left---
	imageView_bottom_left.frame = CGRectMake(bubble_x, bubble_y + bubble_top_row_height + labelHeight-16, bubble_left_column_width, bubble_bottom_row_height);
	//---bottom middle---
	imageView_bottom_middle.frame = CGRectMake(bubble_x + bubble_left_column_width, (bubble_y + bubble_top_row_height + labelHeight-16), labelWidth, bubble_bottom_row_height);
	//---bottom right---
	imageView_bottom_right.frame = CGRectMake(bubble_x + bubble_left_column_width + labelWidth , (bubble_y + bubble_top_row_height  + labelHeight-16), bubble_right_column_width, bubble_bottom_row_height );
    
	//---you can customize the look and feel for each message here---
	messageLabel.frame = CGRectMake(bubble_x+labelPadding, bubble_y+8, labelWidth, labelHeight);
	messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.textColor = [UIColor darkTextColor];
	messageLabel.numberOfLines = 0; //---display multiple lines---
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    theContent = [theContent stringByReplacingOccurrencesOfString:@"=$$="
                                                               withString:@":"];
	messageLabel.text = theContent;
    //[messageLabel sizeToFit];
    //set time stamp
    /*NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:([[cellContent objectForKey:@"dateSent"] longLongValue] / 1000)];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
    timeStampLabel.text = [dateFormatter stringFromDate:timestampDate];*/
    
    return cell;
}


- (void) showCardView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"view_card" object:self];
}

//---calculate the height for the message---
-(CGFloat) labelHeight:(NSString *) text {
	CGSize maximumLabelSize = CGSizeMake(230,9999);
    CGSize expectedLabelSize = [IOSUtility checkSizeWithFont:maximumLabelSize theFont:[UIFont fontWithName:@"HelveticaNeue" size:14] theText:text];
	return expectedLabelSize.height;
}
//--calculate the width for the message -----
-(CGFloat) labelWidth:(NSString *) text {
	CGSize maximumLabelSize = CGSizeMake(230,9999);
    CGSize expectedLabelSize = [IOSUtility checkSizeWithFont:maximumLabelSize theFont:[UIFont fontWithName:@"HelveticaNeue" size:14] theText:text];
	return expectedLabelSize.width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {   
    [self dismissKeyboard];
}


- (CGFloat)tableView:(UITableView *) aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSDictionary *cellContent = [self.messages objectAtIndex:[indexPath row]];
    NSString *copy = [StringEscapeUtil urlDecoder:[cellContent objectForKey:@"encodedContent"]];
    //mine
    int labelHeight = [self labelHeight:copy];
    
	return (bubble_y + bubble_middle_row_height + bubble_top_row_height + labelHeight) -10;

}


- (void) viewWillDisappear:(BOOL)animated {
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[theDelegate startHunting];
}

- (void)dealloc {
    [proficiency release];
    [bottomImage release];
    [backView release];
    [matchCriteria release];
    [textView release];
    [matchContent release];
    [theirSharedLocation release];
    [myMapView release];   
    [messages release];
    [theOtherUrl release];
    [matchedUsername release];    
    [super dealloc];
}



@end
