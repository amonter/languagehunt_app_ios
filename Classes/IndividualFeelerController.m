//
//  IndividualFeelerController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 19/12/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "IndividualFeelerController.h"
#import "RetrieveQuestionStats.h"
#import "AvatarImageView.h"
#import "ProfileFlipController.h"
#import "HuntFeedCell.h"
#import <QuartzCore/QuartzCore.h>
#import "StringEscapeUtil.h"
#import "AsynchMessageController.h"
#import "iphoneCrowdAppDelegate.h"
#import "FacebookActionSharing.h"
//#import "Mixpanel.h"
#import "HuntFeedController.h"
#import "MainCardController.h"
#import "PlanningView.h"

@interface IndividualFeelerController ()


@end

@implementation IndividualFeelerController
@synthesize feelerData, backgroundIndividual, centerTextView, theText, flipView, buttonsView, topWhiteBG, theScrollView;
@synthesize knows, wants, knowBtn, knowLbl, wantBtn, wantLbl, knowers, wanters, reloadBack;
@synthesize profileHelper, interestedLbl, interestedLbl2, middleCard, bottomCard;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tag = 8811882;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonTapped)];
    backButton.tintColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:239.0/255.0 alpha:1.0];
    [backButton setBackgroundVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = backButton;
    //retrieving size for text of matched criteria
  
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    
    UIImageView *orangeBack;
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        orangeBack = [[UIImageView alloc] initWithFrame:CGRectMake(16.75, 10, 264, 75.5)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 472)];
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 500, 297.5, 28)];
        
    }else{
        orangeBack = [[UIImageView alloc] initWithFrame:CGRectMake(16.75, 10, 264, 75.5)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 384)];
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 412, 297.5, 28)];
        
    }
    
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    bottomCard.image = [UIImage imageNamed:@"cardback_bottom.png"];
    orangeBack.image = [UIImage imageNamed:@"orangeIndiv.png"];

    
    NSMutableString *feeler = [[[feelerData objectForKey:@"URLEncodedAnswer"] mutableCopy] autorelease];
    theText.text = [StringEscapeUtil urlDecoder:feeler];
    theText.font = [UIFont fontWithName:@"Delicious-Heavy" size:18.0];
   
    
    //setting centertextview
    centerTextView.backgroundColor = [UIColor clearColor];
    CGRect theButtonsPosition = buttonsView.frame;
    theButtonsPosition.origin.y = self.view.frame.size.height -41;
    self.buttonsView.frame = theButtonsPosition;
     
    //Create json structure retrieve data
    NSError *error = NULL;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:feelerData options:NSJSONReadingAllowFragments error:&error];
    NSString *theResult = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];    
    //REquest
    RetrieveQuestionStats *statsRequest = [[[RetrieveQuestionStats alloc] init] autorelease];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showFeelerData:)
                                                 name:@"load_end" object:statsRequest];
    
    [statsRequest getIndividualFeelerData:theResult];
    
    
    [self.view addSubview:topCard];
    [self.view addSubview:middleCard];
    [self.view addSubview:bottomCard];
    [middleCard addSubview:orangeBack];
    [middleCard addSubview:centerTextView];
    [orangeBack addSubview:interestedLbl];
    [orangeBack addSubview:interestedLbl2];
    //add buttons
    //Add feeler buttons
    CGRect help = CGRectMake(40, 419, 122, 41);
    CGRect interested = CGRectMake(200, 419, 122, 41);
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        //limitValue = 354;
        //substract = 300;
    }
      
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    
  
    
}

