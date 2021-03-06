//
//  OfferController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/23/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "OfferController.h"
#import "PeopleHuntRequests.h"

@interface OfferController ()

@end

@implementation OfferController
@synthesize allHeader, theName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.numberAdds = -1;
    self.view.backgroundColor = [UIColor clearColor];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *coverSearch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    coverSearch.image = [UIImage imageNamed:@"cardback_top.png"];
    
    self.proficiencyLevels = [[NSMutableDictionary alloc] init];
    
    UIImageView *pageControl1;
    UIImageView *pageControl2;
    UIImageView *pageControl3;
    UIImageView *pageControl4;
    UIImageView *titleKnow;
    UIImageView *bgTitle;
    UIImageView *iconKnowledge;
    UIImageView *lineDotted;
    //UIImageView *background;
    UIImageView *middleCard;
    UIView* middleView;
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 548)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 472)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 472)];
        pageControl1 = [[UIImageView alloc] initWithFrame:CGRectMake(115.25, 16, 13, 13)];
        pageControl2 = [[UIImageView alloc] initWithFrame:CGRectMake(133.25, 16, 13, 13)];
        pageControl3 = [[UIImageView alloc] initWithFrame:CGRectMake(151.25, 16, 13, 13)];
        pageControl4 = [[UIImageView alloc] initWithFrame:CGRectMake(169.25, 16, 13, 13)];
        titleKnow = [[UIImageView alloc] initWithFrame:CGRectMake(40.5, 25.25, 174, 40)];
        bgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 263.5, 64.5)];
        iconKnowledge = [[UIImageView alloc] initWithFrame:CGRectMake(237.5, 23.5, 32, 38.5)];
        lineDotted = [[UIImageView alloc] initWithFrame:CGRectMake(20, 137, 237.5, 3.5)];
        
    }else{
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 460)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 384)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 384)];
        pageControl1 = [[UIImageView alloc] initWithFrame:CGRectMake(115.25, 12, 13, 13)];
        pageControl2 = [[UIImageView alloc] initWithFrame:CGRectMake(133.25, 12, 13, 13)];
        pageControl3 = [[UIImageView alloc] initWithFrame:CGRectMake(151.25, 12, 13, 13)];
        pageControl4 = [[UIImageView alloc] initWithFrame:CGRectMake(169.25, 12, 13, 13)];
        titleKnow = [[UIImageView alloc] initWithFrame:CGRectMake(40.5, 16.25, 174, 40)];
        bgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(17, 0, 263.5, 64.5)];
        iconKnowledge = [[UIImageView alloc] initWithFrame:CGRectMake(237.5, 13.5, 32, 38.5)];
        lineDotted = [[UIImageView alloc] initWithFrame:CGRectMake(20, 137, 237.5, 3.5)];
        
    }
    
    
    
    pageControl1.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl2.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl3.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl4.image = [UIImage imageNamed:@"circle_orange.png"];
    
    
    UILabel *nameLabel;
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,10,196,62.5)];
    nameLabel.tag = 7414;
    nameLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:21.5];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.backgroundColor = [UIColor clearColor];
   
    NSArray* theSplit = [theName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    nameLabel.text = [NSString stringWithFormat:@"What can you offer %@?", [theSplit objectAtIndex:0]];
    
    
    titleKnow.image = [UIImage imageNamed:@"topics_what.png"];
    bgTitle.image = [UIImage imageNamed:@"blue3.png"];
    iconKnowledge.image = [UIImage imageNamed:@"icon_light.png"];
    lineDotted.image = [UIImage imageNamed:@"line.png"];
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    //background.image = [UIImage imageNamed:@"background.png"];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setFrame:CGRectMake(244.75, 117.5, 42, 42)];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refreshNew.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(rotateElements) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)];
    topview.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:95/255.0 blue:95.0/255.0 alpha:1];
    
    [self.allHeader addSubview:topCard];
    [self.allHeader addSubview:middleView];
    
    [topCard addSubview:pageControl1];
    [topCard addSubview:pageControl2];
    [topCard addSubview:pageControl3];
    [topCard addSubview:pageControl4];
    
    [middleView addSubview:middleCard];
    [middleView addSubview:bgTitle];
    [middleView addSubview:titleKnow];
    [middleView addSubview:iconKnowledge];
    [middleView addSubview:lineDotted];
    [middleView addSubview:refreshBtn];
    
    
}

