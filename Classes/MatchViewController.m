//
//  MatchViewController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 01/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "MatchViewController.h"
#import "ChatCell.h"
#import "AvatarImageView.h"
#import "LocationImageView.h"
#import "HuntProfileHelper.h"
#import "iphoneCrowdAppDelegate.h"
#import "HuntFeedController.h"
#import "MetaMatcher.h"

#import <QuartzCore/QuartzCore.h>

@interface MatchViewController ()

@end

@implementation MatchViewController
@synthesize theData, chatLines, inputChatField, chatBar, foundData, matchedUsername, characterImageAddExperience;
@synthesize protocol, storedOffset, allData, theOtherUrl, location, myMapView, iHaveSharedLocation, theyHaveSharedLocation;
@synthesize theirSharedLocation, recycleMatch;


- (void)viewDidLoad {    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIButton *Button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 41)] autorelease];
    [Button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [Button setImage:[UIImage imageNamed:@"closePressed.png"] forState:UIControlStateHighlighted];
    [Button setImage:[UIImage imageNamed:@"closePressed.png"] forState:UIControlStateSelected];
    [Button addTarget:self action:@selector(cantMeetNow) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView:Button] autorelease];
    self.navigationItem.rightBarButtonItem = backButton;
    self.navigationItem.hidesBackButton = YES;
    
    self.chatLines = [[[NSMutableArray alloc] init] autorelease];   
   
    inputChatField.delegate = self;
    inputChatField.placeholder = @"Chat to stop timer!";
    inputChatField.clearButtonMode = UITextFieldViewModeAlways;
    iHaveSharedLocation = false;
    theyHaveSharedLocation = false;
    recycleMatch = true;
   
    
    [self displayMatch];
}

- (void)releaseKeyboard {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationDelegate:self];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        chatBar.frame = CGRectMake(0, 462, 320, 44);
    } else {
        chatBar.frame = CGRectMake(0, 373, 320, 44);
    }
    
    theTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.chatLines count] > 0) {
        [theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatLines count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } 
    [UIView commitAnimations];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self releaseKeyboard];    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {    

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationDelegate:self];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        chatBar.frame = CGRectMake(0, 246, 320, 44);
        theTableView.contentInset = UIEdgeInsetsMake(0, 0, theTableView.frame.size.height - 246, 0);
    } else {
        chatBar.frame = CGRectMake(0, 156, 320, 44);
        theTableView.contentInset = UIEdgeInsetsMake(0, 0, theTableView.frame.size.height - 156, 0);
    }   
    
    if ([self.chatLines count] > 0) {
        [theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatLines count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else {
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            [theTableView scrollRectToVisible:CGRectMake(0, theTableView.frame.size.height - 755, 320, theTableView.frame.size.height) animated:YES];
        } else {
            [theTableView scrollRectToVisible:CGRectMake(0, theTableView.frame.size.height -436, 320, theTableView.frame.size.height) animated:YES];
        }
    }
    [UIView commitAnimations];
}


