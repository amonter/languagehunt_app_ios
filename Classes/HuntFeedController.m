//
//  HuntFeedController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 11/10/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "HuntFeedController.h"
#import "HuntFeedCell.h"
#import "PeopleHuntRequests.h"

#import "ShareAuthenticateController.h"

#import "HuntProfileHelper.h"
#import "StringEscapeUtil.h"
#import "IndividualFeelerController.h"
#import "TheMatcher.h"
#import "iphoneCrowdAppDelegate.h"
#import "AvatarImageView.h"
#import "MatchViewController.h"
#import "iphoneCrowdAppDelegate.h"
#import "CanShareController.h"
#import "MyCustomSearch.h"
#import "CanShareController.h"
#import "ProfileV2Controller.h"
#import "ConnectionListController.h"
#import "PlanningView.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "AddAnswerAutoContoller.h"
#import "FacebookActionSharing.h"
#import "SegmentsController.h"
#import "CommunityActivityController.h"
//#import "Mixpanel.h"

@interface HuntFeedController ()

@end

@implementation HuntFeedController
@synthesize selectedAnswers, haveTooAnswers, matchedUsername, foundData, protocol, parentAnswers, knowledgeField, characterImageAddExperience, hitOnce, hitSharingOnce;
@synthesize changingAnswers, matcherRequest,fastHunting, bundleId, huntId, theMatch, tempInserts, bundleName, location, feelerData, showExitingFeelerAdded, updateDataFeeler, insertTheFeelerBool, searchBar, feelerDataArray, theSearchText;
@synthesize segmentDownload;

@synthesize lastSelectedFeelerId;

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    //navigation controller
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
   
    isHuntHappening = false;
    self.changingAnswers = [[[NSMutableArray alloc] init] autorelease];
    self.feelerDataArray = [[[NSMutableArray alloc] init] autorelease];
    self.haveTooAnswers = [[[NSMutableSet alloc] init] autorelease];
    self.tempInserts = [[[NSMutableArray alloc] init] autorelease];
    self.selectedAnswers = [[[NSMutableArray alloc] init] autorelease];
    
    hitOnce = true;
    hitSharingOnce = true;
    [self updateData];
    
    self.view.tag = 11900;
    
    //Check for button setting
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_btn"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"facebook_btn"];
    }
    
    //add profile tab now
    //home icon setup
    UIButton *profileBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 41)] autorelease];
    profileBtn.tag = 222777;
    [profileBtn setImage:[UIImage imageNamed:@"leftProfileHead.png"] forState:UIControlStateNormal];
    [profileBtn setImage:[UIImage imageNamed:@"leftProfileHeadPressed.png"] forState:UIControlStateHighlighted];
    [profileBtn setImage:[UIImage imageNamed:@"leftProfileHeadPressed.png"] forState:UIControlStateSelected];
    [profileBtn addTarget:self action:@selector(addProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *profileItem = [[[UIBarButtonItem alloc] initWithCustomView:profileBtn] autorelease];
    self.navigationItem.leftBarButtonItem = profileItem;
    
    
    //add the table Header now
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 56)] autorelease];
    self.searchBar = [[[MyCustomSearch alloc] initWithFrame:CGRectMake(9, 6, 304, 44)] autorelease];
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor whiteColor];
    [headerView addSubview:self.searchBar];
    UIImageView *overSearchView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, -4, 320, 56)] autorelease];
    overSearchView.image = [UIImage imageNamed:@"searchBarOver.png"];
    [headerView addSubview:overSearchView];
    self.tableView.tableHeaderView = headerView;    
    
    //Request Button
    UIButton *requestBtn = [[[UIButton alloc] initWithFrame:CGRectMake(204, 50, 119, 44)] autorelease];
    requestBtn.tag = 2211728;
    [requestBtn setImage:[UIImage imageNamed:@"postWant.png"] forState:UIControlStateNormal];
    [requestBtn addTarget:self action:@selector(addRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:requestBtn];
    
    [self.view setNeedsLayout];
    
}

