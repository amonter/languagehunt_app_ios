//
//  MainProfileController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 7/10/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "MainProfileController.h"
#import "AvatarImageView.h"
#import "iphoneCrowdAppDelegate.h"

@interface MainProfileController ()

@end

@implementation MainProfileController
@synthesize profileData,  underScroll, profileDataTable, profileDataLanguage, dummyTable, delegate;

- (void)addKeepBrowsing {
    
    // Do any additional setup after loading the view from its nib.
    //Add the referFriendn button now
    
    UIButton *startBrowsing = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBrowsing setBackgroundImage:[UIImage imageNamed:@"startbrowsing_btn2.png"] forState:UIControlStateNormal];
    startBrowsing.tag = 920;
    CGRect posFrameShort = CGRectMake (26.25, 418, 267.5, 41.5);
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) posFrameShort = CGRectMake (26.25, 439, 267.5, 41.5);
    [startBrowsing setFrame:posFrameShort];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        CGRect posFrame = CGRectMake (26.25, 508, 267.5, 41.5);
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) posFrame = CGRectMake (26.25, 528, 267.5, 41.5);
        [startBrowsing setFrame:posFrame];
    }
    //[referFriend setTitle:@"Keep Browsing" forState:UIControlEventTouchUpInside];
    //[referFriend setTitleColor:[UIColor blackColor] forState:UIControlEventTouchUpInside];
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [startBrowsing addTarget:self action:@selector(doCommit:) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate.navigationController.visibleViewController.view addSubview:startBrowsing];
    
}

- (void) removeButton {
    [[[[self.view superview] superview] viewWithTag:920] removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[matchView addSubview:referFriend];
    self.view.tag = 12812831;
    self.underScroll.delegate = self;
    self.underScroll.backgroundColor = [UIColor clearColor];
    self.underScroll.scrollEnabled = true;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"done_added"];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *orangeBack;
    UIImageView *hello;
    UIImageView *swiper;
    UIImageView *bgPhoto;
    UIImageView *bgAbout;
    UIImageView *bgWhere;
    UIImageView *bgWant;
    UIImageView *bgHelp;
    UIImageView *iconAbout;
    UIImageView *iconWhere;
    UIImageView *iconWanting;
    UIImageView *iconHelping;
    UIImageView *background;
    UIImageView *middleCard;
    UIImageView *bottomCard;
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 548)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 472)];
        middleCard.tag = 19928181;
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 500, 297.5, 28)];
        bottomCard.tag = 19928185;
        orangeBack = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 3, 265, 35.5)];
        hello = [[UIImageView alloc] initWithFrame:CGRectMake(106, 10, 57.5, 19)];
        swiper = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 65, 243, 33.5)];
        bgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(21.75, 50, 154, 154 )];
        bgAbout = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 265.5, 265, 30)];
        bgWhere = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 305, 265, 30)];
        bgWant = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 344.5, 265, 30)];
        bgHelp = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 384, 265, 30)];
        iconAbout = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 268.5, 27, 28.5)];
        iconWhere = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 308, 27, 28.5)];
        iconWanting = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 347.5, 27, 28.5)];
        iconHelping = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 387, 27, 28.5)];
        [underScroll setContentSize:CGSizeMake(264, 560)];
        
    } else {
        
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 460)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 384)];
        middleCard.tag = 19928181;
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 412, 297.5, 28)];
        bottomCard.tag = 19928185;
        orangeBack = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 3, 265, 35.5)];
        hello = [[UIImageView alloc] initWithFrame:CGRectMake(106, 10, 57.5, 19)];
        swiper = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 65, 243, 33.5)];
        bgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(21.75, 50, 154, 154 )];
        bgAbout = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 265.5, 265, 34.5)];
        bgWhere = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 305, 265, 34.5)];
        bgWant = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 344.5, 265, 34.5)];
        bgHelp = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 384, 265, 34.5)];
        iconAbout = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 268.5, 27, 28.5)];
        iconWhere = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 308, 27, 28.5)];
        iconWanting = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 347.5, 27, 28.5)];
        iconHelping = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 387, 27, 28.5)];
        [underScroll setContentSize:CGSizeMake(264, 450)];
        
    }
    
    
    orangeBack.image = [UIImage imageNamed:@"orangeProfile.png"];
    hello.image = [UIImage imageNamed:@"hello.png"];
    hello.tag = 11112;
    swiper.image = [UIImage imageNamed:@"swipeProfile.png"];
    swiper.tag = 237823;
    bgPhoto.image = [UIImage imageNamed:@"back_pictureChat.png"];
    bgPhoto.tag = 888111;
    bgAbout.image = [UIImage imageNamed:@"blueProfile.png"];
    bgWhere.image = [UIImage imageNamed:@"blueProfile.png"];
    bgWant.image = [UIImage imageNamed:@"blueProfile.png"];
    bgHelp.image = [UIImage imageNamed:@"blueProfile.png"];
    iconAbout.image = [UIImage imageNamed:@"icon_profileProfile.png"];
    iconWhere.image = [UIImage imageNamed:@"icon_location_anchorProfile.png"];
    iconWanting.image = [UIImage imageNamed:@"icon_pinProfile.png"];
    iconHelping.image = [UIImage imageNamed:@"icon_lightProfile.png"];
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    middleCard.tag = 3411341;
    bottomCard.image = [UIImage imageNamed:@"cardback_bottom.png"];
    bottomCard.tag = 18283910;
    
    //add headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 182)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.tag = 72837;
    
    //Profile image
    AvatarImageView *profileImage = [[AvatarImageView alloc] initWithFrame:CGRectMake(7, 7, 140, 140)];
    profileImage.tag = 100;
    
    //name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10,265,20)];
    nameLabel.tag = 200;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:18.0];
	nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    //Edit Profile Button
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.backgroundColor = [UIColor clearColor];
    [actionButton setFrame:CGRectMake(170.75, 80, 100, 30)];
    [actionButton addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setTitle:@"Edit Profile" forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    
    
    
    
    [self.underScroll addSubview:background];
    [self.underScroll addSubview:topCard];
    [self.underScroll addSubview:middleCard];
    [self.underScroll addSubview:bottomCard];
    [self.underScroll addSubview:actionButton];
    
    [middleCard addSubview:orangeBack];
    [orangeBack addSubview:nameLabel];
    [middleCard addSubview:bgPhoto];
    [bgPhoto addSubview:profileImage];
    //[middleCard addSubview:hello];
    //[middleCard addSubview:swiper];
    //[middleCard addSubview:bgAbout];
    //[bgAbout addSubview:bioLabel];
    //[middleCard addSubview:bgWant];
    //[middleCard addSubview:bgWhere];
    //[middleCard addSubview:bgHelp];
    //[middleCard addSubview:iconAbout];
    //[middleCard addSubview:iconHelping];
    //[middleCard addSubview:iconWhere];
    //[middleCard addSubview:iconWanting];
    
    //CGRect underScrollFrame = self.underScroll.frame;
    //underScrollFrame.size.width = 297.5;
    //self.underScroll.frame = underScrollFrame;
    
    self.dummyTable = [[ProfileDummyTable alloc] initWithNibName:@"DummyNewTable" bundle:nil];
    
}


