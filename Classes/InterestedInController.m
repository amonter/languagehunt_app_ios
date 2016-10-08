//
//  InterestedInController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "InterestedInController.h"
#import "PeopleHuntRequests.h"
#import "LanguageSelectCell.h"
#import "iphoneCrowdAppDelegate.h"

@interface InterestedInController ()

@end

@implementation InterestedInController
@synthesize interestedAgregate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor clearColor];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *coverSearch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    coverSearch.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *pageControl1;
    UIImageView *pageControl2;
    UIImageView *pageControl3;
    UIImageView *pageControl4;
    UIImageView *titleInterestsText;
    UIImageView *bgTitle;
    UIImageView *iconInterests;
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
        titleInterestsText = [[UIImageView alloc] initWithFrame:CGRectMake(47, 32, 185, 24)];
        
        bgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 263.5, 64.5 )];
        iconInterests = [[UIImageView alloc] initWithFrame:CGRectMake(238, 24, 31, 39.5)];
        lineDotted = [[UIImageView alloc] initWithFrame:CGRectMake(20, 137, 237.5, 3.5)];
        
    }else{
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 460)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 384)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 384)];
        pageControl1 = [[UIImageView alloc] initWithFrame:CGRectMake(115.25, 12, 13, 13)];
        pageControl2 = [[UIImageView alloc] initWithFrame:CGRectMake(133.25, 12, 13, 13)];
        pageControl3 = [[UIImageView alloc] initWithFrame:CGRectMake(151.25, 12, 13, 13)];
        pageControl4 = [[UIImageView alloc] initWithFrame:CGRectMake(169.25, 12, 13, 13)];
        titleInterestsText = [[UIImageView alloc] initWithFrame:CGRectMake(47, 32, 185, 24)];
        
        bgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(17, 0, 263.5, 64.5)];
        iconInterests = [[UIImageView alloc] initWithFrame:CGRectMake(238, 14, 31, 39.5)];
        lineDotted = [[UIImageView alloc] initWithFrame:CGRectMake(20, 137, 237.5, 3.5)];
        
    }
       
    
    pageControl1.image = [UIImage imageNamed:@"circle_orange.png"];
    pageControl2.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl3.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl4.image = [UIImage imageNamed:@"circle_gray.png"];
    titleInterestsText.image = [UIImage imageNamed:@"i_want_to_practice.png"];
    
    UILabel *nameLabel;
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.75, 14, 192.5, 53.5)];
    nameLabel.tag = 7414;
    nameLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:21.5];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.backgroundColor = [UIColor clearColor];
  
    
    bgTitle.image = [UIImage imageNamed:@"blue3.png"];
    iconInterests.image = [UIImage imageNamed:@"icon_pin.png"];
    lineDotted.image = [UIImage imageNamed:@"line.png"];
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    //background.image = [UIImage imageNamed:@"background.png"];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setFrame:CGRectMake(244.75, 117.5, 42, 42)];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refreshNew.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(rotateElements) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)];
    topview.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:95/255.0 blue:95.0/255.0 alpha:1];
    // Do any additional setup after loading the view from its nib.
    
    //[self.view addSubview:background];
    [self.allHeader addSubview:topCard];
    [self.allHeader addSubview:middleView];
    self.search.hidden = true;
    
    //TODO:add the my language is not here feature
    UIView* missingLang = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    missingLang.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(missingLanguage)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"My Language is Missing" forState:UIControlStateNormal];
    button.frame = CGRectMake(25.0, 5.0, 200.0, 40.0);
    [missingLang addSubview:button];
    
    self.theTable.tableFooterView = missingLang;
    
    [middleView addSubview:middleCard];
    [middleView addSubview:bgTitle];
    [middleView addSubview:titleInterestsText];
    [middleView addSubview:nameLabel];
    [middleView addSubview:iconInterests];
   
}


- (void) missingLanguage {
    
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [theDelegate showMissingLanguageView];
    
    
}

- (void) loadInterestedInData {
    PeopleHuntRequests *stat = [[PeopleHuntRequests alloc] init];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:stat queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        
        NSArray* topicData = (NSMutableArray*) [[notification userInfo] mutableCopy];
        NSMutableDictionary* cachedDic = [[NSMutableDictionary alloc] init];
        for (NSDictionary* topicDic in topicData) {            
            [cachedDic setObject:[topicDic objectForKey:@"description"] forKey:[topicDic objectForKey:@"id"]];
            [self.sortedData addObject:[topicDic objectForKey:@"description"]];
        }        
       
        self.cachedSearchData = cachedDic;
        //NSRange theRange = NSMakeRange(0, 4);
        //NSArray* theFour = [self.sortedData subarrayWithRange:theRange];
        self.searchData = self.sortedData;
        [self.theTable reloadData];       
        //first_load
		[[NSNotificationCenter defaultCenter] postNotificationName:@"first_load" object:self];
    }];
    
    [stat retrieveInterestedInData];
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
    LanguageSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString* theElement = [[self.searchData objectAtIndex:[indexPath row]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (cell == nil) {
        
        cell = [[LanguageSelectCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        
        UIImageView *boxCheck = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 21.5, 21.5)] ;
        [boxCheck setImage:[UIImage imageNamed:@"checkbox.png"]];
        //[cell.contentView addSubview:boxCheck];
        
        UILabel *interest = [[UILabel alloc] initWithFrame:CGRectMake(30,0,220,cell.frame.size.height)];
        interest.tag = 44555;
        interest.font = [UIFont fontWithName:@"Delicious-Roman" size:18.0];
        interest.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        interest.backgroundColor = [UIColor clearColor];
        interest.lineBreakMode = NSLineBreakByWordWrapping;
        interest.numberOfLines = 0;
        [cell.contentView addSubview:interest];
        
        UIImageView* buttomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buttom_dotted.png"]];
        buttomLine.frame = CGRectMake(0, 39, 300, 1);
        [cell.contentView addSubview:buttomLine];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
        [cell setSelectedBackgroundView:bgColorView];
        //check of the element is repeated
        NSLog(@"SELECTED %@", self.selectedData);
        for (NSString* existingElement in self.selectedData){
            if ([existingElement isEqualToString:theElement]){
                //[self.selectedDataTable addTheElement:theElement isNew:NO];
                [self setCellSelected:cell];
            }
        }
    } 
    
    NSLog(@"data %@", [self.searchData objectAtIndex:[indexPath row]]);
    ((UILabel*)[cell.contentView viewWithTag:44555]).text = theElement;
    
      
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        self.interestedAgregate = self.interestedAgregate + [[[notification userInfo] objectForKey:@"interested"] intValue];
        infoLabel.text = [NSString stringWithFormat:@"%i PEOPLE CAN HELP YOU NOW", self.interestedAgregate];
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

- (void) setSearchLabel:(UILabel*) theSeachLabel {
    theSeachLabel.text = @"You are the first person hunting for this - add it!";
}



- (void) nextCardAction {
    NSLog(@"NEXT CARD");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tap_done" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"done_language" object:self];
}





/*
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    [self.search resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"display_profile"];
    NSString* theElement = [self.searchData objectAtIndex:[indexPath row]];
    self.selectedDataTable.view.hidden = false;
    [self.selectedDataTable addTheElement:theElement isNew:NO];
    NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
    [deleteArray addObject:indexPath];
    //delete the element
    [self.searchData removeObjectAtIndex:[indexPath row]];
    [self.theTable beginUpdates];
    [self.theTable deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
    [self.theTable endUpdates];
}*/



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