- (void) backButtonTapped {
    if (reloadBack){
        iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];        
        NSArray *controllers = theDelegate.navigationController.viewControllers;       
        for (UIViewController *controller in controllers) {
            NSLog(@"controller %@", controller);
            if ([controller isKindOfClass:[MainCardController class]]) {
                [((MainCardController*)controller) triggerMatch];
                break;
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void) createAvatarImage:(int)y_val x_val:(int)x_val imageUrl:(NSString *)theImageUrl profileId:(int) theProfileId containerView:(UIView *) container {
    
    AvatarImageView *theImage = [[[AvatarImageView alloc] initWithFrame:CGRectMake(x_val, y_val, 54, 54)] autorelease];
    theImage.displayUImage = true;
    [theImage checkIfImageExists:theImageUrl theImageFrame:CGRectMake(0, 0, 54, 54)];
    [container addSubview:theImage];
    UIButton *profileOver = [UIButton buttonWithType:UIButtonTypeCustom];    
    profileOver.tag = theProfileId;
    [profileOver setFrame:CGRectMake(x_val, y_val, 54, 54)];
    [profileOver addTarget:self action:@selector(openAsyncMessageView:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:profileOver];
   
}

- (void) openAsyncMessageView:(id) sender {
  
    int theProfileId = ((UIButton *)sender).tag;
    if (theProfileId != [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]) {       
      
        
        NSDictionary* theDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:theProfileId], @"other_id", [NSNumber numberWithInt:3], @"message_count", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"photo_selected" object:self userInfo:theDic];
        //Mixpanel *mixpanel = [Mixpanel sharedInstance];
        //[mixpanel track:@"Photo selected in individual feeler"];
    }
}

#pragma - mark knowledge selection
- (void) meetNowCellSelected:(id) theSender {

    self.reloadBack = YES;
    int feelerId = [[self.feelerData objectForKey:@"id"] intValue];
    NSMutableString *feeler = [[[feelerData objectForKey:@"URLEncodedAnswer"] mutableCopy] autorelease];
    NSString* feelerDescription = [StringEscapeUtil urlDecoder:feeler];
    //get the cell
    //PeopleHuntRequests *request = [[[PeopleHuntRequests alloc] init] autorelease];
    NSMutableDictionary* selection = [[NSMutableDictionary alloc] init];
    [selection setObject:[NSNumber numberWithInt:feelerId] forKey:@"feeler_id"];
    [selection setObject:feelerDescription forKey:@"feeler_description"];
    if (((UIButton *)theSender).selected) { //delete from array
        [self.wanters removeObjectForKey:[[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] stringValue]];
        
        ((UIButton *)theSender).selected = NO;        

        
        //[request deleteFeelerState:feelerId statusType:@"looking"];
        [wantBtn setImage:[UIImage imageNamed:@"greyBasic.png"] forState:UIControlStateNormal];
        wantLbl.textColor = [UIColor grayColor];
        [selection setObject:[NSNumber numberWithBool:false] forKey:@"is_adding"];        

    } else { // add to array
        int numberWant = [[[NSUserDefaults standardUserDefaults] objectForKey:@"number_want"] intValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:++numberWant] forKey:@"number_want"];
        NSDictionary *myData = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"my_image"], [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] stringValue], nil];
        [self.wanters addEntriesFromDictionary:myData];
        
        
        ((UIButton *)theSender).selected = YES;
      
        ((UIButton *)theSender).selected = YES;
        
        [wantBtn setImage:[UIImage imageNamed:@"blueSelected.png"] forState:UIControlStateSelected];
        wantLbl.textColor = [UIColor whiteColor];
        //ask user for facebook
        //[request addFeelerState:feelerId statusType:@"looking"];
        [selection setObject:[NSNumber numberWithBool:true] forKey:@"is_adding"];
        //[self performSelector:@selector(wantSharePop) withObject:self afterDelay:0.2];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"interested_change" object:self userInfo:selection];
    [self redrawAvatarLayout];
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"I want feeler selected!"];

}

- (void)addMyselfAction:(id) sender {
   
    self.reloadBack = YES;
    
    //get the cell
    int feelerId = [[self.feelerData objectForKey:@"id"] intValue];
    NSMutableString *feeler = [[[feelerData objectForKey:@"URLEncodedAnswer"] mutableCopy] autorelease];
    NSString* feelerDescription = [StringEscapeUtil urlDecoder:feeler];
    
    NSMutableDictionary* selection = [[NSMutableDictionary alloc] init];
    [selection setObject:[NSNumber numberWithInt:feelerId] forKey:@"feeler_id"];
    [selection setObject:feelerDescription forKey:@"feeler_description"];
    if (((UIButton *)sender).selected) { //delete from array
        [self.knowers removeObjectForKey:[[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] stringValue]];
        
        //delete user a provider
        ((UIButton *)sender).selected = NO;
        NSLog(@"know has been unselected");
        
      
        [knowBtn setImage:[UIImage imageNamed:@"greyBasic.png"] forState:UIControlStateNormal];
        knowLbl.textColor = [UIColor grayColor];
        
       [selection setObject:[NSNumber numberWithBool:false] forKey:@"is_adding"];
        
    } else { // add to array
        int numberKnow = [[[NSUserDefaults standardUserDefaults] objectForKey:@"number_know"] intValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:++numberKnow] forKey:@"number_know"];
        ((UIButton *)sender).selected = YES;
        NSDictionary *myData = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"my_image"], [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] stringValue], nil];
        [self.knowers addEntriesFromDictionary:myData];
        
        //add profile as provider
        [knowBtn setImage:[UIImage imageNamed:@"blueSelected.png"] forState:UIControlStateSelected];
        knowLbl.textColor = [UIColor whiteColor];
        //[request addFeelerState:feelerId statusType:@"providing"];
        [selection setObject:[NSNumber numberWithBool:true] forKey:@"is_adding"];        
        //if (numberKnow == 1 || numberKnow == 2)[self performSelector:@selector(knowInfoPop) withObject:self afterDelay:0.5];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"help_change" object:self userInfo:selection];
    [self performSelector:@selector(startHuntingNow) withObject:self afterDelay:0.5];    
    [self redrawAvatarLayout];
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"I can help feeler selected!"];
    
}