- (void) doAction {
    NSLog(@"Hellooo");
   [delegate goSelected:0];
    
}

- (void) displayProfileData {
    
    /*profileDataTable.locations = [self.profileData objectForKey:@"locations"];
    profileDataTable.help = [self.profileData objectForKey:@"help"];
    profileDataTable.interested = [self.profileData objectForKey:@"interested"];
    //profileDataTable.about = [self.profileData objectForKey:@"bio"];
    
    int numberSections = 0;
    //if ([self.profileData objectForKey:@"bio"] > 0) numberSections++;
    if ([[self.profileData objectForKey:@"locations"] count] > 0) numberSections++;
    if ([[self.profileData objectForKey:@"help"] count] > 0) numberSections++;
    if ([[self.profileData objectForKey:@"interested"] count] > 0) numberSections++;
    profileDataTable.numberSections = numberSections;
   
    
    CGFloat finHeight = [self.profileDataTable calculateLayout];
    NSLog(@"NUMBER SECCC %i %@", numberSections, self.profileData);*/
    
    CGFloat finHeight = 300.0;
    
    /*CGRect layoutFrame = self.profileDataTable.view.frame;
    layoutFrame.origin.x = 17;
    layoutFrame.origin.y = 205;
    layoutFrame.size.width = 264;
    NSLog(@"HEIIIHE %f", finHeight);
    layoutFrame.size.height = finHeight -50;
    self.profileDataTable.view.frame = layoutFrame;*/
    
    if (finHeight > 180){
        
        CGRect theFrame = [self.view viewWithTag:19928181].frame;
        CGFloat setHeight = theFrame.size.height;
        theFrame.size.height = setHeight + (finHeight - 145);
        [self.view viewWithTag:19928181].frame = theFrame;
        
        CGRect theFrame2 = [self.view viewWithTag:19928185].frame;
        CGFloat setHeight2 = theFrame2.origin.y;
        theFrame2.origin.y = setHeight2 + (finHeight - 145);
        [self.view viewWithTag:19928185].frame = theFrame2;
        
        CGSize scrollSize = self.underScroll.contentSize;
        scrollSize.height = scrollSize.height + (finHeight - 40);
        [self.underScroll setContentSize:scrollSize];
    }
    
    
    //UIView* profileLay =  [self.underScroll viewWithTag:30209911];
    //if (profileLay == nil) [self.underScroll addSubview:profileDataTable.view];
    //else [self.profileDataTable.theTable reloadData];
    
    
    //do the rest of the profileData
    [((AvatarImageView*)[self.underScroll viewWithTag:100]) checkIfImageExists:[self.profileData objectForKey:@"image_url"] theImageFrame:CGRectMake(0, 0, 140, 140)];
    ((UILabel*)[self.underScroll viewWithTag:200]).text = [self.profileData objectForKey:@"name"];
    
    [self redisplayDummyTable];
  
    [self.underScroll addSubview:self.dummyTable.view];
    
    
    
    //if ([[self.profileData objectForKey:@"bio"] length] > 0) dummyTable.about = [self.profileData objectForKey:@"bio"];
   
    
    //matchLayout.link = @"https://www.facebook.com/adrian.mont";
    
    
    /*profileDataLanguage.about = aBio;
    profileDataLanguage.interested = [self.profileData objectForKey:@"interested"];
    profileDataLanguage.help = [self.profileData objectForKey:@"help"];
    profileDataLanguage.interest = [self.profileData objectForKey:@"interests"];
    profileDataLanguage.numberSections = 4;
    CGFloat finHeight2 = [self.profileDataLanguage calculateLayout];
    
    CGRect layoutFrameLanguage = self.profileDataLanguage.view.frame;
    layoutFrameLanguage.origin.x = 17;
    layoutFrameLanguage.origin.y = 255;
    layoutFrameLanguage.size.width = 264;
   
    layoutFrameLanguage.size.height = finHeight2 + 50;
    self.profileDataLanguage.view.frame = layoutFrameLanguage;
    [self.underScroll addSubview:profileDataLanguage.view];
    
    CGRect footerFrame = [self.underScroll viewWithTag:18283910].frame;
    footerFrame.origin.y = finHeight + finHeight2 + 190;
    [self.underScroll viewWithTag:18283910].frame = footerFrame;
    
    CGRect middleFrame = [self.underScroll viewWithTag:3411341].frame;
    middleFrame.size.height = finHeight + finHeight2 + 170;
    [self.underScroll viewWithTag:3411341].frame = middleFrame;
    
    CGSize scrollSize = self.underScroll.contentSize;
    //175
    scrollSize.height = finHeight + finHeight2 + 230;
    [self.underScroll setContentSize:scrollSize];
    [self.view setNeedsLayout];*/
    
}



