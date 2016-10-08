//
//  MatchCardController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/13/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "MatchCardController.h"
#import "ModalProfileURLController.h"
#import "iphoneCrowdAppDelegate.h"
#import "ModalOfferCardsController.h"
#import "LanguageRatingView.h"

@interface MatchCardController ()

@end

@implementation MatchCardController
@synthesize matchLayout, theOtherUrl, proficiency, theName, matchCriteria, interests, helpMode, language, dummyTable;
@synthesize ratings;


- (void)createCard:(NSDictionary*) matchArray {
    
    NSLog(@"PAYYYY TYPEEE %@", matchArray );
    
    [self doMatchLayout:matchArray];
    
    NSArray* theLanguage = [[[matchArray objectForKey:@"match_criteria"] objectForKey:@"help"] allValues];
    self.language = [theLanguage objectAtIndex:0];
    self.ratings = [matchArray objectForKey:@"ratings"];
    
    
    UIControl *matchView = [self createCardView];
    //add the midle part too
    UIImageView *middleCard;
    UIView* middleView;
    UIImageView* bottomImage;
   
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 548)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 333)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 162, 297.5, 333)];
        //bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 495, 297.5, 28)]
        bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 494, 297.5, 28)];
        
        
    } else{
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 460)];
        
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 243)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 162, 297.5, 243)];
        bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 405, 297.5, 28)];
        
    }
    
    
    bottomImage.image = [UIImage imageNamed:@"cardback_bottom.png"];
    
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    [middleView addSubview:middleCard];
    [matchView addSubview:middleView];
    [matchView addSubview:bottomImage];
    
    UIButton *closeItButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeItButton.tag = 3333;
    [closeItButton setFrame:CGRectMake(16, 425, 267, 45.5)];
    [closeItButton addTarget:self action:@selector(makeOffer) forControlEvents:UIControlEventTouchUpInside];
    [closeItButton setBackgroundImage:[UIImage imageNamed:@"add_to_list.png"] forState:UIControlStateNormal];
    //[matchView addSubview:closeItButton];
    
    
    CGRect matchFrame = matchView.frame;
    matchFrame.size.height = matchFrame.size.height + 572;
    matchView.frame = matchFrame;
  
    [self.view addSubview:matchView];
    [self doMatchOnly:matchArray];
}


- (void) makeOffer {   
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selection_done" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.view.tag], @"index", [NSNumber numberWithBool:YES], @"is_selected",   nil]];
    
    /*ModalOfferCardsController *targetController = [[ModalOfferCardsController alloc] initWithNibName:@"ModalOfferCardsController" bundle:nil];
    targetController.theName = self.theName;
    targetController.helpMode = self.helpMode;
    targetController.theIndex = self.view.tag;
    targetController.modalPresentationStyle = UIModalPresentationFormSheet;
    targetController.modalTransitionStyle = UIModalTransitionStyleCoverVertical; //transition shouldn't matter
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:targetController];
    
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate.navigationController.view viewWithTag:928] removeFromSuperview];
    [appDelegate.navigationController presentViewController:navController animated:YES completion:nil];*/
}


- (void)viewDidLoad {
    //[super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    theTableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.matchLayout = [[MatchDataTableController alloc] initWithNibName:@"MatchDataTableController" bundle:nil];
    self.matchLayout.inverseOrder = helpMode;
    self.dummyTable = [[DummyNewTable alloc] initWithNibName:@"DummyNewTable" bundle:nil];
   
    [[NSNotificationCenter defaultCenter] addObserverForName:@"pop_profile" object:self.matchLayout queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        ModalProfileURLController *targetController = [[ModalProfileURLController alloc] init];
        targetController.modalPresentationStyle = UIModalPresentationFormSheet;
        targetController.modalTransitionStyle = UIModalTransitionStyleCoverVertical; //transition shouldn't matter
        targetController.theUrl = matchLayout.link;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:targetController];        
        
        iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.navigationController presentViewController:navController animated:YES completion:nil];

    }];
}


