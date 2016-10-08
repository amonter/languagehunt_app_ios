//
//  HubLocationsController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 12/29/13.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "HubLocationsController.h"
#import "iphoneCrowdAppDelegate.h"

@interface HubLocationsController ()

@end

@implementation HubLocationsController
@synthesize underScroll, allHeader, theTable, bottomImage, middleImage, hubLocation, selectedData, delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:109/255.0 green:105/255.0 blue:96/255.0 alpha:1.0];
    self.underScroll.backgroundColor = [UIColor clearColor];
    underScroll.scrollEnabled = true;
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line2.png"]];
    [self.theTable setSeparatorColor:color];
   
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"screenHeight %f", screenHeight);
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        self.bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 495, 297.5, 28)];
        self.middleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 192, 297.5, 173)];
        [underScroll setContentSize:CGSizeMake(264, 760)];
    }else{
        self.bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 405, 297.5, 28)];
        self.middleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 192, 297.5, 173)];
        [underScroll setContentSize:CGSizeMake(264, 650)];
    }
    self.bottomImage.image = [UIImage imageNamed:@"cardback_bottom.png"];
    [self.underScroll addSubview:self.bottomImage];
    
    
    
    self.middleImage.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    [self.underScroll addSubview:self.middleImage];
    
    [self.underScroll bringSubviewToFront:self.theTable];
    
    
    CGRect underScrollFrame = self.underScroll.frame;
    underScrollFrame.size.width = 297.5;
    underScroll.frame = underScrollFrame;
    
    CGRect tableFrame = self.theTable.frame;
    tableFrame.size.width = 256;
    theTable.frame = tableFrame;    
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.tag = 727281;
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    
    
    UIImageView *pageControl1;
    UIImageView *pageControl2;
    UIImageView *pageControl3;
    UIImageView *pageControl4;
    UIImageView *titleText;
    UIImageView *captionText = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 90, 243, 33.5)];
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
        titleText = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 263, 63)];
        
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
        titleText = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 263, 63)];
        
        bgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(17, 0, 263.5, 64.5)];
        iconLocation = [[UIImageView alloc] initWithFrame:CGRectMake(238, 14, 32.5, 39.5)];
        lineDotted = [[UIImageView alloc] initWithFrame:CGRectMake(20, 137, 237.5, 3.5)];
        
    }
    
    
    
    pageControl1.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl2.image = [UIImage imageNamed:@"circle_gray.png"];
    pageControl3.image = [UIImage imageNamed:@"circle_orange.png"];
    pageControl4.image = [UIImage imageNamed:@"circle_gray.png"];
    titleText.image = [UIImage imageNamed:@"hub_copy2.png"];
    captionText.image = [UIImage imageNamed:@"change_locs2.png"];
    
    bgTitle.image = [UIImage imageNamed:@"blue3.png"];
    iconLocation.image = [UIImage imageNamed:@"icon_anchor.png"];
    lineDotted.image = [UIImage imageNamed:@"line.png"];
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    //background.image = [UIImage imageNamed:@"background.png"];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setFrame:CGRectMake(244.75, 117.5, 42, 42)];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refreshNew.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(rotateElements) forControlEvents:UIControlEventTouchUpInside];    
    
    
    [topCard addSubview:pageControl1];
    [topCard addSubview:pageControl2];
    [topCard addSubview:pageControl3];
    [topCard addSubview:pageControl4];
    
    [middleView addSubview:middleCard];
    [middleView addSubview:bgTitle];
    [middleView addSubview:titleText];
    [middleView addSubview:captionText];
    [middleView addSubview:iconLocation];
    [middleView addSubview:lineDotted];
    //[middleView addSubview:refreshBtn];
    
    [self.allHeader addSubview:topCard];
    [self.allHeader addSubview:middleView];
    
}