- (void) retrieveOffers {
    /*PeopleHuntRequests *stat = [[PeopleHuntRequests alloc] init];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:stat queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        
        NSArray* topicData = (NSMutableArray*) [[notification userInfo] mutableCopy];
        NSMutableDictionary* cachedDic = [[NSMutableDictionary alloc] init];
        for (NSDictionary* topicDic in topicData) {
            [cachedDic setObject:[topicDic objectForKey:@"description"] forKey:[topicDic objectForKey:@"id"]];
            [self.sortedData addObject:[topicDic objectForKey:@"description"]];
        }
        
        self.cachedSearchData = cachedDic;
        NSRange theRange = NSMakeRange(0, 4);
        NSArray* theFour = [self.sortedData subarrayWithRange:theRange];
        NSLog(@"FOUR FOUR %@", theFour);
        self.searchData = [theFour mutableCopy];
        [self.theTable reloadData];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"offer_load" object:self];
    }];
    [stat retrieveOffers];*/
    
    NSMutableDictionary* cachedDic = [[NSMutableDictionary alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"skills"]){
        for (NSDictionary* topicDic in [[[NSUserDefaults standardUserDefaults] objectForKey:@"skills"] objectForKey:@"values"]) {
            [cachedDic setObject:[[topicDic objectForKey:@"skill"] objectForKey:@"name"] forKey:[topicDic objectForKey:@"id"]];
            [self.sortedData addObject:[[topicDic objectForKey:@"skill"] objectForKey:@"name"]];
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"likes"]){
        for (NSDictionary* topicDic in [[[NSUserDefaults standardUserDefaults] objectForKey:@"likes"] objectForKey:@"data"]) {
            [cachedDic setObject:[topicDic objectForKey:@"name"] forKey:[topicDic objectForKey:@"id"]];
            [self.sortedData addObject:[topicDic objectForKey:@"name"]];
        }
    }
    
    self.cachedSearchData = cachedDic;
    NSRange theRange = NSMakeRange(0, 4);
    NSArray* theFour = [self.sortedData subarrayWithRange:theRange];
    NSLog(@"FOUR FOUR %@", theFour);
    self.searchData = [theFour mutableCopy];
    [self.theTable reloadData];
    
}


- (void) pullFastData:(int) feelerId {
    PeopleHuntRequests* req = [[PeopleHuntRequests alloc] init];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        
        CGRect initial = CGRectMake(0, 417, 320, 60);
        CGRect final = CGRectMake(0, 357, 320, 60);
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.0f && screenHeight == 568.0f) {
            initial = CGRectMake(0, 510, 320, 60);
            final = CGRectMake(0, 447, 320, 60);
        }
        UIView *contentView = [[UIView alloc] initWithFrame:initial];
        contentView.backgroundColor = [UIColor lightGrayColor];
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,60)];
        infoLabel.backgroundColor = [UIColor orangeColor];
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.numberOfLines = 0;
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19];
        self.aggregateHelpWith = self.aggregateHelpWith + [[[notification userInfo] objectForKey:@"help"] intValue];
        infoLabel.text = [NSString stringWithFormat:@"YOU CAN HELP %i PEOPLE SO FAR", self.aggregateHelpWith];
        [contentView addSubview:infoLabel];
        [[[self.view superview] superview] addSubview:contentView];
        
        
        [UIView animateWithDuration:0.8f
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction|
                                     UIViewAnimationOptionBeginFromCurrentState)
                         animations:^(void) {
                             contentView.frame = final;
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.8f
                                                   delay:1.5
                                                 options:(UIViewAnimationOptionAllowUserInteraction|
                                                          UIViewAnimationOptionBeginFromCurrentState)
                                              animations:^(void) {
                                                  contentView.frame = initial;
                                              }
                                              completion:^(BOOL finished) {
                                                  //contentView.alpha = 0.0;
                                              }];
                         }];
        
        
    }];
    [req retrieveFastFeeler:feelerId];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.searchData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *boxCheck = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 21.5, 21.5)];
        boxCheck.image = [UIImage imageNamed:@"checkbox.png"];
        [cell.contentView addSubview:boxCheck];
        
        UILabel *help = [[UILabel alloc] initWithFrame:CGRectMake(30,0,220,cell.frame.size.height)];
        help.tag = 23561;
        help.font = [UIFont fontWithName:@"Delicious-Roman" size:18.0];
        help.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        help.backgroundColor = [UIColor clearColor];
        help.lineBreakMode = NSLineBreakByWordWrapping;
        help.numberOfLines = 0;
        [cell.contentView addSubview:help];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
        [cell setSelectedBackgroundView:bgColorView];
    }
    
    // Configure the cell...
    ((UILabel*)[cell.contentView viewWithTag:23561]).text = [[self.searchData objectAtIndex:[indexPath row]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Seach data %@", [self.searchData class]);
    NSString *cellText = [[self.searchData objectAtIndex:[indexPath row]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    UIFont *cellFont = [UIFont fontWithName:@"Delicious-Roman" size:18.0];
    CGSize constraintSize = CGSizeMake(220.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    //NSLog(@"labelSize %f", labelSize.height);
    if (labelSize.height==21) return labelSize.height+20;
    
    if (labelSize.height==42) return labelSize.height+10;
    
    if (labelSize.height==63)  return labelSize.height+25;
    
    if (labelSize.height==84)  return labelSize.height+30;
    
    else return labelSize.height+20;
}


- (void) addTheFeeler {
    NSLog(@"NUMBER ADDS %i", self.numberAdds);
    [super addTheFeeler];
}

- (void) nextCardAction {
    if (self.numberAdds == -1){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Would you like to help with one more thing?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"No", nil];
        [alertView show];
    }
    
    if (self.numberAdds == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"done_offer" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"index", self.view.tag, nil]];
    }
    
    self.numberAdds++;   
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		//NO
        [[NSNotificationCenter defaultCenter] postNotificationName:@"done_offer" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.view.tag], @"index", nil]];
	} else {
        
	}
}

- (void) setSearchLabel:(UILabel*) theSeachLabel {
    theSeachLabel.text = @"You are the first person who can help with this awesomeness - add it!";
}


@end
