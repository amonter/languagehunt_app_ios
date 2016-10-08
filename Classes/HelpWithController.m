    //
//  HelpWithController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "HelpWithController.h"
#import "PeopleHuntRequests.h"
#import "iphoneCrowdAppDelegate.h"

@interface HelpWithController ()

@end

@implementation HelpWithController
@synthesize aggregateHelpWith, proficiencyLevels, proficiencyResults, hideDone;
@synthesize theSlider;


-(id)init {
	self = [super init];
	if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init];
    // Do any additional setup after loading the view from its nib.
    self.numberAdds = -1;
   
    self.view.backgroundColor = [UIColor clearColor];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *coverSearch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    coverSearch.image = [UIImage imageNamed:@"cardback_top.png"];
    
    self.proficiencyLevels = [[NSMutableDictionary alloc] init];
    self.proficiencyResults = [[NSMutableDictionary alloc] init];
    
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
        titleKnow = [[UIImageView alloc] initWithFrame:CGRectMake(30.5, 21.25, 208.5, 42)];
        bgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 263.5, 64.5)];
        iconKnowledge = [[UIImageView alloc] initWithFrame:CGRectMake(237.5, 23.5, 32, 38.5)];
        lineDotted = [[UIImageView alloc] initWithFrame:CGRectMake(20, 213, 257.5, 3.5)];
        
    }else{
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 460)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 384)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 384)];
        titleKnow = [[UIImageView alloc] initWithFrame:CGRectMake(30.5, 11.25, 208.5, 42)];
        bgTitle = [[UIImageView alloc] initWithFrame:CGRectMake(17, 0, 263.5, 64.5)];
        iconKnowledge = [[UIImageView alloc] initWithFrame:CGRectMake(237.5, 13.5, 32, 38.5)];
        lineDotted = [[UIImageView alloc] initWithFrame:CGRectMake(20, 213, 257.5, 3.5)];
        
    }
    
    titleKnow.image = [UIImage imageNamed:@"helpwith_language.png"];
    bgTitle.image = [UIImage imageNamed:@"blue3.png"];
    iconKnowledge.image = [UIImage imageNamed:@"icon_light.png"];
    lineDotted.image = [UIImage imageNamed:@"line.png"];
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    //background.image = [UIImage imageNamed:@"background.png"];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setFrame:CGRectMake(244.75, 117.5, 42, 42)];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refreshNew.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(rotateElements) forControlEvents:UIControlEventTouchUpInside];
    //levels view
    UIImageView *levels = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levels.png"]];
    levels.frame = CGRectMake(110, 90, 175, 24);
    
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)];
    topview.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:95/255.0 blue:95.0/255.0 alpha:1];
    
    [self.allHeader addSubview:topCard];
    [self.allHeader addSubview:middleView];
    
    [middleView addSubview:middleCard];
    [middleView addSubview:bgTitle];
    [middleView addSubview:titleKnow];
    [middleView addSubview:iconKnowledge];
   
    [middleView addSubview:levels];
    
    CGRect tableFrame = self.theTable.frame;
    tableFrame.size.width = 266;
    self.theTable.frame = tableFrame;
    self.search.hidden = true;
    
    
}


- (void) addDoneBtn {
   
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"done_added"]) {
        UIButton *startBrowsing = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBrowsing setBackgroundImage:[UIImage imageNamed:@"done_btn.png"] forState:UIControlStateNormal];
        startBrowsing.tag = 928;
        CGRect posFrameShort = CGRectMake (26.25, 418, 267.5, 41.5);
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) posFrameShort = CGRectMake (26.25, 439, 267.5, 41.5);
        [startBrowsing setFrame:posFrameShort];
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            CGRect posFrame = CGRectMake (26.25, 508, 267.5, 41.5);
            if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) posFrame = CGRectMake (26.25, 528, 267.5, 41.5);
            [startBrowsing setFrame:posFrame];
        }
        
        iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        [startBrowsing addTarget:self action:@selector(doCommit:) forControlEvents:UIControlEventTouchUpInside];
        [appDelegate.navigationController.visibleViewController.view addSubview:startBrowsing];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"done_added"];
    }
}