- (void) addRequest {
  
    AddAnswerAutoContoller *add = [[[AddAnswerAutoContoller alloc] initWithNibName:@"AddAnswerAutoContoller" bundle:nil] autorelease];
    //if (selectionDone) add.savedTerm = selectionDone;
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:add];
    [self presentModalViewController:navBar animated:YES];
}

- (void) addProfile:(id) sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"]){
        ProfileV2Controller *shareFeeler = [[[ProfileV2Controller alloc] initWithNibName:@"ProfileV2Controller" bundle:nil] autorelease];
        UINavigationController *myNavigationController = [[[UINavigationController alloc] initWithRootViewController:shareFeeler] autorelease];
        UINavigationBar *navBar = [myNavigationController navigationBar];
        UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        [self.navigationController presentModalViewController:myNavigationController animated:YES];
    } else {
        [self shareFriendsPop:YES];
    }
}

- (void) backButtonTapped {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [HuntProfileHelper deleteSession:self];
}

- (void)doUpdateOperation:(NSNotification *)data {
   
    //retrieve data from back-end
    NSArray *feelerArray = [[data userInfo] objectForKey:@"feelers"];
    //NSLog(@"FEEER %@", feelerArray);
    for (NSDictionary *dicData in feelerArray) {        
        NSMutableDictionary *newDic = [[[NSMutableDictionary alloc] initWithDictionary:dicData] autorelease];
        NSMutableString *feelerDescription = [[[newDic objectForKey:@"URLEncodedAnswer"] mutableCopy] autorelease];
        NSString *formattedFeeler = [[StringEscapeUtil xmlSimpleEscape:feelerDescription] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [newDic setObject:formattedFeeler forKey:@"URLEncodedAnswer"];       
        [self.changingAnswers addObject:newDic];
        [self.feelerDataArray addObject:newDic];
    }
    
    //providing for data
    NSArray *providingArray = [[data userInfo] valueForKey:@"providing"];
    for (id answerId in providingArray) {
        [self.haveTooAnswers addObject:[NSNumber numberWithInt:[answerId intValue]]];
    }
    
    //populate the answers with parentId
    NSLog(@"UPDATE RELOAD");
    [self.tableView reloadData];
    
    //Get the selected answers or looking for
    NSMutableArray *realSelectedAnswers = [[[NSMutableArray alloc] init] autorelease];
    //Question *theQuestion = [self.bundle.questions objectAtIndex:0];
    NSArray *backAnswers = [[data userInfo] objectForKey:@"looking"];
    for (id feelerId in backAnswers) {
        [realSelectedAnswers addObject:[NSNumber numberWithInt:[feelerId intValue]]];
    }
    
    //[self.selectedAnswers addObjectsFromArray:realSelectedAnswers];
    [self.selectedAnswers addObjectsFromArray:realSelectedAnswers];
    [self stopLoading];
    
    
}

- (void) managePopUps:(NSArray *)feelerArray{
    
    /*//manage pop-ups
    if ([feelerArray count] > 0 && ![[NSUserDefaults standardUserDefaults] objectForKey:@"addfeeler"] ){
        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(addFirstInfoPop)
                                       userInfo:nil
                                        repeats:NO];
     
    }*/
    
}

//method with first table update
- (void) updateHaveData:(NSNotification *) data {
    NSLog(@"SEGMENT %i", segmentDownload);
    if (segmentDownload == 0) self.segmentDownload = 1;
    
    [HuntProfileHelper removeLoadingView:self.view];    
    //show exsting feeler added now
    if (showExitingFeelerAdded) {
        showExitingFeelerAdded = false;
        
    }
    
    //updating all the values and table
    [self doUpdateOperation:data];
    
    //do the hunt
    if ([self.selectedAnswers count] > 0 || [self.haveTooAnswers count] > 0) {
        NSString *activated = [[NSUserDefaults standardUserDefaults] objectForKey:@"hunt_activated"];
        if (!activated) {
            iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate startHunting];
        }
    }
    
    [self managePopUps:[[data userInfo] objectForKey:@"feelers"]];
    if (self.segmentDownload == 1){
        [self updateData];
        self.segmentDownload = -1;
    }
    
    
}


