//
//  LocationSearchController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "LocationSearchDummy.h"
#import "PeopleHuntRequests.h"
//#import "Mixpanel.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationSearchDummy ()

@end

@implementation LocationSearchDummy
@synthesize orderedLocations;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.orderedLocations = [NSArray new];
    self.theDictionary = [[[NSMutableDictionary  alloc] init] retain];
    [self.theDictionary setValue:@"assdasd" forKey:@"as"];
    /*
    self.view.backgroundColor = [UIColor clearColor];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.tag = 727281;
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *coverSearch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    coverSearch.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *pageControl1;
    UIImageView *pageControl2;
    UIImageView *pageControl3;
    UIImageView *pageControl4;
    UIImageView *titleText;
    UIImageView *bgTitle;
    UIImageView *iconLocation;
    UIImageView *lineDotted;
    //UIImageView *background;
    UIImageView *middleCard;
    UIView *middleView;
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 548)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 472)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 472)];
        pageControl1 = [[UIImageView alloc] initWithFrame:CGRectMake(115.25, 16, 13, 13)];
        pageControl1.tag = 19191;
        pageControl2 = [[UIImageView alloc] initWithFrame:CGRectMake(133.25, 16, 13, 13)];
        pageControl2.tag = 19192;
        pageControl3 = [[UIImageView alloc] initWithFrame:CGRectMake(151.25, 16, 13, 13)];
        pageControl3.tag = 19193;
        pageControl4 = [[UIImageView alloc] initWithFrame:CGRectMake(169.25, 16, 13, 13)];
        pageControl4.tag = 19194;
        titleText = [[UIImageView alloc] initWithFrame:CGRectMake(30, 21, 195.5, 42.5)];
        
        bgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 263.5, 64.5)];
        iconLocation = [[UIImageView alloc] initWithFrame:CGRectMake(238, 24, 32.5, 39.5)];
        lineDotted = [[UIImageView alloc] initWithFrame:CGRectMake(20, 137, 237.5, 3.5)];
        
    } else {
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 460)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 384)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 384)];
        pageControl1 = [[UIImageView alloc] initWithFrame:CGRectMake(115.25, 12, 13, 13)];
        pageControl1.tag = 19191;
        pageControl2 = [[UIImageView alloc] initWithFrame:CGRectMake(133.25, 12, 13, 13)];
        pageControl2.tag = 19192;
        pageControl3 = [[UIImageView alloc] initWithFrame:CGRectMake(151.25, 12	, 13, 13)];
        pageControl3.tag = 19193;
        pageControl4 = [[UIImageView alloc] initWithFrame:CGRectMake(169.25, 12, 13, 13)];
        pageControl4.tag = 19194;
        titleText = [[UIImageView alloc] initWithFrame:CGRectMake(30, 12, 195.5, 42.5)];
        
        bgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(17, 0, 263.5, 64.5)];
        iconLocation = [[UIImageView alloc] initWithFrame:CGRectMake(238, 14, 32.5, 39.5)];
        lineDotted = [[UIImageView alloc] initWithFrame:CGRectMake(20, 137, 237.5, 3.5)];
        
    }
    
    
    
    pageControl1.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl2.image = [UIImage imageNamed:@"circle_orange.png"];
    pageControl3.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl4.image = [UIImage imageNamed:@"circle_gray.png"];
    titleText.image = [UIImage imageNamed:@"Where-do-you-want-to--find-people-2.png"];
   
    
    
    bgTitle.image = [UIImage imageNamed:@"blue3.png"];
    iconLocation.image = [UIImage imageNamed:@"icon_anchor.png"];
    lineDotted.image = [UIImage imageNamed:@"line.png"];
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    //background.image = [UIImage imageNamed:@"background.png"];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setFrame:CGRectMake(244.75, 117.5, 42, 42)];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refreshNew.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(rotateElements) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)];
    topview.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:95/255.0 blue:95.0/255.0 alpha:1];
     */
     
    
    //BASE COMMENT
    /*NSArray* tempArray = [[self.cachedSearchData allValues] mutableCopy];
    NSRange theRange = NSMakeRange(0, 4);
    NSArray* theFour = [tempArray subarrayWithRange:theRange];
    self.searchData = [theFour mutableCopy];
    [self.theTable reloadData];*/
    
    /*
    [topCard addSubview:pageControl1];
    [topCard addSubview:pageControl2];
    [topCard addSubview:pageControl3];
    [topCard addSubview:pageControl4];
    
    [middleView addSubview:middleCard];
    [middleView addSubview:bgTitle];
    [middleView addSubview:titleText];
    [middleView addSubview:iconLocation];
    [middleView addSubview:lineDotted];
    [middleView addSubview:refreshBtn];
     */
    
    //BASE COMMENT
    //[self.allHeader addSubview:topCard];
    //[self.allHeader addSubview:middleView];
    
    //if ([self.selectedData count] > 0) [self resizeLayout:[self.selectedData count]];
}