- (void) addFirstHubLocation {
        UIView *theFooter = self.theTable.tableFooterView;
        if (theFooter == nil){
            UILabel *congratsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 221, 20)];
            congratsLabel.backgroundColor = [UIColor clearColor];
            congratsLabel.textColor = [UIColor colorWithRed:244/255.0 green:122/255.0 blue:34/255.0 alpha:1.0];
            congratsLabel.textAlignment = UITextAlignmentCenter;
            congratsLabel.font = [UIFont fontWithName:@"FreightSans Bold" size:20.0];
            congratsLabel.text = @"We Can Help";

            UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 181, 70)];
            searchLabel.tag = 288102;
            searchLabel.backgroundColor = [UIColor clearColor];
            searchLabel.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1.0];
            searchLabel.numberOfLines = 0;
            searchLabel.lineBreakMode = UILineBreakModeWordWrap;
            searchLabel.textAlignment = UITextAlignmentCenter;
            searchLabel.font = [UIFont fontWithName:@"FreightSans Bold" size:15.0];

            UILabel *feelerName = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 181, 20)];
            feelerName.tag = 7776;
            feelerName.textAlignment = UITextAlignmentCenter;
            feelerName.backgroundColor = [UIColor clearColor];
            feelerName.textColor = [UIColor colorWithRed:244/255.0 green:122/255.0 blue:34/255.0 alpha:1.0];
            feelerName.font = [UIFont fontWithName:@"FreightSans Bold" size:10.0];
            
            NSArray* keysInterested = [[selectedData objectForKey:@"interested"] allKeys];
            NSArray* locations = [selectedData objectForKey:@"locations"];
            NSMutableArray* interestsArray = [[NSMutableArray alloc] init];
            NSMutableArray* locationsArray = [[NSMutableArray alloc] init];
            for (id key in keysInterested) {
                [interestsArray addObject:[[selectedData objectForKey:@"interested"] objectForKey:key]];
            }
            for (NSDictionary* locationDic in locations) {
                [locationsArray addObject:[locationDic objectForKey:@"location"]];
            }
            
            NSString* textConnect = [NSString stringWithFormat:@"You are going to be the first person who wants to make or do \"%@\" in \"%@\"\nWe can help!", [interestsArray componentsJoinedByString:@", "], [locationsArray componentsJoinedByString:@", "]];
            searchLabel.text = textConnect;

            UIFont *cellFont = [UIFont fontWithName:@"FreightSans Bold" size:15.0];
            CGSize constraintSize = CGSizeMake(181.0f, MAXFLOAT);
            CGSize labelSize = [textConnect sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
            
            UIView *addFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 256, 200)];
            addFooter.backgroundColor = [UIColor clearColor];

            UIImageView *backgroundSearch = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 5, 221, 200.5)];
            backgroundSearch.image = [UIImage imageNamed:@"papernote_small.png"];
            [searchLabel sizeToFit];

            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(78, labelSize.height + 60, 99, 27.5)];
            [button setImage:[UIImage imageNamed:@"help_me.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(sendTheMessage:) forControlEvents:UIControlEventTouchUpInside];
            [addFooter addSubview:backgroundSearch];
            [backgroundSearch addSubview:congratsLabel];
            [backgroundSearch addSubview:searchLabel];
            [backgroundSearch addSubview:feelerName];
            [addFooter addSubview:button];
            self.theTable.tableFooterView = addFooter;
        }
}