- (void) startHuntingNow {
    
    NSString *activated = [[NSUserDefaults standardUserDefaults] objectForKey:@"hunt_activated"];
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!activated) {
        //[appDelegate startHunting];
    }
    if (![appDelegate.protocol checkStreamStatus]) [appDelegate initProtocolCommunicationMainThread];
    //[appDelegate.protocol sendMessage:@"80:getliveusers"];
}



- (void) showPlanningScreen {
    [[self.view viewWithTag:263748] removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"knowPopped"];
    
    [[[PlanningView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) superController:self.view navigationController:self.navigationController] autorelease];

}



- (void)doFacebookPermitCall {
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFacebookSharingPop) name:FBSessionStateChangedNotification object:nil];
    [appDelegate openSessionWithAllowLoginUI:YES];
}

- (void) doFacebookPermissions {
    [[self.view viewWithTag:179283] removeFromSuperview];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"all_friends"]){
        self.profileHelper = [[[HuntProfileHelper alloc] init] autorelease];
         self.profileHelper.delegate = self;
        NSLog(@"calling doFacebookPermissions");
        [self.profileHelper retrieveFriends];
        //return;
    } else {
        [self doFacebookPermitCall];
    }
}

- (void) facebookActionDone {
    
    [self doFacebookPermitCall];
}

- (void) doFacebookSharingPop {
       
    FacebookActionSharing *sharing = [[[FacebookActionSharing alloc] initWithNibName:@"FacebookActionSharing" bundle:nil] autorelease];
    sharing.theMessage = [NSString stringWithFormat:@"Know anyone able to help me with %@? ", self.theText.text];
    sharing.selectedFeeler = self.theText.text;
    sharing.classType = [IndividualFeelerController class];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sharing];
    UINavigationBar *navBar = [navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    //now present this navigation controller as modally
    [self presentModalViewController:navigationController  animated:YES];

}

- (void) redrawAvatarLayout {
    [[self.view viewWithTag:33456677] removeFromSuperview];
    [[self.view viewWithTag:232] removeFromSuperview];
    [[self.view viewWithTag:55556677] removeFromSuperview];
    [[self.view viewWithTag:234] removeFromSuperview];
    
    NSNotification *notification = [NSNotification notificationWithName:@"" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.knowers, @"providers", self.wanters, @"lookers", nil]];
    //NSLog(@"before UPDATE %@", notification);
    [self showFeelerData:notification];
}