- (void) displayMatch {
    
    self.foundData = [allData objectForKey:@"1"];
    NSLog(@"MATCH RES %@", self.foundData);
    
    self.theOtherUrl = [[allData objectForKey:@"1"] objectForKey:@"url"];
    self.matchedUsername = [[allData objectForKey:@"1"] objectForKey:@"username"];
    NSString *theName2 = [[allData objectForKey:@"1"] objectForKey:@"name"];
    
    [self initProtocolCommunicationMainThread];
    
    //Flag to know that a match has been found for later email recovery
    [[NSUserDefaults standardUserDefaults] setObject:@"found" forKey:@"found_match"];    
    
    //Update the number of active players   
    //Cancel perfom
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    
    //Grey screen holding chat
    UIControl *modalView = [[[UIControl alloc] initWithFrame:CGRectMake(0, 5, 320, 403)] autorelease];
    modalView.tag = 65;
    modalView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    modalView.layer.cornerRadius = 0.0;
    [modalView addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];    
    
    
    //white screen holding match data
    UIControl *matchView = [[[UIControl alloc] initWithFrame:CGRectMake(8, 7, 304, 398)] autorelease];
    matchView.backgroundColor = [UIColor whiteColor];
    matchView.tag = 244;
    matchView.layer.borderWidth = 1.0;
    matchView.layer.cornerRadius = 2.0;
    matchView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1].CGColor;
    [matchView addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];
    [modalView addSubview:matchView];    
    
    
    UILabel *peopleMatchedTitle = [[[UILabel alloc] initWithFrame:CGRectMake(46,18, 252, 30)] autorelease];
    peopleMatchedTitle.backgroundColor = [UIColor clearColor];
    peopleMatchedTitle.lineBreakMode = UILineBreakModeWordWrap;
    peopleMatchedTitle.numberOfLines = 0;
    peopleMatchedTitle.textColor = [UIColor blackColor];
    peopleMatchedTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    peopleMatchedTitle.textAlignment = UITextAlignmentLeft;
    peopleMatchedTitle.layer.shadowColor = [UIColor whiteColor].CGColor;
    peopleMatchedTitle.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    peopleMatchedTitle.text = [NSString stringWithFormat:@"Hold up - incoming connection:"];
    [matchView addSubview:peopleMatchedTitle];
    
    
    UIImageView *blueLine = [[[UIImageView alloc] initWithFrame:CGRectMake(46, 42, 242, 5)]autorelease];
    blueLine.image = [UIImage imageNamed:@"line_blue.png"];
    [matchView addSubview:blueLine];
    
    
    //myProfileImage
    NSString *photoPath = @"Documents/profilePhotoPull.jpg";
    NSString *thePath = [NSHomeDirectory() stringByAppendingPathComponent:photoPath];
    UIImage *theProfileImage = [UIImage imageWithContentsOfFile:thePath];
    self.characterImageAddExperience = [[[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 33, 33)] autorelease];
    self.characterImageAddExperience.image = theProfileImage;
    [matchView addSubview:self.characterImageAddExperience];    
    
    
    UIImageView *liveImageSmall = [[[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 33, 39)]autorelease];
    liveImageSmall.image = [UIImage imageNamed:@"live_small.png"];
    [matchView addSubview:liveImageSmall];
    
    
    //TheirProfileImage - distance between this and above - 11
    AvatarImageView *asyncImageView = [[[AvatarImageView alloc] initWithFrame:CGRectMake(7,57, 99, 99)] autorelease];
    asyncImageView.userInteractionEnabled = NO;
    asyncImageView.tag = 12;
    asyncImageView.displayUImage = true;
    [matchView addSubview:asyncImageView];    
    
    [asyncImageView loadImageFromURL:[NSURL URLWithString:self.theOtherUrl] theImageFrame:CGRectMake(0,0, 99, 99)];
    
    
    UIImageView *liveImage = [[[UIImageView alloc] initWithFrame:CGRectMake(7,57, 99, 111)] autorelease];
    liveImage.image = [UIImage imageNamed:@"live_big.png"];
    [matchView addSubview:liveImage];
    
    
    UILabel *huntForName = [[[UILabel alloc] initWithFrame:CGRectMake(113,57, 185, 22)] autorelease];
    huntForName.backgroundColor = [UIColor clearColor];
    huntForName.lineBreakMode = UILineBreakModeWordWrap;
    huntForName.numberOfLines = 0;
    huntForName.textColor = [UIColor blackColor];
    huntForName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    huntForName.textAlignment = UITextAlignmentLeft;
    huntForName.text = [NSString stringWithFormat:@"%@",theName2];
    [matchView addSubview:huntForName];    
    
    UITextView *helpContent = [[[UITextView alloc] initWithFrame:CGRectMake(113, 82, 185, 85)] autorelease];
    helpContent.backgroundColor = [UIColor clearColor];
    helpContent.textColor = [UIColor blackColor];
    helpContent.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    helpContent.textAlignment = UITextAlignmentLeft;
    helpContent.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
    helpContent.editable = NO;
    //[helpContent sizeToFit];  
    
    NSArray *stuffInCommon = [[self.foundData objectForKey:@"thingsInCommon"] objectForKey:@"common"];
    
    bool providingStatus = [[self.foundData objectForKey:@"aProvider"] boolValue];
    if (providingStatus) {
        helpContent.text = [NSString stringWithFormat:@"Ask %@ %@", theName2, [stuffInCommon componentsJoinedByString:@","]];
    } else {
        helpContent.text = [NSString stringWithFormat:@"%@ wants %@", theName2, [stuffInCommon componentsJoinedByString:@","]];
    }
    
    [matchView addSubview:helpContent];
    
    //get the groups in common
    NSString *allGroups = [[[self.foundData objectForKey:@"groupsInCommon"] allValues] componentsJoinedByString:@"  |  "];
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    CGSize withinsize = CGSizeMake(100000, 20); //10
	CGSize sz = [allGroups sizeWithFont:font constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap];
    
    if (sz.width<300) {
        sz.width = 300;
    }
    
    UILabel *groupsContent = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, sz.width, 20)] autorelease];
    groupsContent.lineBreakMode = UILineBreakModeWordWrap;
    groupsContent.numberOfLines = 0;
    groupsContent.backgroundColor = [UIColor clearColor];
    groupsContent.textColor = [UIColor colorWithRed:95.0/255.0 green:104.0/255.0 blue:115.0/255.0 alpha:1.0];
    groupsContent.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    groupsContent.textAlignment = UITextAlignmentCenter;
    groupsContent.text = [NSString stringWithFormat:@"Groups in common: %@", allGroups];
    [matchView addSubview:groupsContent];
    //[NSString stringWithFormat:@"%@", allGroups];
    
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 173,304, 20)];
    scrollView.contentSize=CGSizeMake(groupsContent.frame.size.width,20);
    scrollView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    scrollView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1].CGColor;
    scrollView.layer.borderWidth = 1.0;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView addSubview:groupsContent];
    [matchView addSubview:scrollView];
    
    [scrollView release];
    
    UILabel *timerCountdown = [[[UILabel alloc] initWithFrame:CGRectMake(18,196, 268, 42)] autorelease];
    timerCountdown.tag = 654;
    timerCountdown.lineBreakMode = UILineBreakModeWordWrap;
    timerCountdown.numberOfLines = 0;
    timerCountdown.backgroundColor = [UIColor clearColor];
    timerCountdown.textColor = [UIColor blackColor];
    timerCountdown.font = [UIFont fontWithName:@"Helvetica" size:35.0];
    timerCountdown.textAlignment = UITextAlignmentCenter;
    timerCountdown.text = [NSString stringWithFormat:@"30:00"];
    [matchView addSubview:timerCountdown];
    
    UILabel *chatSaveLabel = [[[UILabel alloc] initWithFrame:CGRectMake(18,232, 268, 32)] autorelease];
    chatSaveLabel.lineBreakMode = UILineBreakModeWordWrap;
    chatSaveLabel.numberOfLines = 0;
    chatSaveLabel.backgroundColor = [UIColor clearColor];
    chatSaveLabel.textColor = [UIColor blackColor];
    chatSaveLabel.font = [UIFont fontWithName:@"HoeflerText-Italic" size:14.0];
    chatSaveLabel.textAlignment = UITextAlignmentCenter;
    chatSaveLabel.text = [NSString stringWithFormat:@"chat or share location to stop the timer"];
    [matchView addSubview:chatSaveLabel];
    
    theTimer = nil;
    theTimer = [[[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES] retain] autorelease];
    
    //Add the share location piece
    //Map First
    self.myMapView = [[[MKMapView alloc] initWithFrame:CGRectMake(13, 269, 278, 116)] autorelease];
    self.myMapView.delegate = self;
    self.myMapView.hidden = true;
    self.myMapView.layer.cornerRadius = 6.0;
    self.myMapView.layer.borderWidth = 1.0;
    self.myMapView.layer.borderColor = [UIColor colorWithRed:175/255.0 green:181/255.0 blue:189/255.0 alpha:1].CGColor;
    CLLocationCoordinate2D centerCoord = {40.727425, -74.005712};
    [self.myMapView setCenterCoordinate:centerCoord animated:YES];
    [matchView addSubview:self.myMapView];
    
    //Add the share location button now
    UIButton *shareLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    shareLocation.tag = 919;
    [shareLocation setFrame:CGRectMake(9, 266, 286, 118)];
    [shareLocation setBackgroundImage:[UIImage imageNamed:@"shareLocation.png"] forState:UIControlStateNormal];
    [shareLocation addTarget:self action:@selector(shareMyMapLocation:) forControlEvents:UIControlEventTouchUpInside];
    [matchView addSubview:shareLocation];    
   
    theTableView.tableHeaderView = modalView;
    [theTableView.tableHeaderView setUserInteractionEnabled:YES];
}