- (IBAction)goConnections {
    
 
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"]){        
        
        /*iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *theNav = [appDelegate retrieveMessageSegments];
        CommunityActivityController* com = [[[CommunityActivityController alloc] initWithNibName:@"CommunityActivityController" bundle:nil] autorelease];
        com.navigationItem.titleView = appDelegate.segmentControl;*/

        //iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        //UINavigationController *theNav = [appDelegate retrieveMessageSegments];
       // CommunityActivityController* com = [[[CommunityActivityController alloc] initWithNibName:@"CommunityActivityController" bundle:nil] autorelease];
        ConnectionListController* com = [[[ConnectionListController alloc] initWithNibName:@"ConnectionListController" bundle:nil] autorelease];
        [self.navigationController pushViewController:com animated:YES];
    } else {
        [self shareFriendsPop:YES];
    }
}


#pragma - mark search methods
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [searchBar resignFirstResponder];
}

- (void)doTermSearch:(NSString *)searchText {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"searchTapped"] ){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"searchTapped"];
    }
    
    [self.changingAnswers removeAllObjects];
    self.theSearchText = searchText;
    NSMutableArray* containsAnother = [NSMutableArray array];    
    for (NSDictionary* cellDic in self.feelerDataArray) {
        NSString *cellContent = [cellDic objectForKey:@"URLEncodedAnswer"];
        if ([cellContent rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound){
            [containsAnother addObject:cellDic];
        }       
    }
    
    UIView *theFooter = self.tableView.tableFooterView;
    if ([containsAnother count] == 0){
        [self.view viewWithTag:2211728].hidden = true;
        if (theFooter == nil){
            UILabel *feelerName = [[[UILabel alloc] initWithFrame:CGRectMake(95, 0, 215, 44)] autorelease];
            feelerName.tag = 7776;
            feelerName.backgroundColor = [UIColor clearColor];
            feelerName.lineBreakMode = UILineBreakModeWordWrap;
            feelerName.numberOfLines = 0;
            feelerName.textColor = [UIColor blackColor];
            feelerName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
            feelerName.text = [NSString stringWithFormat:@"add \"%@\"", searchText];
            UIView *addFooter = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
            UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 75, 44)] autorelease];
            [button setImage:[UIImage imageNamed:@"add_button.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addTheFeeler) forControlEvents:UIControlEventTouchUpInside];
            [addFooter addSubview:feelerName];
            [addFooter addSubview:button];
            self.tableView.tableFooterView = addFooter;
        } else {
            UILabel *addLabel = (UILabel *)[theFooter viewWithTag:7776];
            addLabel.text = [NSString stringWithFormat:@"add \"%@\"", searchText];
        }
    } else {
        if (theFooter != nil){
            self.tableView.tableFooterView = nil;
        }
    }    
   
    NSLog(@"temrs %i changing asn %i", [containsAnother count], [self.changingAnswers count]);
    [self.changingAnswers addObjectsFromArray:containsAnother];
    [self.tableView reloadData];  
}

- (void) closePage{    
    [self dismissModalViewControllerAnimated:YES];    
}