- (void) redisplayDummyTable {

    ///profile langage section
    NSString* aBio = [self.profileData objectForKey:@"bio"];
    if (aBio.length > 100) {
        NSRange aboutRange = NSMakeRange(0, 100);
        aBio = [NSString stringWithFormat:@"%@ ...", [aBio substringWithRange:aboutRange]];
    }
    
    
    if ([[self.profileData objectForKey:@"bio"] length] > 0) {
        if ([[self.profileData objectForKey:@"bio"] isEqualToString:@"(null)"]) {
            aBio = @"Tell us something about yourself!";
        }
        dummyTable.about = aBio;
    }
    dummyTable.locations = [self.profileData objectForKey:@"locations"];
    dummyTable.help = [self.profileData objectForKey:@"help"];
    dummyTable.interested = [self.profileData objectForKey:@"interested"];
    dummyTable.withinSizeVal = 130;
    
    id interests = [self.profileData objectForKey:@"interests"];
    
    if ([interests isKindOfClass:[NSArray class]]){
        if ([interests count] > 0){
            NSMutableArray* theInterests = [NSMutableArray new];
            for (int a = 0; a < [interests count]; a++) {
                NSDictionary* theDic = [interests objectAtIndex:a];
                //[theInterests appendString:[NSString stringWithFormat:@"%@, ", [theDic objectForKey:@"name"]]];
                [theInterests addObject:theDic];
                if (a == 3) break;
            }
            dummyTable.interest = theInterests;
        }
    } else {
        dummyTable.interest = interests;
    }
    
    CGRect matchFrame = self.dummyTable.view.frame;
    CGFloat finHeightDummy = [self.dummyTable calculateLayout];
    matchFrame.origin.x = 17;
    matchFrame.origin.y = 265;
    matchFrame.size.width = 264;
    matchFrame.size.height = finHeightDummy;
    self.dummyTable.view.frame = matchFrame;

}

- (void) doCommit:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"do_commit" object:self];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"done_added"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
