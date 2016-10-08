//
//  FastConnectionsController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 5/25/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "FastConnectionsController.h"
#import "IOSUtility.h"
#import "AvatarImageView.h"
//#import "Mixpanel.h"
#import "StringEscapeUtil.h"
#import "LanguageRatingView.h"
#import "ExchangeDealView.h"


@interface FastConnectionsController ()

@end

@implementation FastConnectionsController
@synthesize headerConnect, helpMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.oldConnectionData = [[NSMutableArray alloc] init];
    self.connectionData = [[NSMutableArray alloc] init];
    
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 27)];
    [headerView addSubview:topCard];
    
    UIImageView *bottomCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    bottomCard.image = [UIImage imageNamed:@"cardback_bottom.png"];
   
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 27)];
    [footerView addSubview:bottomCard];
    
    self.theTable.tableHeaderView = headerView;
    self.theTable.tableFooterView = footerView;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ConnectCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary* cellContent = nil;
    if ([indexPath section] == 0) {
        cellContent = [self.connectionData objectAtIndex:[indexPath row]];
    }
    if ([indexPath section] == 1){
        cellContent = [self.oldConnectionData objectAtIndex:[indexPath row]];
    }
    
    NSArray* canHelp = [cellContent objectForKey:@"help"];
    NSString *cellContentReal = @"";
    if ([canHelp count] > 0) [canHelp componentsJoinedByString:@","];
    
    CGSize withinsize = CGSizeMake(210, 3000);
    CGSize stringsize = [IOSUtility checkSizeWithFont:withinsize theFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0] theText:cellContentReal];
    AvatarImageView *asyncImageView = nil;
    UILabel *nameLabel = nil;
    UILabel *locationLabel = nil;
    UILabel *contentLabel = nil;
    UILabel *messageLabel = nil;
    UILabel *timeLabel = nil;
    
    
    LanguageRatingView* ratingView = nil;
    ExchangeDealView* exchangeDealView = nil;
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        //Rating View
        ratingView = [[LanguageRatingView alloc] initWithFrame:CGRectMake(180,26,32,31)];
        ratingView.backgroundColor = [UIColor clearColor];
        ratingView.tag = 81729;
        
        exchangeDealView = [[ExchangeDealView alloc] initWithFrame:CGRectMake(142,26,90,20)];
        exchangeDealView.backgroundColor = [UIColor clearColor];
        exchangeDealView.tag = 81732;
        
        
        UIImageView *photoBG = [[UIImageView alloc] initWithFrame:CGRectMake(45, 7, 91.5, 91.5)];
        photoBG.image = [UIImage imageNamed:@"back_pictureConnections.png"];
        UIView *middleBackGround = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 128)];
        middleBackGround.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardback_middle.png"]];
        [cell.contentView addSubview:middleBackGround];
        
        asyncImageView = [[AvatarImageView alloc] initWithFrame:CGRectMake(5.75,5.75, 80, 80)];
        asyncImageView.userInteractionEnabled = NO;
        asyncImageView.tag = 12;
        asyncImageView.displayUImage = true;
      
        [photoBG addSubview:asyncImageView];
        [cell.contentView addSubview:photoBG];
        //checkboxes
        UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(19, 43, 20, 20)];
        checkBtn.tag = 235677;
        [checkBtn setImage:[UIImage imageNamed:@"circle_check.png"] forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"circle_checkon.png"] forState:UIControlStateSelected];
        [checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.selected = false;
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105,10,160,35)];
        nameLabel.tag = 7414;
        nameLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:14.0];
        nameLabel.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.backgroundColor = [UIColor clearColor];
       
        UIImageView* verifiedSign = [[UIImageView alloc] initWithFrame:CGRectMake(258, 10, 26, 26)];
        verifiedSign.image = [UIImage imageNamed:@"check_verified.png"];
        
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(126,50,310,15)];
        timeLabel.tag = 82837;
        timeLabel.font = [UIFont fontWithName:@"Delicious-Roman" size:12.0];
        timeLabel.textColor = [UIColor colorWithRed:242/255.0 green:117/255.0 blue:26/255.0 alpha:1.0];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(199,90,160,35)];
        locationLabel.tag = 2342342;
        locationLabel.font = [UIFont fontWithName:@"Delicious-Roman" size:11.0];
        locationLabel.textColor = [UIColor colorWithRed:255/255.0 green:123/255.0 blue:27/255.0 alpha:1.0];
        locationLabel.numberOfLines = 0;
        locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
        locationLabel.backgroundColor = [UIColor clearColor];
       
        
        UIImageView *newMsgSymbol = [[UIImageView alloc] initWithFrame:CGRectMake(258, 51, 21, 21)];
        newMsgSymbol.tag = 39183764;
        newMsgSymbol.image = [UIImage imageNamed:@"speech.png"];
       
        
        UIImageView *behindMsg = [[UIImageView alloc] initWithFrame:CGRectMake(139, 44, 131, 53.5)];
        behindMsg.tag = 39183766;
        behindMsg.image = [UIImage imageNamed:@"connect_sq.png"];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,100,32)];
        messageLabel.tag = 985348;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont fontWithName:@"Delicious-Roman" size:12.0];
        messageLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        
        //accesory stuff
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(278, 45, 8, 15)];
        arrow.image = [UIImage imageNamed:@"arrowConnections.png"];
        [cell.contentView addSubview:arrow];
        
        UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(16, 115, 264.5, 3.5)];
        separatorLine.image = [UIImage imageNamed:@"lineConnections.png"];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:verifiedSign];
        [cell.contentView addSubview:timeLabel];
        [behindMsg addSubview:messageLabel];
        [cell.contentView addSubview:behindMsg];
        [cell.contentView addSubview:newMsgSymbol];
        [cell.contentView addSubview:separatorLine];
        [cell.contentView addSubview:exchangeDealView];
        [cell.contentView addSubview:ratingView];
        [cell.contentView addSubview:checkBtn];
        [cell.contentView addSubview:locationLabel];
       
        //behindMsg.hidden = true;
        newMsgSymbol.hidden = true;
        
    } else {
        asyncImageView = (AvatarImageView *)[cell.contentView viewWithTag:12];
        [asyncImageView removeImageView];
        asyncImageView.fileName = nil;
        
        nameLabel = (UILabel*) [cell.contentView viewWithTag:7414];
        contentLabel = (UILabel*) [cell.contentView viewWithTag:24671];
        locationLabel = (UILabel*) [cell.contentView viewWithTag:2342342];
        UILabel *theLabel = (UILabel *)[cell.contentView viewWithTag:24671];
        CGRect recycledFrame = theLabel.frame;
        recycledFrame.size.height = stringsize.height;
        recycledFrame.size.width = stringsize.width;
        theLabel.frame = recycledFrame;
        
        messageLabel = (UILabel*) [cell.contentView viewWithTag:985348];
        [cell.contentView viewWithTag:39183764].hidden = true;
        [cell.contentView viewWithTag:39183765].hidden = true;
        //[cell.contentView viewWithTag:39183766].hidden = true;
        
        timeLabel = (UILabel*)[cell.contentView viewWithTag:82837];
        messageLabel.text = @"";
    }
    
    //remove exchange icon
    [((ExchangeDealView*)[cell.contentView viewWithTag:81732]) removeImageView];
    
    NSArray* subViews = [cell.contentView subviews];
    for (UIView *theSubView in subViews) {
        if ([theSubView isKindOfClass:[UIButton class]]){
            theSubView.tag = [indexPath row];           
        }
    }
    
    
    //set the time
    if ([[cellContent objectForKey:@"live_now"] boolValue]) {
        //timeLabel.text = @"live now";
    }
    
    
    
    // Set up the cell...
    NSLog(@"IMAGE URL %@", [cellContent objectForKey:@"image_url"]);
    [asyncImageView checkIfImageExists:[cellContent objectForKey:@"image_url"] theImageFrame:CGRectMake(0,0, 80, 80)];
    NSString* things = @"things";
    if ([[cellContent objectForKey:@"shares"] intValue] == 1) things = @"thing";
    
    nameLabel.frame = CGRectMake(145,10,160,35);
    NSDictionary* helps = [[cellContent objectForKey:@"match_criteria"] objectForKey:@"help"];
   
    NSString* theHelp = @"";
    id helpKey = nil;
    if ([helps count] > 0){
        helpKey = [[helps allKeys] objectAtIndex:0];
        theHelp = [helps objectForKey:helpKey];
    }
   
    NSString *theName = [cellContent objectForKey:@"name"];   
    nameLabel.text = theName;
   
    NSDictionary* theLocations = [[cellContent objectForKey:@"match_criteria"] objectForKey:@"locations"];
    NSArray* key = [theLocations allKeys];
     NSLog(@"CONTENT Locations %@", theLocations);
    
    if ([key count] > 0) locationLabel.text = [theLocations objectForKey:[key objectAtIndex:0]];
    
    [nameLabel sizeToFit];
    //add Ratings
    
    NSDictionary* proficiency = [cellContent objectForKey:@"ratings"];
    int proficiencyVal = [[proficiency objectForKey:@"rating_score"] intValue];
    [((LanguageRatingView*)[cell.contentView viewWithTag:81729]) setRating:proficiencyVal];
    
    NSDictionary* paymentType = [cellContent objectForKey:@"paymentType"];
    int payment_type = [[paymentType objectForKey:@"payment_type"] intValue];
    [((ExchangeDealView*)[cell.contentView viewWithTag:81732]) setDeal:payment_type];

    
    NSMutableArray* interestArray = [[NSMutableArray alloc] init];
    for (NSDictionary* theInterest in [cellContent objectForKey:@"interests"]) {
        [interestArray addObject:[theInterest objectForKey:@"name"]];
    }
    
    if ([interestArray count] > 0){
        messageLabel.text = [NSString stringWithFormat:@"I like: %@", [interestArray componentsJoinedByString:@", "]];
    }
    
    return cell;
}