- (void)resetTable {
    NSLog(@"RESET");
    [self.view viewWithTag:2211728].hidden = false;
    [self.changingAnswers removeAllObjects];
    [self.changingAnswers addObjectsFromArray:self.feelerDataArray];
    [self.tableView reloadData];
    self.tableView.tableFooterView = nil;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {    
    int textLenght = [searchText length];
    if(textLenght > 0) {
        [self doTermSearch:searchText];
    } else {
        [self resetTable];
    }
}

- (void)searchBarchicked:(UISearchBar *) searchBar {
    NSLog(@"CANCELLL");
}


- (void) addTheFeeler {
   
    
    CanShareController *shareFeeler = [[[CanShareController alloc] initWithNibName:@"CanShareController" bundle:nil] autorelease];   
    shareFeeler.selectionDone = self.theSearchText;
    shareFeeler.feelerId = -1;
    shareFeeler.newFeeler = true;
    shareFeeler.dissmissVersion = YES;
    shareFeeler.cancelMode = YES;
    UINavigationController *myNavigationController = [[[UINavigationController alloc] initWithRootViewController:shareFeeler] autorelease];
    UINavigationBar *navBar = [myNavigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController presentModalViewController:myNavigationController animated:YES];    
}

#pragma pushSharing
- (void) pushSharingAuthenticationScreen:(id)sender {
    
    NSString *defaultShare = @"twitter";
    int theTag = ((UIButton *)sender).tag;
    if (theTag == 777) defaultShare = @"facebook";
    //Check if selected
    bool selection = ((UIButton *)sender).selected;
    
    if (((UIButton *)sender).selected) ((UIButton *)sender).selected = NO;
    else ((UIButton *)sender).selected = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"pop_display"];
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
            [self.knowledgeField resignFirstResponder];
            ShareAuthenticateController *theAuthentication = [[[ShareAuthenticateController alloc] initWithNibName:@"ShareAuthenticateController" bundle:nil] autorelease];
            theAuthentication.authenticate = defaultShare;
            [self.navigationController pushViewController:theAuthentication animated:YES];
        }
        
    } else { // do not post
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%@_btn" ,defaultShare]];
    }
}


- (void)insertTheFeeler:(id) theStatus {
    //submit the new answer   
    //NSDictionary *aDic = [[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:theStatus], @"status", @"599", @"feelerid", nil] autorelease];
    //NSNotification *theNot = [NSNotification notificationWithName:@"notify" object:self userInfo:aDic];
    //[self dataProvidingAnswers:theNot];
    RetrieveQuestionStats *statsRequest = [[[RetrieveQuestionStats alloc] init] autorelease];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(dataProvidingAnswers:)
                                                name:@"load_end" object:statsRequest];
    [statsRequest insertProvidingFeeler:self.feelerData status:theStatus];
}

#pragma mark - display subview methods


- (void) postedSuccessfullyFB:(UIView*) successView {
    [searchBar resignFirstResponder];
    [self.view addSubview:successView]; 
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    [successView setAlpha:1.0];    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    
    [self performSelector:@selector(alreadyFBPopRemove) withObject:nil afterDelay:2.5];
}