/*
 - (void) hidePageControllers {
 [self.view viewWithTag:19191].hidden = true;
 [self.view viewWithTag:19192].hidden = true;
 [self.view viewWithTag:19193].hidden = true;
 [self.view viewWithTag:19194].hidden = true;
 }

 
- (void) retrieveLocationData {
    PeopleHuntRequests *stat = [[PeopleHuntRequests alloc] init];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:stat queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        
        NSArray* locations = (NSArray*)[notification userInfo];
        NSLog(@"LOCATIONS %@", locations);
        NSMutableDictionary* dicLocations = [[NSMutableDictionary alloc] init];
        for (NSDictionary* locDic in locations) {
            [dicLocations setObject:[locDic objectForKey:@"description"] forKey:[locDic objectForKey:@"id"]];
        }
        
        self.cachedSearchData = dicLocations;
        self.sortedData = [locations mutableCopy];
        self.orderedLocations = [dicLocations allValues];
        NSArray* tempArray = [dicLocations allValues];
        NSRange theRange = NSMakeRange(0, 4);
        NSArray* theFour = [tempArray subarrayWithRange:theRange];
        self.searchData = [theFour mutableCopy];
        [self.theTable reloadData];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"second_load" object:self];
        
    }];
    [stat retrieveAllLocations];
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
    //NSLog(@"SECTION %i row %i", [indexPath section], [indexPath row]);
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *boxCheck = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 21.5, 21.5)] ;
        [boxCheck setImage:[UIImage imageNamed:@"checkbox.png"]];
        [cell.contentView addSubview:boxCheck];
        
        UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(30,13,233,18)];
        place.tag = 2345;
        place.font = [UIFont fontWithName:@"Delicious-Roman" size:18.0];
        place.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        place.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:place];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
        [cell setSelectedBackgroundView:bgColorView];
    } else {
        ((UILabel*)[cell.contentView viewWithTag:2345]).text = @"";
    }
    
    NSLog(@"data %@", [self.searchData objectAtIndex:[indexPath row]]);
    ((UILabel*)[cell.contentView viewWithTag:2345]).text = [[self.searchData objectAtIndex:[indexPath row]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Did select Location!"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_matchconnections"];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}



- (void) sortLocations {
    NSDictionary *storedLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_location"];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[[storedLocation objectForKey:@"latitude"] doubleValue] longitude:[[storedLocation objectForKey:@"longitude"] doubleValue]];
    NSMutableArray* locDist = [[NSMutableArray alloc] init];
    for (NSDictionary *theLoc in self.sortedData) {
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[[theLoc objectForKey:@"latitude"] doubleValue] longitude:[[theLoc objectForKey:@"longitude"] doubleValue]];
        CLLocationDistance dist = [currentLocation distanceFromLocation:loc2];
        //NSLog(@"RES DIST %f", dist);
        [locDist addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:dist], @"dist", [theLoc objectForKey:@"description"], @"description",[theLoc objectForKey:@"id"], @"id", nil]];
    }
    
    
    NSArray* sortedDist = [locDist sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        double first = [[a objectForKey:@"dist"] doubleValue];
        double second = [[b objectForKey:@"dist"] doubleValue];
        //NSLog(@"COMPARE DIST %f  %f", first, second);
        if ( first < second ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( first > second ) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    NSMutableArray* resData = [[NSMutableArray alloc] init];
    for (NSDictionary *loc in sortedDist) {
        //NSLog(@"DES %f %@",[[loc objectForKey:@"dist"] doubleValue], [loc objectForKey:@"description"]);
        [resData addObject:[loc objectForKey:@"description"]];
    }
    
    self.orderedLocations = resData;
    NSArray* tempArray = resData;
    NSRange theRange = NSMakeRange(0, 4);
    NSArray* theFour = [tempArray subarrayWithRange:theRange];
    self.searchData = [theFour mutableCopy];
    [self.theTable reloadData];
    
}


- (void)rotateElements {
    self.page++;
    NSArray* tempArray = self.orderedLocations;
    NSLog(@"TEMP ARRAy %@", tempArray);
    int top = self.page * 4;
    int countSeg =  ([tempArray count] - top);
    NSLog(@"C %i", countSeg);
    if (countSeg > 0){
        NSLog(@"TOP %i %i %i", top, [tempArray count], (top - [tempArray count]));
        int segment = 4;
        int offsetCount = [tempArray count] - top;
        if (offsetCount < 4) segment = (top - [tempArray count]);
        if (segment < 0) segment = 4;
        NSLog(@"SEG %i", segment);
        NSRange theRange = NSMakeRange(top - 4, segment);
        NSArray* theFour = [tempArray subarrayWithRange:theRange];
        self.searchData = [theFour mutableCopy];
        [self.theTable reloadData];
    }
}


- (void)resetTable {
    [self.view viewWithTag:2211728].hidden = false;
    [self.searchData removeAllObjects];
    NSArray* tempArray = self.orderedLocations;
    NSRange theRange = NSMakeRange(0, 4);
    NSArray* theFour = [tempArray subarrayWithRange:theRange];
    self.searchData = [theFour mutableCopy];
    [self.theTable reloadData];
    self.theTable.tableFooterView = nil;
}


- (void) setSearchLabel:(UILabel*) theSeachLabel {
    theSeachLabel.text = @"You are the first person who wants to find people in this location - add it!";
}
*/


- (void) testDummy {
    NSLog(@"TEST TES %@ %@", self.orderedLocations, self.theDictionary);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