- (void) checkAction:(id) sender {
   
      NSLog(@"Tag %i", ((UIButton*)sender).selected);
    if (((UIButton *)sender).selected) ((UIButton *)sender).selected = NO;
    else ((UIButton *)sender).selected = YES;
    
     NSLog(@"Tag after %i", ((UIButton*)sender).selected);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selection_done" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:((UIButton*)sender).tag], @"index", [NSNumber numberWithBool:YES], @"pre_select", [NSNumber numberWithBool:((UIButton *)sender).selected], @"is_selected",  nil]];  

}


- (void) selectTableCell:(int) index {
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.theTable cellForRowAtIndexPath:path];
    //addd the pink liine here
    NSLog(@"INDEXXXXXXXXXXX %i", index);
    NSArray* subViews = [cell.contentView subviews];
    for (UIView *theSubView in subViews) {
        if ([theSubView isKindOfClass:[UIButton class]]){
            ((UIButton*)theSubView).selected = true;
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == 0){
        NSLog(@"COUNT %i", [self.connectionData count]);
        return [self.connectionData count];
    }
    
    return 0;
}



- (void)doMessageAnimation:(int)replacedIndex section:(int) theSection {
    //add the row to the section
    NSMutableArray *addArray = [[NSMutableArray alloc] init];
    [addArray addObject:[NSIndexPath indexPathForRow:0 inSection:theSection]];//index here
    
    //delete the row to the section
    NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
    if (replacedIndex == 0){
        [self.theTable reloadData];
        return;
    } else if (replacedIndex != -1){
        [deleteArray addObject:[NSIndexPath indexPathForRow:replacedIndex inSection:theSection]];
    }
    
    [self.theTable beginUpdates];
    [self.theTable insertRowsAtIndexPaths:addArray withRowAnimation:UITableViewRowAnimationFade];
    if (replacedIndex != -1) [self.theTable deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
    [self.theTable endUpdates];
}

- (int)doTheSearch:(NSMutableDictionary *)mutableUser newConnectionsCopy:(NSMutableArray *)newConnectionsCopy selectedArray:(NSMutableArray *)selectedArray {
    
    int replacedIndex=-1;
    [mutableUser setObject:[NSNumber numberWithBool:YES] forKey:@"liveuser"];
    NSLog(@"COUNT %i", [newConnectionsCopy count]);
    if ([newConnectionsCopy count] > 0){
        replacedIndex = [self copyDataInRows:mutableUser copyLines:newConnectionsCopy currentIndex:-1 selectedDataArray:selectedArray];
        //if (replacedIndex == -1) [selectedArray insertObject:mutableUser atIndex:0];
    } else {
        //[selectedArray insertObject:mutableUser atIndex:0];
    }
    return replacedIndex;
}

- (void) userLive:(NSDictionary *) user {
    NSMutableDictionary *mutableUser = [user mutableCopy];
    NSMutableArray* newConnectionsCopy = [self.connectionData copy];
    NSMutableArray* selectedArray = self.connectionData;
    
    int section = 0;
    int replacedIndex = -1;
    replacedIndex = [self doTheSearch:mutableUser newConnectionsCopy:newConnectionsCopy selectedArray:selectedArray];
    
    if (replacedIndex == -1){
        section = 1;
        NSMutableArray* newConnectionsCopy2 = [self.oldConnectionData copy];
        NSMutableArray* selectedArray2 = self.oldConnectionData;
        replacedIndex = [self doTheSearch:mutableUser newConnectionsCopy:newConnectionsCopy2 selectedArray:selectedArray2];
        
    }
    
    NSLog(@"INDEX %i SECTION %i", replacedIndex, section);
    [self doMessageAnimation:replacedIndex section:section];
}


- (int) copyDataInRows:(NSMutableDictionary *) storedUser copyLines:(NSMutableArray *)liveArray currentIndex:(int) theIndex selectedDataArray:(NSMutableArray*) selectedArray {
    
    NSMutableDictionary *liveUser = nil;
    NSArray *copyLiveArray = [liveArray copy];
    int replacedIndex = -1;
    for (int i = 0; i < [copyLiveArray count]; i++) {
        liveUser = [[copyLiveArray objectAtIndex:i] mutableCopy];
        if ([[liveUser objectForKey:@"profile_id"] intValue] == [[storedUser objectForKey:@"id"] intValue]) {
            NSString *imageUrl = [storedUser objectForKey:@"imageurl"];
            if (imageUrl){
                [liveUser setObject:imageUrl forKey:@"imageurl"];//added content just in case doesn't exist
                [liveUser setObject:[storedUser objectForKey:@"name"] forKey:@"name"];
            }
            //matchItem
            NSString *matchItem = [storedUser objectForKey:@"matchItem"];
            if (matchItem) [liveUser setObject:[storedUser objectForKey:@"matchItem"] forKey:@"matchItem"];
            if (theIndex == -1) {//just for a single live update
                theIndex = i;
                if ([storedUser objectForKey:@"lastMessage"]) [liveUser setObject:[storedUser objectForKey:@"lastMessage"]forKey:@"lastMessage"];
            } else { //delete from live array for later insertion
                [liveArray removeObjectAtIndex:i];
                if (![liveUser objectForKey:@"lastMessage"] && [storedUser objectForKey:@"lastMessage"]) [liveUser setObject:[storedUser objectForKey:@"lastMessage"]forKey:@"lastMessage"];
            }
            //indicate is a live user
            [liveUser setObject:[NSNumber numberWithBool:YES] forKey:@"liveuser"];
            [liveUser setObject:[NSNumber numberWithBool:YES] forKey:@"isNewMessage"];
            //if live user contains live message use that otherwise the stored one
            //NSLog(@"REPLACING %@", liveUser);
            replacedIndex = theIndex;
            [selectedArray removeObjectAtIndex:theIndex];
            [selectedArray insertObject:liveUser atIndex:0];
        }
    }
    
    return replacedIndex;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //connection_selected
    NSDictionary* data = nil;
    if ([indexPath section] == 0){
        //Mixpanel *mixpanel = [Mixpanel sharedInstance];
        //[mixpanel track:@"Tapped new connection"];
        data = [self.connectionData objectAtIndex:[indexPath row]];
    }
    if ([indexPath section] == 1) {
        //Mixpanel *mixpanel = [Mixpanel sharedInstance];
        //[mixpanel track:@"Tapped old connection"];
        data = [self.oldConnectionData objectAtIndex:[indexPath row]];
    }
    
    
    //NSLog(@"DATAAAA_____AAAAA___ %@", data);
    
    NSDictionary* theDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:[[data objectForKey:@"profile_id"] intValue]], @"other_id", [NSNumber numberWithInt:[indexPath row]], @"row", [data objectForKey:@"match_criteria"], @"match_criteria", data, @"profile_data", [data objectForKey:@"proficiency"], @"proficiency",
        [data objectForKey:@"paymentType"], @"paymentType", [data objectForKey:@"ratings"], @"ratings",  nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connection_selected" object:self userInfo:theDic];
    
}

- (CGFloat)tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 118;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 36.5)];
    sectionBack.backgroundColor = [UIColor clearColor];
    
    UIView* subHeader = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 292, 36.5)];
    subHeader.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardback_middle.png"]];
    
    UIImageView *blueBack = [[UIImageView alloc] initWithFrame:CGRectMake(17, -2, 263.5, 40)];
    blueBack.image = [UIImage imageNamed:@"blue1.png"];
    blueBack.tag = 172839;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,6,218,24)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:18.0];
    headerLabel.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
    headerLabel.text = [NSString stringWithFormat:@"%@ guides in your area", headerConnect];
    
    [sectionBack addSubview:subHeader];
    [sectionBack addSubview:blueBack];
    [sectionBack addSubview:headerLabel];
    
	return sectionBack;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 36.5;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"keyboard_down"]){
        NSLog(@"SCROLLLLLLL");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboard_down" object:self];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"keyboard_down"];
    }
}


@end