- (void) alreadyFBPopRemove{
    [[self.view viewWithTag:152637] setAlpha:1.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    
    [[self.view viewWithTag:152637] setAlpha:0.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    //[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"scanningfeeler"];
    [[self.view viewWithTag:152637] removeFromSuperview];
}


- (void) shareFriendsPop:(bool)logIn {
    [searchBar resignFirstResponder];
    UIControl *addInfoPop = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, self.navigationController.view.frame.size.height)] autorelease];
    addInfoPop.backgroundColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:0.5];
    addInfoPop.tag = 1728393;
    [self.navigationController.view addSubview:addInfoPop];
    
    UIView *addInfoImage = [[[UIView alloc] init] autorelease];
    
    if (logIn)addInfoImage.frame = CGRectMake(20,120, 280,288);
    else addInfoImage.frame = CGRectMake(20,120, 280,208);
    addInfoImage.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    addInfoImage.layer.cornerRadius = 6.0;
    [addInfoPop addSubview:addInfoImage];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (logIn) {
        [actionButton setFrame:CGRectMake(148, 230, 116, 41)];
        [actionButton setTitle:@"Log in" forState:UIControlStateNormal];
        [actionButton setBackgroundImage:[UIImage imageNamed:@"facebookBtn.png"] forState:UIControlStateNormal];
        [actionButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 25.0f, 0.0f, 0.0f)];
        [actionButton addTarget:self action:@selector(doFacebookConnect) forControlEvents:UIControlEventTouchUpInside]; 
    }
    else {
        [actionButton addTarget:self action:@selector(doFacebookInit) forControlEvents:UIControlEventTouchUpInside];
        [actionButton setFrame:CGRectMake(148, 150, 116, 41)];
        [actionButton setTitle:@"Tell a Friend" forState:UIControlStateNormal];
        [actionButton setBackgroundImage:[UIImage imageNamed:@"blueSelected.png"] forState:UIControlStateNormal];
    }
    actionButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19];
    [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addInfoImage addSubview:actionButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (logIn)[cancelButton setFrame:CGRectMake(16, 230, 116, 41)];
    else [cancelButton setFrame:CGRectMake(16, 150, 116, 41)];
    [cancelButton addTarget:self action:@selector(shareFriendsPopRemove) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Not now" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19];
    [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"greyBasic.png"] forState:UIControlStateNormal];
    [addInfoImage addSubview:cancelButton];
    
    
    UILabel *infoLabel = [[UILabel alloc] init];
    if (logIn) {
        infoLabel.frame = CGRectMake(15,10,250,210);
        infoLabel.text =  [NSString stringWithFormat:@"Log in with Facebook to discover more. \n\nWe use Facebook to make sure our users are real people. And we never post to your wall without your permission."];
    }else{
        infoLabel.frame = CGRectMake(15,10,250,130);
        infoLabel.text = [NSString stringWithFormat:@"Post Added!\n\nNow find answers faster with help from your friends."];
    }
    
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.numberOfLines = 0;
   	infoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
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




- (void) shareFriendsPopRemove {
   
    [[self.navigationController.view viewWithTag:1728393] removeFromSuperview];
    
}

#pragma mark - answer updating methods
- (void)dataProvidingAnswers:(NSNotification *) data {
    
    [HuntProfileHelper removeLoadingView:self.view];
    NSDictionary *resData = [data userInfo];
    int addAnswerId = [[resData objectForKey:@"feelerid"] intValue];
    int profileId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue];
    bool theStatus = [[resData objectForKey:@"status"] boolValue];
    NSMutableArray* providers = [[[NSMutableArray alloc] init] autorelease];
    //Add answer to meta-array
    NSMutableDictionary *newAnswer = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:addAnswerId], @"id", self.feelerData, @"URLEncodedAnswer", providers, @"providers", nil] autorelease];
    if (!theStatus){//is providing
        [providers addObject:[NSNumber numberWithInt:profileId]];
        [self.haveTooAnswers addObject:[NSNumber numberWithInt:addAnswerId]];        
    } else {//is looking
        [self.selectedAnswers addObject:[NSNumber numberWithInt:addAnswerId]];
        NSArray* images = [[[NSArray alloc] initWithObjects:@"Documents/profilePhotoPull.jpg", nil] autorelease];
        [newAnswer setObject:images forKey:@"follower_urls"];
        [newAnswer setObject:[NSNumber numberWithInt:1] forKey:@"learning"];
    }   
    
    //add the tableRow now
    NSMutableArray *rowArray = [[[NSMutableArray alloc] init] autorelease];
    [rowArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
   
    [self.changingAnswers insertObject:newAnswer atIndex:0];    
    
    NSUInteger iContentOffset = [self getCellWidth:self.tableView copy:self.feelerData].height + 85; //height of inserted rows
    
    [self.tableView setContentOffset:CGPointMake(0, iContentOffset)];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //resume hunt
    [self startHuntingNow];
}