- (void) updateTimer {
    
    UILabel *countLabel = (UILabel *)[self.navigationController.view viewWithTag:654];
    int countLabelNum = [countLabel.text intValue] - 1;
    if (countLabelNum == 0){
        [theTimer invalidate];
        theTimer = nil;
        if (recycleMatch){
            if (protocol != nil){
                [protocol sendMessage:[NSString stringWithFormat:@"20:%@:%@",self.matchedUsername, @"has ended the connection"]];
                [protocol closeNetworkCommunication];
            }
            [self closeViews];           
        }
    }
    
    countLabel.text = [NSString stringWithFormat:@"%i:00", countLabelNum];
}


- (void)addNewRow: (NSDictionary *) myChatResponse {
    
    NSMutableArray *rowArray = [[[NSMutableArray alloc] init] autorelease];
    int initCount = [chatLines count];
    //NSLog(@"COIUNT %@", chatLines);
    [rowArray addObject:[NSIndexPath indexPathForRow:initCount inSection:0]];
    [chatLines addObject:myChatResponse];
    
    [theTableView beginUpdates];
    [theTableView insertRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationFade];
    [theTableView endUpdates];
    initCount = [chatLines count] - 1;
    
    [theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:initCount inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}



#pragma mark - SOCKETS
- (void)initProtocolCommunication {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // Top-level pool
    //Open Socket connection
    [self performSelectorOnMainThread:@selector(initProtocolCommunicationMainThread) withObject:nil waitUntilDone:NO];
    [pool release];
}



- (void) initProtocolCommunicationMainThread {
    
    if (protocol == nil){
        protocol = [[[ProtocolCommunication alloc] init] retain];
        protocol.delegate = self;
        
    }
    
    [protocol initNetworkCommunication];    
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    
    [protocol sendMessage:[NSString stringWithFormat:@"1:%@:%@", username, [[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"]]];

       
    //add found target
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [req addFoundTarget:3033 collectedUser:self.matchedUsername];
    
}

- (void) tryAgain:(NSTimer *)timer {

    NSDictionary *data = [timer userInfo];
    [protocol sendMessage:[NSString stringWithFormat:@"%i:%@", [[data objectForKey:@"key"] intValue], [data objectForKey:@"data"]]];   

}



- (void) serverResponse:(NSString *)response {
   
    NSArray *responses = [response componentsSeparatedByString:@":"];
    int code = [[responses objectAtIndex:0] intValue];
    NSDictionary *chatResponse = nil;
    NSString *content = nil;
    switch (code) {            
        case 1:
            [NSNotification notificationWithName:@"user_added" object:self];
            break;
        case 50:
            //if he has shared his location and I haven't display chat
            [NSNotification notificationWithName:@"location_sent" object:self];
            theyHaveSharedLocation = true;
            self.theirSharedLocation = [responses objectAtIndex:2];
            if (!iHaveSharedLocation){
                chatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:[responses objectAtIndex:1], @"name", @"I just shared my location. Share yours to see mine", @"content", @"other", @"image_type", nil] autorelease];
            } else {
                //otherwise display the map
                [self postTheMap:self.theirSharedLocation];
            }
            break;
        case 40:                     
            content = [[responses objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([content isEqualToString:@"error"]) {
                chatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:[responses objectAtIndex:1], @"name", @"Oops. the message was not delivered but will be stored in his/her inbox", @"content", @"other", @"image_type", nil] autorelease];
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
            } else {
                 [protocol sendMessage:[NSString stringWithFormat:@"101:%@:%i", self.matchedUsername, [[responses objectAtIndex:3] intValue]]];
                chatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:[responses objectAtIndex:1], @"name", content, @"content", @"other", @"image_type", nil] autorelease];
            }
            break;
        case 20:
            NSLog(@"%@",[responses objectAtIndex:1]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:[responses objectAtIndex:1] delegate:self
												  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert.tag = 20;
            [alert show];
            [alert release];
            break;
        case 101:
            [self chatConfirmed:[[responses objectAtIndex:1] intValue]];          
            break;
        default:
            break;
            
    }
   
    //add the tableRow now
    if (chatResponse != nil){
        [self addNewRow:chatResponse];
        
    }
}



- (IBAction) sendChatMessage {
    
     //Stop the timer
    [theTimer invalidate];
    theTimer = nil;
    
    if (theTableView.tableFooterView == nil){
        UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(20,2,280,16)] autorelease];
        
        UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,11,280,12)] autorelease];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
        infoLabel.lineBreakMode = UILineBreakModeWordWrap;
        infoLabel.textAlignment = UITextAlignmentCenter;
        infoLabel.numberOfLines = 0;
        infoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        infoLabel.text = [NSString stringWithFormat:@"Heads up: your chat messages aren't being stored"];
        [footerView addSubview:infoLabel];
        
        theTableView.tableFooterView = footerView;
    
    }
    
    if (self.inputChatField.text.length > 0){
        recycleMatch = false;
        //send the message to protocol
        NSDictionary *myChatResponse = nil;
        if ([protocol checkStreamStatus]) {            
            NSString *msgProt = [NSString stringWithFormat:@"40:%@:%@:%i", self.matchedUsername, self.inputChatField.text, [chatLines count] + 1];
            NSLog(@"MESSAGE TO SEND %@", msgProt);
            [protocol sendMessage:msgProt];
            [self performSelector:@selector(onRequestTimeout:) withObject:[NSNumber numberWithInt:[chatLines count] + 1] afterDelay:5.0]; // 5 secs
            
            NSString *fullName = @"Adrian";
            myChatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:fullName, @"name", self.inputChatField.text, @"content", @"mine", @"image_type", nil] autorelease];
            
        } else {
            NSString *fullName = @"Adrian";
            myChatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:fullName, @"name", [NSString stringWithFormat:@"Connection Error! Could not sent the message: %@", self.inputChatField.text], @"content", @"mine", @"image_type", nil] autorelease];
        }
        
        //add it to the cell
        [self addNewRow:myChatResponse];        
        self.inputChatField.text = @"";
        
    } else {
        self.inputChatField.placeholder = @"You didn't sent any text!";
    }    
}

