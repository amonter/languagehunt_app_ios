//
//  LongProfileController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 15/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "LongProfileController.h"
#import "AvatarImageView.h"
#import "iphoneCrowdAppDelegate.h"

@interface LongProfileController ()

@end

@implementation LongProfileController
@synthesize profileData,  underScroll, profileDataTable;

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
        orangeBack = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 0, 265, 55.5)];
        hello = [[UIImageView alloc] initWithFrame:CGRectMake(106, 10, 57.5, 19)];
        swiper = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 65, 243, 33.5)];
        bgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(71.75, 98, 154, 154 )];
        bgAbout = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 265.5, 265, 30)];
        bgWhere = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 305, 265, 30)];
        bgWant = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 344.5, 265, 30)];
        bgHelp = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 384, 265, 30)];
        iconAbout = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 268.5, 27, 28.5)];
        iconWhere = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 308, 27, 28.5)];
        iconWanting = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 347.5, 27, 28.5)];
        iconHelping = [[UIImageView alloc] initWithFrame:CGRectMake(19.25, 387, 27, 28.5)];
        [underScroll setContentSize:CGSizeMake(264, 560)];
    
    }else{
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 460)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 384)];
        middleCard.tag = 19928181;
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 412, 297.5, 28)];
        bottomCard.tag = 19928185;
        orangeBack = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 0, 265, 55.5)];
        hello = [[UIImageView alloc] initWithFrame:CGRectMake(106, 10, 57.5, 19)];
        swiper = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 65, 243, 33.5)];
        bgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(71.75, 98, 154, 154 )];
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
    bottomCard.image = [UIImage imageNamed:@"cardback_bottom.png"];
    //background.image = [UIImage imageNamed:@"background.png"];
    

    //add headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 182)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.tag = 72837;
    
    //Profile image
    AvatarImageView *profileImage = [[AvatarImageView alloc] initWithFrame:CGRectMake(7, 7, 140, 140)];
    profileImage.tag = 100;
    
    //name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,265,20)];
    nameLabel.tag = 200;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:18.0];
	nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = UITextAlignmentCenter;   
  
    
    /*self.theTable.tableHeaderView = headerView;
    CGRect tableFrame = self.theTable.frame;
    tableFrame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, 490);
    self.theTable.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, 490);
   
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        self.theTable.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, 490);
    }*/
    
    
    [self.underScroll addSubview:background];
    [self.underScroll addSubview:topCard];
    [self.underScroll addSubview:middleCard];
    [self.underScroll addSubview:bottomCard];
    
    [middleCard addSubview:orangeBack];
    [middleCard addSubview:hello];
    [orangeBack addSubview:nameLabel];
    [middleCard addSubview:swiper];
    [middleCard addSubview:bgPhoto];
    [bgPhoto addSubview:profileImage];
    //[middleCard addSubview:bgAbout];
    //[bgAbout addSubview:bioLabel];
    //[middleCard addSubview:bgWant];
    //[middleCard addSubview:bgWhere];
    //[middleCard addSubview:bgHelp];
    //[middleCard addSubview:iconAbout];
    //[middleCard addSubview:iconHelping];
    //[middleCard addSubview:iconWhere];
    //[middleCard addSubview:iconWanting];
        
    CGRect underScrollFrame = self.underScroll.frame;
    underScrollFrame.size.width = 297.5;
    self.underScroll.frame = underScrollFrame;
    
    self.profileDataTable = [[MatchDataTableController alloc] initWithNibName:@"MatchDataTableController" bundle:nil];
   

}



- (void) displayProfileData {
   
    NSLog(@"PRIFLLLELLEE %@", self.profileDataTable);
    profileDataTable.locations = [self.profileData objectForKey:@"locations"];
    profileDataTable.help = [self.profileData objectForKey:@"help"];
    profileDataTable.interested = [self.profileData objectForKey:@"interested"];
    profileDataTable.about = [self.profileData objectForKey:@"bio"];    
    int numberSections = 0;
    NSString* theBio = [self.profileData objectForKey:@"bio"];
    if (theBio.length > 0) numberSections++;
    if ([[self.profileData objectForKey:@"locations"] count] > 0) numberSections++;
    if ([[self.profileData objectForKey:@"help"] count] > 0) numberSections++;
    if ([[self.profileData objectForKey:@"interested"] count] > 0) numberSections++;
    profileDataTable.numberSections = numberSections;
    
    CGFloat finHeight = [self.profileDataTable calculateLayout];
    NSLog(@"NUMBER SECCC %i %@", numberSections, self.profileData);   
    
    CGRect layoutFrame = self.profileDataTable.view.frame;
    layoutFrame.origin.x = 17;
    layoutFrame.origin.y = 285;
    layoutFrame.size.width = 264;
    NSLog(@"HEIIIHE %f", finHeight);
    layoutFrame.size.height = finHeight;
    self.profileDataTable.view.frame = layoutFrame;
    
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
    
    
    UIView* profileLay =  [self.underScroll viewWithTag:30209911];
    if (profileLay == nil) [self.underScroll addSubview:profileDataTable.view];
    else [self.profileDataTable.theTable reloadData];
    
    //do the rest of the profileData   
    [((AvatarImageView*)[self.underScroll viewWithTag:100]) checkIfImageExists:[self.profileData objectForKey:@"image_url"] theImageFrame:CGRectMake(0, 0, 140, 140)];
     ((UILabel*)[self.underScroll viewWithTag:200]).text = [self.profileData objectForKey:@"name"];
}

/*
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0){
        return [[[self.profileData objectForKey:@"location"] allValues] count];
    }
    if (section == 1) {
        return [[[self.profileData objectForKey:@"interested"] allValues] count];
    }    
    if (section == 2) {
        return [[[self.profileData objectForKey:@"help"] allValues] count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString* copy = nil;
    if ([indexPath section] == 0) {
        copy = [[[self.profileData objectForKey:@"location"] allValues] objectAtIndex:[indexPath row]];
    }
    if ([indexPath section] == 1){
        copy = [[[self.profileData objectForKey:@"interested"] allValues] objectAtIndex:[indexPath row]];
    }
    if ([indexPath section] == 2){
        copy = [[[self.profileData objectForKey:@"help"] allValues] objectAtIndex:[indexPath row]];    
    }
    cell.textLabel.text = copy;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    //if (section == 0) return @"Found";
    if (section == 1) return @"Interested in";
    if (section == 2) return @"Can help with";
    
    return nil;
}*/


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