#pragma mark - do Hunt mechanism
- (void) startHuntingNow {
    if ([self.selectedAnswers count] > 0 || [self.haveTooAnswers count] > 0) {
        NSString *activated = [[NSUserDefaults standardUserDefaults] objectForKey:@"hunt_activated"];
        iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (!activated) {
            //[appDelegate startHunting];
        }
        if (![appDelegate.protocol checkStreamStatus]) [appDelegate initProtocolCommunicationMainThread];
        //[appDelegate.protocol sendMessage:@"80:getliveusers"];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [changingAnswers count];
}


- (UITableViewCell *)tableView:(UITableView *) aTableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int theRow = [indexPath row];
    
    static NSString *CellIdentifier = @"FeedCell";
    HuntFeedCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HuntFeedCell"
                                                     owner:self options:nil];
        for (id oneObject in nib){
            if ([oneObject isKindOfClass:[HuntFeedCell class]]) {
                cell = (HuntFeedCell *)oneObject;
                cell.delegate = self;
                //add avatar image
                [cell setAvatarImage];                
            }
        }
    } else {
        [cell clearAllAvatars];
        cell.learners.text = @"";
        cell.ribbon.hidden = true;        
    }    
    
    //NSLog(@"CHANGING %@", self.changingAnswers);
    //[cell addAllAvatars:[[self.changingAnswers objectAtIndex:theRow] objectForKey:@"follower_urls"]];
    [cell clearTheBorders];
    cell.isTop = false;
   
    cell.tag = theRow;
    cell.huntButton.selected = false;
    [cell huntButtonStateFind:cell.huntButton];
    
    //normal providing buttom
    cell.addMeButton.selected = false;
    [cell.addMeButton setBackgroundImage:[UIImage imageNamed:@"knowUnpressed.png"] forState:UIControlStateNormal];
    //[cell.addMeButton setBackgroundImage:[UIImage imageNamed:@"pressed_photo_button.png"] forState:UIControlStateSelected | UIControlStateHighlighted];

    
    //retrieve the already retrieved answers
    int answerParentId = 0;
    if (theRow < [self.changingAnswers count]) {
        NSDictionary *theAnswer = [self.changingAnswers objectAtIndex:theRow];
        answerParentId = [[theAnswer objectForKey:@"id"] intValue];
    }
    
    //iterate over the selected hunt targets
    for (id theId in self.selectedAnswers) {
        if ([theId intValue] == answerParentId) {
            NSLog(@"Selected provide %i",[theId intValue]);
            cell.ribbon.hidden = false;
        }
    }
    
    
    if (answerParentId != 0){
        NSArray *providers = [[self.changingAnswers objectAtIndex:theRow] objectForKey:@"providers"];
        NSString* header = [NSString stringWithFormat:@"%i people know" , [providers count]];
        if ([providers count] == 1) header = @"1 person knows";
        cell.theHeaderText.text = header;
    }
    
    
    for (id theId in self.haveTooAnswers) {
        if ([theId intValue] == answerParentId) {
             NSLog(@"Selected want %i",[theId intValue]);
            cell.ribbon.hidden = false;
        }
    }
    

    cell.theText.text = [[self.changingAnswers objectAtIndex:theRow] objectForKey:@"URLEncodedAnswer"];
    int learnerCount = [[[self.changingAnswers objectAtIndex:theRow] objectForKey:@"learning"] intValue];
    NSString* footer = [NSString stringWithFormat:@"%i people are interested in" , learnerCount];
    if (learnerCount == 1) footer = @"1 person is interested in";
    cell.learners.text = footer;
    [cell setNeedsLayout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"]){
        NSDictionary *individualFeeler = [self.changingAnswers objectAtIndex:[indexPath row]];
        IndividualFeelerController *indController = [[[IndividualFeelerController alloc] initWithNibName:@"IndividualFeelerController" bundle:nil] autorelease];
        int feelerId = [[individualFeeler objectForKey:@"id"] intValue];
        self.lastSelectedFeelerId = [indexPath row];
        for (NSNumber* selectedId in self.haveTooAnswers) {//check if user knows this feeler
            if ([selectedId intValue] == feelerId){
                indController.knows = true;
                break;
            }
        }
    
        for (NSNumber* selectedId in self.selectedAnswers) {//check if user wants this feeler
            if ([selectedId intValue] == feelerId){
                indController.wants = true;
                break;
            }
        }
    
        indController.feelerData = individualFeeler;
        [self.navigationController pushViewController:indController animated:YES];
    } else {
        [self shareFriendsPop:TRUE];
    }
}