- (void) onRequestTimeout:(NSNumber *) code {
    NSLog(@"REQUEST TIME OUT %i", [code intValue]);
    NSString *chatLine = [[self.chatLines objectAtIndex:[code intValue] - 1] objectForKey:@"content"];
    NSDictionary *myChatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:@"Adrian", @"name", [NSString stringWithFormat:@"Seems like %@ is offline. The message %@ will be delivered.", [self.foundData objectForKey:@"name"], chatLine], @"content", @"mine", @"image_type", nil] autorelease];
    [self addNewRow:myChatResponse];
}


- (void) chatConfirmed:(int) data {
    NSLog(@"RECEIVED %i", data);    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onRequestTimeout:) object:[NSNumber numberWithInt:data]];

}

- (void) cantMeetNow {
    [self closeViews];        
}

- (void) locationWarningPop{

    iHaveSharedLocation = false;
    UIView *locationWarningPop = [[[UIView alloc] initWithFrame:CGRectMake(20, 10, 281, 197)] autorelease];
    locationWarningPop.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noFeelerPop.png"]];
    locationWarningPop.tag = 808714;
    [self.view  addSubview:locationWarningPop];
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,11,261,115)] autorelease];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:1];
    infoLabel.lineBreakMode = UILineBreakModeWordWrap;
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