- (UIControl *)createCardView {
    
    UIControl *matchView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 297.5, 260)];
    matchView.backgroundColor = [UIColor clearColor];
    matchView.tag = 244;
    [matchView addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];
    
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    [matchView addSubview:topCard];
    
    
    UIView *middleBackGround = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 139)];
    UIImageView *middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 24)];
    middleCard.image = [UIImage imageNamed:@"cardback_middle.png"];
    middleBackGround.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardback_middle.png"]];
    [matchView addSubview:middleBackGround];
    
    
    UIView *middleBackGround2 = [[UIView alloc] initWithFrame:CGRectMake(0, 270, 297.5, 139)];
    UIImageView *middleCard2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 24)];
    middleCard2.image = [UIImage imageNamed:@"cardback_middle.png"];
    middleBackGround2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardback_middle.png"]];
    [matchView addSubview:middleBackGround];
  
    
    UIImageView *photoBG = [[UIImageView alloc] initWithFrame:CGRectMake(5, 25, 133.5, 133.5)];
    photoBG.image = [UIImage imageNamed:@"back_pictureChat.png"];
    AvatarImageView *asyncImageView = [[AvatarImageView alloc] initWithFrame:CGRectMake(5.25,5.25, 122, 122)];
    asyncImageView.userInteractionEnabled = NO;
    asyncImageView.tag = 12;
    //asyncImageView.layer.cornerRadius = 2.0;
    asyncImageView.layer.masksToBounds = YES;
    asyncImageView.displayUImage = true;
    [matchView addSubview:photoBG];
    [photoBG addSubview:asyncImageView];
   
    [asyncImageView checkIfImageExists:self.theOtherUrl theImageFrame:CGRectMake(0,0, 122, 122)];
    
    UILabel *nameBold = [[UILabel alloc] initWithFrame:CGRectMake(140,30, 150, 26)];
    nameBold.backgroundColor = [UIColor clearColor];
    nameBold.lineBreakMode = 0;
    nameBold.numberOfLines = 1;
    nameBold.font = [UIFont fontWithName:@"Delicious-Heavy" size:22.0];
    nameBold.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
    nameBold.textAlignment = NSTextAlignmentLeft;
    nameBold.text = [NSString stringWithFormat:@"%@",self.theName];
    [matchView addSubview:nameBold];
    
    UILabel *verifiedInfo = [[UILabel alloc] initWithFrame:CGRectMake(140, 40, 145, 80)];
    verifiedInfo.backgroundColor = [UIColor clearColor];
    verifiedInfo.lineBreakMode = 0;
    verifiedInfo.numberOfLines = 2;
    verifiedInfo.font = [UIFont fontWithName:@"Delicious-Roman" size:16.0];
    verifiedInfo.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
    verifiedInfo.textAlignment = NSTextAlignmentNatural;
    verifiedInfo.text = [NSString stringWithFormat:@"Verified %@ speaker", language];
    
    [matchView addSubview:verifiedInfo];
   
    UIImageView* verifiedSign = [[UIImageView alloc] initWithFrame:CGRectMake(260, 78, 24, 24)];
    verifiedSign.image = [UIImage imageNamed:@"check_verified.png"];
    [matchView addSubview:verifiedSign];
    
    LanguageRatingView *ratingView = [[LanguageRatingView alloc] initWithFrame:CGRectMake(140,106,32,31)];
    ratingView.backgroundColor = [UIColor clearColor];
    ratingView.tag = 81729;
    [matchView addSubview:ratingView];
    [ratingView setRating:[[self.ratings objectForKey:@"rating_score"] intValue]];
    
    return matchView;
    
}

- (void)doMatchLayout:(NSDictionary *)matchingArray {
    
    NSDictionary* matchingArray2 = [matchingArray objectForKey:@"match_criteria"];
    if ([matchingArray2 count] == 0) {
        NSMutableDictionary* finalRes = [[NSMutableDictionary alloc] init];
        //NSDictionary* locations = [self.otherUserData objectForKey:@"locations"];
        //NSDictionary* interested = [self.otherUserData objectForKey:@"interested"];
        //NSDictionary* help = [self.otherUserData objectForKey:@"help"];
        //[self quickSearch:@"locations" finalRes:finalRes searchArray:locations];
        //[self quickSearch:@"help" finalRes:finalRes searchArray:help];
        //[self quickSearch:@"interested" finalRes:finalRes searchArray:interested];
        matchingArray2 = finalRes;
    }
    
    NSDictionary* theLocs = [matchingArray2 objectForKey:@"locations"];
    dummyTable.locations = theLocs;
    dummyTable.help = [matchingArray2 objectForKey:@"help"];
    dummyTable.interested = [matchingArray2 objectForKey:@"interested"];
    dummyTable.paymentType = [matchingArray objectForKey:@"paymentType"];
    dummyTable.interest = [matchingArray objectForKey:@"personalInterests"];
  
    if ([[matchingArray objectForKey:@"bio"] length] > 0) dummyTable.about = [matchingArray objectForKey:@"bio"];
    //matchLayout.link = @"https://www.facebook.com/adrian.mont";
   
    if ([self.interests count] > 0){
        NSMutableArray* theInterests = [NSMutableArray new];
        for (int a = 0; a < [self.interests count]; a++) {
            NSDictionary* theDic = [self.interests objectAtIndex:a];
            //[theInterests appendString:[NSString stringWithFormat:@"%@, ", [theDic objectForKey:@"name"]]];
            [theInterests addObject:theDic];
            if (a == 3) break;
        }
        dummyTable.interest = theInterests;
    }
}


- (void) doMatchOnly:(NSDictionary*) matchArray  {
    
    [self doMatchLayout:matchArray];
    CGRect layoutFrame = self.matchLayout.view.frame;
    layoutFrame.origin.x = 17;
    layoutFrame.origin.y = 165;
    layoutFrame.size.width = 264;
    CGFloat finHeight = [self.matchLayout calculateLayout];
    
    CGRect matchFrame = self.dummyTable.view.frame;
    CGFloat finHeightDummy = [self.dummyTable calculateLayout];
    matchFrame.origin.x = 17;
    matchFrame.origin.y = 165;
    matchFrame.size.width = 264;
    matchFrame.size.height = finHeightDummy;
    self.dummyTable.view.frame = matchFrame;
    
    //finHeight - 32;
    layoutFrame.size.height = finHeight;
    self.matchLayout.view.frame = layoutFrame;
    self.matchLayout.inverseOrder = helpMode;
    //[self.view addSubview:matchLayout.view];
    [self.view addSubview:self.dummyTable.view];
    self.dummyTable.theTable.scrollEnabled = NO;
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