- (CGSize) getCellWidth:(UITableView *)theTableView copy:(NSString *)copy {
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    CGSize withinsize = CGSizeMake(284, 1000); //1000 is just a large number. could be 500 as well
    // You can choose a different Wrap Mode of your choice
    return [copy sizeWithFont:font constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap];
}


- (CGFloat)tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int theRow = [indexPath row];
    NSMutableString *feelerDescription = [[[[self.changingAnswers objectAtIndex:theRow] objectForKey:@"URLEncodedAnswer"] mutableCopy] autorelease];
    NSString *copy = [[StringEscapeUtil xmlSimpleEscape:feelerDescription] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    CGSize sz = [self getCellWidth:theTableView copy:copy];
    
	return sz.height +46;
}


- (void) closeSelection {
    [[self.navigationController.view viewWithTag:888] removeFromSuperview];
}


- (void) doFastHunting {
    NSLog(@"FASTHUNTING");
}


- (void) updateData {
    if (isLoading) {        
        self.segmentDownload = 0;       
        [self.feelerDataArray removeAllObjects];
        [self.selectedAnswers removeAllObjects];
        [self.haveTooAnswers removeAllObjects];
    }
    if (self.segmentDownload == 0)[HuntProfileHelper addLoadingView:self.view];
    PeopleHuntRequests *request2 = [[[PeopleHuntRequests alloc] init] autorelease];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updateHaveData:)
                                                 name:@"load_end" object:request2];
    
    [request2 retrieveMyFeelerData:1 + self.segmentDownload];
}



#pragma AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickedButtonAtIndex");
    if (alertView.tag == 23468831){
        if (buttonIndex == 0){//add facebook friends
            [alertView dismissWithClickedButtonIndex:-1 animated:YES];
            [self performSelector:@selector(doFacebookInit) withObject:self afterDelay:0.5];
        }
    }
    
    if (alertView.tag == 33){
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
    }
    
    if (alertView.tag == 20 || alertView.tag == 32) {
        //[self cantFindClose];
        [alertView dismissWithClickedButtonIndex:-1 animated:YES];
        [protocol closeNetworkCommunication];
    }
    
    if (alertView.tag == 30){
        if (buttonIndex == 1) {
            [HuntProfileHelper addHasBeenSentMessage:self.navigationController.view];
            [protocol sendMessage:[NSString stringWithFormat:@"31:%@:%@",self.matchedUsername, [self.foundData objectForKey:@"matchingMessage"]]];
            
        } else {
            //[self cantFindClose];
            [protocol sendMessage:[NSString stringWithFormat:@"32:%@:%@",self.matchedUsername, [self.foundData objectForKey:@"matchingMessage"]]];
            [protocol closeNetworkCommunication];
            
        }
        [alertView dismissWithClickedButtonIndex:-1 animated:YES];
    }
}

#pragma - mark facebook methods

- (void)callFacebookPermissions {
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFacebookSharing) name:FBSessionStateChangedNotification object:nil];
    [appDelegate openSessionWithAllowLoginUI:YES];
}

- (void) doFacebookInit {
    [[self.navigationController.view viewWithTag:1728393] removeFromSuperview];
    //check if they have any friends
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"all_friends"]){
        HuntProfileHelper *helper = [HuntProfileHelper new];
        helper.delegate = self;
        [helper retrieveFriends];
        return;
    }
    
    [self callFacebookPermissions];
}