- (void) removeLocationWarning{
    [[self.view viewWithTag:808714] removeFromSuperview];
}

/*
- (void) cantMeetNowRemoveForever: (id) sender {
    
    if (((UIButton *)sender).selected) {//don't show again
        ((UIButton *)sender).selected = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"dontshowwarningagain"];
        [(UIButton *)sender setBackgroundImage:[UIImage imageNamed:@"metoo.png"] forState:UIControlStateNormal];
        
    } else {//show again
        ((UIButton *)sender).selected = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"dontshowwarningagain"];
       
         [(UIButton *)sender setBackgroundImage:[UIImage imageNamed:@"metooBlue.png"] forState:UIControlStateSelected];
        
    }
    
}*/

#pragma AlertView
- (void)closeNetwork {
    if (protocol != nil){
        [protocol sendMessage:[NSString stringWithFormat:@"20:%@:%@",self.matchedUsername, @"has left the chat"]];
        [protocol closeNetworkCommunication];
    }
}

- (void)closeViews {
    
    [self closeNetwork];    
   
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!recycleMatch){
        [appDelegate displayAccessScreen:[self.foundData objectForKey:@"name"] otherUsername:self.matchedUsername];
        
    } else {
        [appDelegate startHunting];
    }
}

#pragma mark - Map methods
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {    
  
    MKAnnotationView *annotationViewOne = [views objectAtIndex:1];
    MKAnnotationView *annotationViewTwo = [views objectAtIndex:0];
    CLLocationCoordinate2D userCoordinateOne = [[annotationViewOne annotation] coordinate];
    CLLocationCoordinate2D userCoordinateTwo = [[annotationViewTwo annotation] coordinate];
    
    
    MKCoordinateRegion region;
    region.center.latitude = userCoordinateOne.latitude - (userCoordinateOne.latitude - userCoordinateTwo.latitude) * 0.5;
    region.center.longitude = userCoordinateOne.longitude + (userCoordinateTwo.longitude - userCoordinateOne.longitude) * 0.5;
    region.span.latitudeDelta = fabs(userCoordinateOne.latitude - userCoordinateTwo.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(userCoordinateTwo.longitude - userCoordinateOne.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mv regionThatFits:region];
    [mv setRegion:region animated:YES];    
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

}

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
    [self.view viewWithTag:919].hidden = true;
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSDictionary *theDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_location"];  
    [protocol sendMessage:[NSString stringWithFormat:@"50:%@:%@", self.matchedUsername, [NSString stringWithFormat:@"%@,%@", [theDic objectForKey:@"latitude"], [theDic objectForKey:@"longitude"]]]];   
   
}