- (void) sendTheMessage:(id) sender {
    
    ((UIButton*)sender).enabled = false;
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([theDelegate.protocol checkStreamStatus]) {
        UILabel* theText = (UILabel*)[self.view viewWithTag:288102];
        NSString* realText = [theText.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];        
        NSString *msgProt = [NSString stringWithFormat:@"40:%i:%@:%i", 7, realText, 1];
        NSLog(@"Sending %@", msgProt);
        [theDelegate.protocol sendMessage:msgProt];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"We will find someone to help you, and we will contact you asap!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    } else {
        NSLog(@"The stream is closed for sure");
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.hubLocation count];
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UIFont *font = [UIFont fontWithName:@"Delicious-Roman" size:18.0];
    CGSize withinsize = CGSizeMake(233, 3000); //1000 is just a large number. could be 500 as well
    
    NSDictionary* hubLocationDics = [self.hubLocation objectAtIndex:[indexPath row]];
    NSArray* theKeys = [hubLocationDics allKeys];
    NSString* copy = [[[hubLocationDics objectForKey:[theKeys objectAtIndex:0]] objectForKey:@"location"] objectForKey:@"location"];
    CGFloat heightRes = [copy sizeWithFont:font constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap].height;
    float theHeight = 55;
    if (heightRes > 20) theHeight = heightRes + 47;
    
    NSLog(@"FINAL %f", theHeight);
    return theHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary* hubLocationDic = [self.hubLocation objectAtIndex:[indexPath row]];
    NSArray* theKeys = [hubLocationDic allKeys];
    NSString* copy = [[[hubLocationDic objectForKey:[theKeys objectAtIndex:0]] objectForKey:@"location"] objectForKey:@"location"];
    CGFloat heightRes = [copy sizeWithFont:[UIFont fontWithName:@"Delicious-Roman" size:18.0] constrainedToSize:CGSizeMake(233, 3000) lineBreakMode:UILineBreakModeWordWrap].height;
    float placeHeight = 18;
    float heightCheckbox = 12;
    float peopleY = 35;
    if (heightRes > 20) {
        heightCheckbox = 25;
        placeHeight = 55;
        peopleY = 65;
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *boxCheck = [[UIImageView alloc] initWithFrame:CGRectMake(0, heightCheckbox, 21.5, 21.5)] ;
        [boxCheck setImage:[UIImage imageNamed:@"checkbox.png"]];
        [cell.contentView addSubview:boxCheck];
        
        UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(30,13,233,placeHeight)];
        place.tag = 2345;
        place.font = [UIFont fontWithName:@"Delicious-Roman" size:18.0];
        place.lineBreakMode = UILineBreakModeWordWrap;
        place.numberOfLines = 0;
        place.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        place.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:place];
        
        UILabel *peopleCount = [[UILabel alloc] initWithFrame:CGRectMake(120,peopleY,233,25)];
        peopleCount.tag = 2346;
        peopleCount.font = [UIFont fontWithName:@"Delicious-Roman" size:16.0];
        peopleCount.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        peopleCount.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:peopleCount];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
        [cell setSelectedBackgroundView:bgColorView];
    } else {
        ((UILabel*)[cell.contentView viewWithTag:2345]).text = @"";
        ((UILabel*)[cell.contentView viewWithTag:2346]).text = @"";
    }
   
    int peopleCount = [[[hubLocationDic objectForKey:[theKeys objectAtIndex:0]] objectForKey:@"count"] intValue];
    NSString* message = @"People can help";
    if (peopleCount == 1) message = @"Person can help";
    ((UILabel*)[cell.contentView viewWithTag:2346]).text = [NSString stringWithFormat:@"%i %@", peopleCount, message];
    ((UILabel*)[cell.contentView viewWithTag:2345]).text = copy;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Hiting %i", [indexPath row]);
    NSDictionary* hubLocationDic = [self.hubLocation objectAtIndex:[indexPath row]];
    NSLog(@"Hiting 2 %i", [indexPath row]);
    NSArray* theKeys = [hubLocationDic allKeys];
    NSString* locationId = [[[hubLocationDic objectForKey:[theKeys objectAtIndex:0]] objectForKey:@"location"] objectForKey:@"location"];
    NSLog(@"Hiting 30 %i", [indexPath row]);
    [delegate dataSelected:locationId];   
}

- (void) populateLocatons:(NSArray*) locations {
    //NSLog(@"LOCATIONS %@", locations);
    self.theTable.tableFooterView = nil;
    self.hubLocation = locations;
    if ([self.hubLocation count] == 0){
        [self addFirstHubLocation];
    }
    
    [self resizeLayout:[self.hubLocation count]];
    [self.theTable reloadData];
   
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_hubLocations"];
    //remove_loadingview
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remove_loadingview" object:self];
    
}

- (void)resizeLayout:(int) numberRows {
    int scrollHeigt;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        scrollHeigt = numberRows * 80;
    }else{
        scrollHeigt = numberRows * 80;
    }
    
    CGRect footerFrame = self.bottomImage.frame;
    footerFrame.origin.y = (numberRows * 55) + 465;
    self.bottomImage.frame = footerFrame;
    
    CGRect middleFrame = self.middleImage.frame;
    middleFrame.size.height = (numberRows * 55) + 280;
    self.middleImage.frame = middleFrame;
    
    NSLog(@"SCROLL HEIHGT %i", scrollHeigt);
    [underScroll setContentSize:CGSizeMake(underScroll.frame.size.width, scrollHeigt)];
    //underScroll.scrollEnabled = true;
    if (numberRows > 7){
        CGRect tableFrame = self.theTable.frame;
        tableFrame.size.height = tableFrame.size.height + (numberRows * 55);
        self.theTable.frame = tableFrame;
    }
    
    
    [self.view setNeedsLayout];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