- (void) facebookActionDone {
    [[self.view viewWithTag:9876510] removeFromSuperview];
    [[self.navigationController.view viewWithTag:1728393] removeFromSuperview];
    [self callFacebookPermissions];
}

- (void) showFacebookSharing {
  
    
    FacebookActionSharing *sharing = [[[FacebookActionSharing alloc] initWithNibName:@"FacebookActionSharing" bundle:nil] autorelease];
    sharing.theMessage = [NSString stringWithFormat:@"Anyone able to help me with %@? ", self.feelerData];
    sharing.selectedFeeler = self.feelerData;
    sharing.classType = [HuntFeedController class];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sharing];
    UINavigationBar *navBar = [navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    //now present this navigation controller as modally
    [self presentModalViewController:navigationController  animated:YES];
}

- (void) doFacebookConnect {
    [[self.view viewWithTag:1728393] removeFromSuperview];
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
                              [[self.navigationController.view viewWithTag:1728393] removeFromSuperview];
                              if (error) {
                                  NSLog(@"Error: %@", error);
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
                                          if (self.lastSelectedFeelerId > 0) {
                                              NSDictionary *individualFeeler = [self.changingAnswers objectAtIndex:self.lastSelectedFeelerId];
                                              IndividualFeelerController *ind = [[[IndividualFeelerController alloc] initWithNibName:@"IndividualFeelerController" bundle:nil] autorelease];
                                              ind.feelerData = individualFeeler;
                                              [self.navigationController pushViewController:ind animated:YES];
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
    
    NSLog(@"PROFILE ID %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"]);
    bool displayAddPop = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pop_display"] boolValue];
    UIButton *facebookBtn = (UIButton *)[self.navigationController.view viewWithTag:777];
    UIButton *twitterBtn = (UIButton *)[self.navigationController.view viewWithTag:333];
    if (displayAddPop) {
        [self.navigationController.view viewWithTag:888].hidden = false;
        [self.knowledgeField becomeFirstResponder];
        facebookBtn.selected = false;
        twitterBtn.selected = false;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_btn"] boolValue]) facebookBtn.selected = true;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_btn"] boolValue]) twitterBtn.selected = true;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"pop_display"];        
    }
    
    if (updateDataFeeler) {
        self.updateDataFeeler = false;
        [self updateData];
    }
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    //check the rightBarItem and edit it
    UIBarButtonItem *rightItem = self.navigationItem.rightBarButtonItem;
    UIButton *rightButton = nil;
    if (rightItem == nil){
        rightButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 41)] autorelease];
        [rightButton setImage:[UIImage imageNamed:@"topRightChat.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"topRightPressed.png"] forState:UIControlStateHighlighted];
        [rightButton setImage:[UIImage imageNamed:@"topRightPressed.png"] forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(goConnections) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *favorite = [[[UIBarButtonItem alloc] initWithCustomView:rightButton] autorelease];
        self.navigationItem.rightBarButtonItem = favorite;
    } else {        
        UIButton *theButton = (UIButton *)rightItem.customView;
        [theButton setImage:[UIImage imageNamed:@"topRightChat.png"] forState:UIControlStateNormal];
        [theButton setImage:[UIImage imageNamed:@"topRightPressed.png"] forState:UIControlStateHighlighted];
        [theButton setImage:[UIImage imageNamed:@"topRightPressed.png"] forState:UIControlStateSelected];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [theSearchText release];
    [feelerDataArray release];
    [searchBar release];
    [feelerData release];
    [location release];
    [bundleName release];
    [tempInserts release];
    [theMatch release];
    [characterImageAddExperience release];
    [matcherRequest release];
    [changingAnswers release];
    [knowledgeField release];
    [parentAnswers release];
    [foundData release];
    [matchedUsername release];
    [haveTooAnswers release];
    [selectedAnswers release];
    [huntHelper release];
    
    [super dealloc];
}

@end