- (void) shareMyMapLocation:(id) sender {
    
     
    //stop the timer
    [theTimer invalidate];
    theTimer = nil;
    
    UIButton *theButton = ((UIButton *)sender);   
    recycleMatch = false; 
   
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"location_ready" object:theDelegate queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        iHaveSharedLocation = true;
        if (theyHaveSharedLocation) {
            theButton.hidden = true;
            self.myMapView.hidden = false;
            [self postTheMap:self.theirSharedLocation];
            
        } else {
            [theButton setImage:[UIImage imageNamed:@"shareLocationDone.png"] forState:UIControlStateNormal];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSDictionary *theDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_location"];     
        [protocol sendMessage:[NSString stringWithFormat:@"50:%@:%@", self.matchedUsername, [NSString stringWithFormat:@"%@,%@", [theDic objectForKey:@"latitude"], [theDic objectForKey:@"longitude"]]]];
    }];
    
    //location_fail
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(locationWarningPop)
                                                 name:@"location_fail" object:theDelegate];
	[theDelegate startGeolocation];
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
    return [chatLines count];
}

- (UITableViewCell *)tableView:(UITableView *) aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ChatCell";
    
    ChatCell *cell = (ChatCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *cellContent = [self.chatLines objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        for (id oneObject in nib){
            cell = (ChatCell *)oneObject;
            [cell setBackgroundShadow];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
        cell.tag = 99;       
        if ([[cellContent objectForKey:@"image_type"] isEqualToString:@"mine"]){
            [cell setOwnerPhoto];
                
        } else {
            [cell setOtherPhoto:self.theOtherUrl];
            cell.tag = 88;
        }     

    } else {       
        
        if (cell.tag == 88 && [[cellContent objectForKey:@"image_type"] isEqualToString:@"mine"]){
            NSLog(@"Change owner");
            cell.photoChat.image = nil;
           [cell setOwnerPhoto];
            cell.tag = 99;
            
        } else if (cell.tag == 99 && [[cellContent objectForKey:@"image_type"] isEqualToString:@"other"]) {
            cell.photoChat.image = nil;
            [cell setOtherPhoto:self.theOtherUrl];
            cell.tag = 88;
            NSLog(@"Change other other");
            
        }
    }
    
    // Set up the cell...
    NSLog(@"TAGG %i current row %i", cell.tag, [indexPath row]);
    cell.theChatMessage.text = [cellContent objectForKey:@"content"];
    [cell setNeedsLayout];
   
    return cell;
}

- (CGSize) getCellWidth:(UITableView *)aTableView copy:(NSString *)copy {
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    CGSize withinsize = CGSizeMake(aTableView.frame.size.width - 84, 2000); //1000 is just a large number. could be 500 as well
    // You can choose a different Wrap Mode of your choice   
    
    return [copy sizeWithFont:font constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap];
}


- (CGFloat)tableView:(UITableView *) aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int theRow = [indexPath row];
    NSString *copy = [[self.chatLines objectAtIndex:theRow] objectForKey:@"content"];
    CGSize sz = [self getCellWidth:aTableView copy:copy];
    //you need to use size to fit to make the label wrap correctly, but it needs to be constrained to the top or bottom using the struts, without any inner expansion in nib.
    //Or - if it causes funky behaviour, instead you can use setneedslayout of the cell, and in the cell, you calculate the frame again, and in the nib, position the uilabel at the very top of the cell and it will expand to fill it
    float heightCell = sz.height;
    if (heightCell<60) heightCell = 60;
    if (heightCell>60) heightCell = heightCell + 16;
    //if (theRow == 0) heightCell = 5.0;
    
	return heightCell;
}


- (void) viewWillAppear:(BOOL)animated {
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [theDelegate cancelHunting];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {   
    [self releaseKeyboard];
    [self dismissKeyboard];
}


- (void) dismissKeyboard { 
    [self.inputChatField resignFirstResponder];
}

- (void)dealloc {
    [theirSharedLocation release];
    [myMapView release];
    [location release];
    [theOtherUrl release];
    [allData release];
    [protocol release];
    [foundData release];
    [matchedUsername release];
    [characterImageAddExperience release];
    [chatBar release];
    [inputChatField release];
    [chatLines release];
    [theData release];
    [theTableView release];
    [super dealloc];
}

@end