- (void) doCommit:(id) sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"has_shared"];
    [((UIButton*)sender) removeFromSuperview];   
    [self.proficiencyLevels allKeys];
    for (id key in self.proficiencyLevels) {
        int theLevel = [[self.proficiencyLevels objectForKey:key] intValue];
        NSString* theElement = [self.searchData objectAtIndex:[key intValue]];
        [self dataSelected:theElement];
        NSArray* arrayId = [self.cachedSearchData allKeysForObject:theElement];
        int feelerId = [[arrayId objectAtIndex:0] intValue];
        
        [self.proficiencyResults setObject:[NSNumber numberWithInt:theLevel] forKey:[NSString stringWithFormat:@"%i", feelerId]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tap_done" object:self];
}


- (void) retrieveHelpData {
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
        //self.searchData = [theFour mutableCopy];
        self.searchData = self.sortedData;
        [self resizeLayout:[self.searchData count]];
        
        
        [self.theTable reloadData];
        
        
        [self.theTable reloadData];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"help_load" object:self];
    }];
    [stat retrieveHelpWithData];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *boxCheck = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 21.5, 21.5)];
        boxCheck.image = [UIImage imageNamed:@"checkbox.png"];        
        //[cell.contentView addSubview:boxCheck];
        //the slider
        self.theSlider = [[UISlider alloc] initWithFrame:CGRectMake(73, 5, 187, 36)];
        theSlider.tag = [indexPath row];
        theSlider.minimumValue = 0.0;
        theSlider.maximumValue = 100.0;
        theSlider.continuous = YES;
        //theSlider.value = 20;
        [theSlider addTarget:self
                        action:@selector(sliderValueChanged:)
              forControlEvents:UIControlEventValueChanged];
        
        UITapGestureRecognizer *tapSlider = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
        [theSlider addGestureRecognizer:tapSlider];
        
        UILabel *help = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, cell.frame.size.height)];
        help.tag = 23561;
        help.font = [UIFont fontWithName:@"Delicious-Roman" size:18.0];
        help.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        help.backgroundColor = [UIColor clearColor];
        help.lineBreakMode = NSLineBreakByWordWrapping;
        help.numberOfLines = 0;
        
        [cell.contentView addSubview:theSlider];
        [cell.contentView addSubview:help];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
        [cell setSelectedBackgroundView:bgColorView];
    }
    
    // Configure the cell...
    ((UILabel*)[cell.contentView viewWithTag:23561]).text = [[self.searchData objectAtIndex:[indexPath row]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];   
 
    return cell;
}

- (void)sliderTapped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"SLIDDER WAS TAPPED %@",  [gestureRecognizer.view class]);
    UISlider* aSlider = (UISlider*) gestureRecognizer.view;
    CGPoint thePoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    /*int theRow;
    if (thePoint.y >= 226 && thePoint.y < 257){
        theRow = 0;
    }
    if (thePoint.y >= 271 && thePoint.y < 295){
        theRow = 1;
    }
    if (thePoint.y >= 305 && thePoint.y < 329 ){
        theRow = 2;
    }
    if (thePoint.y >= 345 && thePoint.y < 377 ){
        theRow = 3;
    }
    
    UITableViewCell* theCell = [self.theTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:theRow inSection:0]];
    NSArray* views = theCell.contentView.subviews;
    UISlider* aSlider = nil;
    for (UIView* view in views) {
        if ([view isKindOfClass:[UISlider class]]) {
            aSlider = (UISlider*)view;
        }
    }*/
    
    float x_val = thePoint.x;
    int theLevel = 0;
    
    if (x_val >= 0 && x_val < 37 ) {
        aSlider.value = 0;
    }
    if (x_val >= 38 && x_val < 62 ) {
        aSlider.value = 15;
        theLevel = 1;
    }
    if (x_val >= 63 && x_val < 114 ) {
        aSlider.value = 43;
        theLevel = 2;
    }    
    if (x_val >= 115  && x_val < 160) {
        aSlider.value = 74;
        theLevel = 3;
    }
    if (x_val >= 161) {
        aSlider.value = 108;
        theLevel = 4;
    }
    
    NSLog(@"POINT %f slidValue %f", x_val, aSlider.value);
    if (aSlider.value >= 15) [self addDoneBtn];
    if (aSlider.value >= 38) [self.proficiencyLevels setObject:[NSNumber numberWithInt:theLevel] forKey:[NSNumber numberWithInt:aSlider.tag]];
}



- (void) sliderValueChanged:(UISlider*) sender {
    float theVal = sender.value;
    int theLevel = 0;
   
    if (theVal >=0 && theVal < 4){
        sender.value = 0;
    }
    if (theVal >= 5 && theVal <= 31){
        sender.value = 15;
        theLevel = 1;
    }
    if (theVal >= 32 && theVal <= 55){
        sender.value = 43;
        theLevel = 2;
    }
    if (theVal >= 55 && theVal <= 80){
        sender.value = 74;
        theLevel = 3;
    }
    
    if (theVal >= 81 ){
        sender.value = 108;
        theLevel = 4;
    }
    
    [self.proficiencyLevels setObject:[NSNumber numberWithInt:theLevel] forKey:[NSNumber numberWithInt:sender.tag]];
    [self addDoneBtn];
    //NSLog(@"row %i val %f", sender.tag, sender.value);
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



- (void) nextCardAction {
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"tap_done" object:self];
}


- (void) addTheFeeler {
    //NSString* theElement = self.theSearchText;
    //[super addTheFeeler];
    //[self addProficiencyView:theElement];
}


- (void) addProficiency:(id) sender {
    NSLog(@"TAG %i feelerId %i", ((UIButton*)sender).tag, self.currentFeelerId);
    int feelerId = self.currentFeelerId;
    if (feelerId == 0){
        feelerId = self.numberAdds;
        self.numberAdds--;
    }
    
    
    [self.proficiencyLevels setObject:[NSNumber numberWithInt:((UIButton*)sender).tag] forKey:[NSString stringWithFormat:@"%i", feelerId]];
    [[self.view viewWithTag:727198] removeFromSuperview];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Can you help with more languages?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"No", nil];
	[alertView show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		//NO
        [[NSNotificationCenter defaultCenter] postNotificationName:@"done_language" object:self];
	} else {
        
	}
}

- (void) setSearchLabel:(UILabel*) theSeachLabel {
    theSeachLabel.text = @"You are the first person who can help with this awesomeness - add it!";
}



@end