- (void) showFeelerData:(NSNotification *) data {    
   
    NSMutableDictionary *providerDic = [[[[data userInfo] objectForKey:@"providers"] mutableCopy] autorelease];
    NSMutableDictionary *lookerDic = [[[[data userInfo] objectForKey:@"lookers"] mutableCopy] autorelease];
    self.knowers = [NSMutableDictionary dictionaryWithDictionary:providerDic];
    self.wanters = [NSMutableDictionary dictionaryWithDictionary:lookerDic];    
    
    NSString *interestedInText = @"1";
    if ([self.wanters count] > 1) interestedInText = [NSString stringWithFormat:@"%i" , [self.wanters count]];
    interestedLbl.text = interestedInText;
    interestedLbl.font = [UIFont fontWithName:@"Delicious-Heavy" size:22.0];
    
    
    NSString *interestedInTextPeople = @"person wants";
    if ([self.wanters count] > 1) interestedInTextPeople = [NSString stringWithFormat:@"people want"];
    interestedLbl2.text = interestedInTextPeople;
    interestedLbl2.textColor = [UIColor colorWithRed:124/255.0 green:52/255.0 blue:0/255.0 alpha:1];
    interestedLbl2.font = [UIFont fontWithName:@"FreightSans Medium" size:18.0];
    
    
    int x_val = 3;
    int count = 0;    
    //int knowersTextYPos = 180;
    int knowersPhotosYPos = 3;
    int scrollHeightKnowers = 288;
    int scrollHeightWanters = 288;
    UIView* knowersContainer = nil;
       
    //NSLog(@"the scroll height first %i", scrollHeight);
    //NSLog(@"the Wanter TextY pos height first %i", wantersTextYPos);
   
    float numberRowsKnowers = ceilf(((float)[providerDic count] / (float)2));
    int endKnow = numberRowsKnowers * 59;
    //add the knowers container
    UIImageView* backgroundMiddlePhotos = nil;
    UIImageView* backgroundBottomPhotos = nil;
    if (numberRowsKnowers > 0){
        
        UIImageView *backgroundTopPhotos = [[[UIImageView alloc] initWithFrame:CGRectMake(148.5, 145, 132, 24.5)] autorelease];
        backgroundTopPhotos.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_picture_top.png"]];
        [self.view addSubview:backgroundTopPhotos];
        
        backgroundMiddlePhotos = [[[UIImageView alloc] initWithFrame:CGRectMake(148.5, 169.5, 132, endKnow)] autorelease];
        backgroundMiddlePhotos.tag = 999111;
        backgroundMiddlePhotos.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_picture_center.png"]];
        [self.view addSubview:backgroundMiddlePhotos];
        
        backgroundBottomPhotos = [[[UIImageView alloc] initWithFrame:CGRectMake(148.5, 168 + endKnow, 132, 24.5)] autorelease];
        backgroundBottomPhotos.tag = 334442;
        backgroundBottomPhotos.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_picture_under.png"]];
        [self.view addSubview:backgroundBottomPhotos];
        
        knowersContainer = [[[UIView alloc] initWithFrame:CGRectMake(155.5, 183, 119, numberRowsKnowers * 59)] autorelease];
        knowersContainer.backgroundColor = [UIColor clearColor];
        knowersContainer.tag = 33456677;
        [self.view addSubview:knowersContainer];
        
        UIImageView *BlueBGKnowers = [[[UIImageView alloc] initWithFrame:CGRectMake(155.5, 150, 119, 33)] autorelease];
        BlueBGKnowers.tag = 232;
        BlueBGKnowers.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blueIndiv.png"]];
        [self.view addSubview:BlueBGKnowers];
        
        UILabel *knowText = [[[UILabel alloc] initWithFrame:CGRectMake(0, 8, 119, 18)] autorelease];
        knowText.textAlignment = UITextAlignmentCenter;
        knowText.backgroundColor = [UIColor clearColor];
        knowText.font = [UIFont fontWithName:@"Delicious-Heavy" size:14.0];
        knowText.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
        knowText.text = [NSString stringWithFormat:@"HELPERS"];
        [BlueBGKnowers addSubview:knowText];
    }
    //knower add photos
    for (id key in providerDic) { //30 5 5 7          
        //check if I have selected it
        if ([key intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]){
            self.knowBtn.selected = true;
            knowLbl.textColor = [UIColor whiteColor];
        }
        if (count % 2 == 0 && count > 0){
            x_val = 3;
            knowersPhotosYPos+= 59;
            scrollHeightKnowers +=59;
        }
        
        [self createAvatarImage:knowersPhotosYPos x_val:x_val imageUrl:[providerDic objectForKey:key] profileId:[key intValue] containerView:knowersContainer];           
        x_val+=59;
        count++;
    }
  
    
    //wanter for list of images
    x_val = 3;
    count = 0;
    int wantersPhotoYPos = 3;
    
    UIView* wantersContainer = nil;
    float numberRowsWanters = ceilf(((float)[lookerDic count] / (float)2));
    int endWant = numberRowsWanters * 59;
    //add the wanters container
    UIImageView *backgroundMiddlePhotos2 = nil;
    UIImageView *backgroundBottomPhotos2 = nil;
    if (numberRowsWanters > 0){
        
        UIImageView *backgroundTopPhotos = [[[UIImageView alloc] initWithFrame:CGRectMake(14.5, 145, 132, 24.5)] autorelease];
        backgroundTopPhotos.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_picture_top.png"]];
        [self.view addSubview:backgroundTopPhotos];
        
        backgroundMiddlePhotos2 = [[[UIImageView alloc] initWithFrame:CGRectMake(14.5, 169.5, 132, endWant)] autorelease];
        backgroundMiddlePhotos2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_picture_center.png"]];
        [self.view addSubview:backgroundMiddlePhotos2];
        
        backgroundBottomPhotos2 = [[[UIImageView alloc] initWithFrame:CGRectMake(14.5, 168 + endWant , 132, 24.5)] autorelease];
        backgroundBottomPhotos2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_picture_under.png"]];
        [self.view addSubview:backgroundBottomPhotos2];
        
        wantersContainer = [[[UIView alloc] initWithFrame:CGRectMake(21.5, 183, 119, numberRowsWanters * 59)] autorelease];
        wantersContainer.backgroundColor = [UIColor clearColor];
        wantersContainer.tag = 55556677;       
        [self.view addSubview:wantersContainer];
        
        UIImageView *BlueBGWanters = [[[UIImageView alloc] initWithFrame:CGRectMake(21.5, 150, 119, 33)] autorelease];
        BlueBGWanters.tag = 234;
        BlueBGWanters.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blueIndiv.png"]];
        [self.view addSubview:BlueBGWanters];
        
        
        
        UILabel *wantText = [[[UILabel alloc] initWithFrame:CGRectMake(0, 8,119, 18)] autorelease];
        wantText.backgroundColor = [UIColor clearColor];
        wantText.textAlignment = UITextAlignmentCenter;
        wantText.font = [UIFont fontWithName:@"Delicious-Heavy" size:14.0];
        wantText.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
        wantText.text = [NSString stringWithFormat:@"HUNTERS"];
        [BlueBGWanters addSubview:wantText];
    }
    
    for (id key in lookerDic) { //30 5 5 7
        //CHeck if I want this
        if ([key intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]){
            self.wantBtn.selected = true;
            wantLbl.textColor = [UIColor whiteColor];
        }
        
        if (count % 2 == 0 && count > 0){
            x_val = 3;
            wantersPhotoYPos += 59;
        }
        
        [self createAvatarImage:wantersPhotoYPos x_val:x_val imageUrl:[lookerDic objectForKey:key] profileId:[key intValue] containerView:wantersContainer];         
        x_val+=59;
       
        count++;
        //NSLog(@"the scroll height through wanting loop %i", scrollHeight);
        //NSLog(@"the Wanter TextY post wanter loop %i", wantersTextYPos);
        
    }
    
   
    scrollHeightWanters += endWant;       
    if (scrollHeightKnowers > scrollHeightWanters) [theScrollView setContentSize:CGSizeMake(290, scrollHeightKnowers + 30)];
    if (scrollHeightKnowers < scrollHeightWanters) [theScrollView setContentSize:CGSizeMake(290, scrollHeightWanters + 30)];
    int finalHeight;
    if (endWant > endKnow) finalHeight = endWant;
    if (endWant < endKnow) finalHeight = endKnow;
    
    int limitValue = 266;
    int substract = 212;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        limitValue = 354;
        substract = 300;
    }
    
    if (finalHeight >= limitValue){
        int finalRes = finalHeight - substract;
        CGRect theButtonsPosition = self.middleCard.frame;
        theButtonsPosition.size.height = finalRes + theButtonsPosition.size.height;
        self.middleCard.frame = theButtonsPosition;
        
        CGRect theButtonsPositionBtn = self.bottomCard.frame;
        theButtonsPositionBtn.origin.y = finalRes + theButtonsPositionBtn.origin.y;
        self.bottomCard.frame = theButtonsPositionBtn;
    }
  
}

#pragma - mark show views



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [profileHelper release];
    [knowers release];
    [wanters release];
    [knowBtn release];
    [knowLbl release];
    [wantBtn release];
    [wantLbl release];
    [theScrollView release];
    [topWhiteBG release];
    [flipView release];
    [feelerData release];
    [backgroundIndividual release];
    [buttonsView release];
    [interestedLbl2 release];
    [theText release];
    [centerTextView release];
    [interestedLbl release];
    [super dealloc];
}

@end
