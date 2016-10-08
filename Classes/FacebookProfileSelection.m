//
//  FacebookProfileSelection.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 15/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "FacebookProfileSelection.h"
#import "AvatarImageView.h"
#import "PlanningView.h"
#import "iphoneCrowdAppDelegate.h"
//#import "Mixpanel.h"

@interface FacebookProfileSelection ()

@end

@implementation FacebookProfileSelection
@synthesize profileData, theBioLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupProfileView];   
}

- (void)setupProfileView {
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
        
    UIImageView *pageControl1;     
    UIImageView *pageControl2;
    UIImageView *pageControl3;
    UIImageView *pageControl4;
    UIImageView *fromFacebook;
    UIImageView *bgPhoto;
    UIImageView *bgBlueName;
    UIImageView *bgProfile;    
    UIImageView *swiper;
    UIImageView *middleCard;
    UIImageView *bottomCard;
    
    UIButton *editBioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 472)];
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 500, 297.5, 28)];
        pageControl1 = [[UIImageView alloc] initWithFrame:CGRectMake(115.25, 16, 13, 13)];
        pageControl2 = [[UIImageView alloc] initWithFrame:CGRectMake(133.25, 16, 13, 13)];
        pageControl3 = [[UIImageView alloc] initWithFrame:CGRectMake(151.25, 16, 13, 13)];
        pageControl4 = [[UIImageView alloc] initWithFrame:CGRectMake(169.25, 16, 13, 13)];
        fromFacebook = [[UIImageView alloc] initWithFrame:CGRectMake(15.75, 10, 266, 39)];
        bgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(14.5, 59, 268.5, 179.5 )];
        bgBlueName = [[UIImageView alloc] initWithFrame:CGRectMake(17, 248.5, 263.5, 36.5)];
        bgProfile = [[UIImageView alloc] initWithFrame:CGRectMake(16, 295, 265.5, 74.5)];
        [editBioBtn setFrame:CGRectMake(16, 315, 265.5, 74.5)];
        swiper = [[UIImageView alloc] initWithFrame:CGRectMake(27.25, 401, 243, 52)];
        
    }else{
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 384)];
        bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 412, 297.5, 28)];
        pageControl1 = [[UIImageView alloc] initWithFrame:CGRectMake(115.25, 12, 13, 13)];
        pageControl2 = [[UIImageView alloc] initWithFrame:CGRectMake(133.25, 12, 13, 13)];
        pageControl3 = [[UIImageView alloc] initWithFrame:CGRectMake(151.25, 12, 13, 13)];
        pageControl4 = [[UIImageView alloc] initWithFrame:CGRectMake(169.25, 12, 13, 13)];
        fromFacebook = [[UIImageView alloc] initWithFrame:CGRectMake(15.75, 0, 266, 39)];
        bgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(14.5, 44, 268.5, 179.5 )];
        bgBlueName = [[UIImageView alloc] initWithFrame:CGRectMake(17, 228.5, 263.5, 36.5)];
        bgProfile = [[UIImageView alloc] initWithFrame:CGRectMake(16, 270, 265.5, 74.5)];
        [editBioBtn setFrame:CGRectMake(16, 295, 265.5, 74.5)];
        swiper = [[UIImageView alloc] initWithFrame:CGRectMake(27.25, 345.5, 243, 52)];
        
    }  

    
    pageControl1.image = [UIImage imageNamed:@"circle_orange.png"];
    pageControl2.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl3.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl4.image = [UIImage imageNamed:@"circle_gray.png"];
    fromFacebook.image = [UIImage imageNamed:@"title.png"];
    bgPhoto.image = [UIImage imageNamed:@"back_picture.png"];
    bgBlueName.image = [UIImage imageNamed:@"blue1.png"];
    bgProfile.image = [UIImage imageNamed:@"blue2.png"];
    swiper.image = [UIImage imageNamed:@"swipe.png"];
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    bottomCard.image = [UIImage imageNamed:@"cardback_bottom.png"];  

    
    //add headerView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 122)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.tag = 72837; 
    
    //Profile image
    AvatarImageView *profileImage = [[AvatarImageView alloc] initWithFrame:CGRectMake(7, 7, 254.5, 254.5)];
    profileImage.tag = 411;
    [profileImage checkIfImageExists:[[NSUserDefaults standardUserDefaults] objectForKey:@"my_image"] theImageFrame:CGRectMake(0, 0, 254.5, 165.5)];
    [bgPhoto addSubview:profileImage];
    
    //name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,9,233,18)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:18.0];
	nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"];
    [bgBlueName addSubview:nameLabel];    
    
   
    [editBioBtn addTarget:self action:@selector(editProfileData) forControlEvents:UIControlEventTouchUpInside];    
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,9,233,18)];
    aboutLabel.backgroundColor = [UIColor clearColor];
    aboutLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:18.0];
	aboutLabel.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
    aboutLabel.text = @"About you";
    [bgProfile addSubview:aboutLabel];
    [self.view addSubview:editBioBtn];
    
    NSString *bioLabelText = [[NSUserDefaults standardUserDefaults] objectForKey:@"bio"];
    NSLog(@"%@", bioLabelText);
    CGSize withinsize = CGSizeMake(235, 1000);
    CGSize szBioLabel = [bioLabelText sizeWithFont:[UIFont fontWithName:@"Delicious-Heavy" size:14.0] constrainedToSize:withinsize lineBreakMode:NSLineBreakByWordWrapping];
   
    UILabel* bioLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, 235, 40)];
    bioLabel.text = bioLabelText;
    bioLabel.numberOfLines = 2;
    bioLabel.tag = 1029011;
    bioLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:14.0];
    bioLabel.textColor = [UIColor whiteColor];
    bioLabel.backgroundColor = [UIColor clearColor];
    self.theBioLabel = bioLabel;
    
    UIButton *editBio = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBio setFrame:CGRectMake(0, 0, 265.5, 74.5)];
    [editBio addTarget:self action:@selector(editProfileData) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:topCard];
    [self.view addSubview:middleCard];
    [self.view addSubview:bottomCard];
  
    [topCard addSubview:pageControl1];
    [topCard addSubview:pageControl2];
    [topCard addSubview:pageControl3];
    [topCard addSubview:pageControl4];
    
    [middleCard addSubview:fromFacebook];
    [middleCard addSubview:bgBlueName];
    [middleCard addSubview:bgPhoto];
    [middleCard addSubview:bgProfile];
    [middleCard addSubview:swiper];
    
    
    [bgProfile addSubview:bioLabel];
    [bgProfile addSubview:editBio];
    [self.view addSubview:headerView];
}



#pragma - mark Navigation methods
- (void) editProfileData {
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"Editing profile bio"];
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    PlanningView* editProfile = [[PlanningView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) superController:[[self.view superview] superview] navigationController:appDelegate.navigationController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(updateBio)
                                                 name:@"edit_bio" object:editProfile];
    
}

- (void) updateBio  {   
    NSString *bioLabelText = [[NSUserDefaults standardUserDefaults] objectForKey:@"bio"];
    CGSize withinsize = CGSizeMake(235, 1000);
    CGSize szBioLabel = [bioLabelText sizeWithFont:[UIFont fontWithName:@"Delicious-Heavy" size:14.0] constrainedToSize:withinsize lineBreakMode:NSLineBreakByWordWrapping];
    UILabel* theLabel = ((UILabel*)[self.view viewWithTag:1029011]);
    theLabel.text = bioLabelText;  
    if (szBioLabel.height <100) [theLabel sizeToFit];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
