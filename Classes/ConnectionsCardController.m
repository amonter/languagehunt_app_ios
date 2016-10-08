//
//  ConnectionsCardController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 28/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#ifdef __IPHONE_7_0
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
#else
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
#endif


#import "ConnectionsCardController.h"
#import "MatchConnectionCell.h"
#import "StringEscapeUtil.h"
//#import "Mixpanel.h"
#import "IOSUtility.h"
#import "PeopleHuntRequests.h"
#import "iphoneCrowdAppDelegate.h"

@interface ConnectionsCardController ()

@end

@implementation ConnectionsCardController
@synthesize theTable, connectionData;


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
    UILabel *exchangeLabel = nil;
    UILabel *contentLabel = nil;
    UILabel *messageLabel = nil;
    UILabel *timeLabel = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];      
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *photoBG = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 66, 66)];
        photoBG.image = [UIImage imageNamed:@"back_pictureConnections.png"];
        
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardback_middle.png"]];
        
        asyncImageView = [[AvatarImageView alloc] initWithFrame:CGRectMake(5.75,5.75, 55, 55)];
        asyncImageView.userInteractionEnabled = NO;
        asyncImageView.tag = 12;
        asyncImageView.displayUImage = true;
        //asyncImageView.layer.cornerRadius = 6.0;
        //asyncImageView.layer.masksToBounds = YES;
        [photoBG addSubview:asyncImageView];
        [cell.contentView addSubview:photoBG];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(126,0,160,35)];
        nameLabel.tag = 7414;
        nameLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:16.0];
        nameLabel.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        nameLabel.backgroundColor = [UIColor clearColor];
        
        exchangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(126,31,310,15)];
        exchangeLabel.tag = 127369;
        exchangeLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:12.0];
        exchangeLabel.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1.0];
        //exchangeLabel.text = @"3 things to exchange";
        exchangeLabel.backgroundColor = [UIColor clearColor];
        exchangeLabel.textAlignment = NSTextAlignmentLeft;
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(126,50,310,15)];
        timeLabel.tag = 82837;
        timeLabel.font = [UIFont fontWithName:@"Delicious-Roman" size:12.0];
        timeLabel.textColor = [UIColor colorWithRed:242/255.0 green:117/255.0 blue:26/255.0 alpha:1.0];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        
        UIImageView *newMsgSymbol = [[UIImageView alloc] initWithFrame:CGRectMake(200, 26, 21, 21)];
        newMsgSymbol.tag = 39183764;
        newMsgSymbol.image = [UIImage imageNamed:@"speech.png"];
        
        UIImageView *pinkNewMsg = [[UIImageView alloc] initWithFrame:CGRectMake(283.5, 2, 10, 114.5)];
        pinkNewMsg.tag = 39183765;
        pinkNewMsg.image = [UIImage imageNamed:@"pink.png"];
         
        UIImageView *behindMsg = [[UIImageView alloc] initWithFrame:CGRectMake(90, 30, 121, 43.5)];
        behindMsg.tag = 39183766;
        behindMsg.image = [UIImage imageNamed:@"speech_bubbble.png"];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,100,32)];
        messageLabel.tag = 985348;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont fontWithName:@"Delicious-Roman" size:12.0];
        messageLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        
        //accesory stuff
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(270, 33, 11, 18)];
        arrow.image = [UIImage imageNamed:@"arrowConnections.png"];
        [cell.contentView addSubview:arrow];
        
        UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(16, 90, 264.5, 3.5)];
        separatorLine.image = [UIImage imageNamed:@"lineConnections.png"];
       
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:timeLabel];
      
        [behindMsg addSubview:messageLabel];
        [cell.contentView addSubview:behindMsg];
        [cell.contentView addSubview:pinkNewMsg];
        [cell.contentView addSubview:newMsgSymbol];
        [cell.contentView addSubview:separatorLine];
        
        pinkNewMsg.hidden = true;
     
        
    } else {
        asyncImageView = (AvatarImageView *)[cell.contentView viewWithTag:12];
        [asyncImageView removeImageView];
        asyncImageView.fileName = nil;
        
        nameLabel = (UILabel*) [cell.contentView viewWithTag:7414];
        contentLabel = (UILabel*) [cell.contentView viewWithTag:24671];
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
    
    
    //set the time
    if ([[cellContent objectForKey:@"live_now"] boolValue]) {
        timeLabel.text = @"live now";
    }
    
    
    // Set up the cell...
    [asyncImageView checkIfImageExists:[cellContent objectForKey:@"image_url"] theImageFrame:CGRectMake(0,0, 55, 55)];
    NSString* things = @"things";
    if ([[cellContent objectForKey:@"shares"] intValue] == 1) things = @"thing";
    
    nameLabel.frame = CGRectMake(95,9,160,35);
    nameLabel.text = [cellContent objectForKey:@"name"];
    [nameLabel sizeToFit];
    
    
    if ([[cellContent objectForKey:@"new_message"] boolValue]){
        [cell.contentView viewWithTag:39183764].hidden = false;
        [cell.contentView viewWithTag:39183765].hidden = false;
        [cell.contentView viewWithTag:39183766].hidden = false;
    }
    
    NSString *storedMessage = [cellContent objectForKey:@"message"];
    if (storedMessage.length > 0){
        NSLog(@"database %@ key", storedMessage);
        NSString *theContent = [StringEscapeUtil urlDecoder:storedMessage];
        theContent = [theContent stringByReplacingOccurrencesOfString:@"=$$=" withString:@":" options:NSLiteralSearch range:NSMakeRange(0, [theContent length])];
        if (storedMessage.length > 22) storedMessage = [storedMessage substringToIndex:22];
        messageLabel.text = storedMessage;
        if ([[cellContent objectForKey:@"isNewMessage"] boolValue]){
            [cell.contentView viewWithTag:39183764].hidden = false;
            [cell.contentView viewWithTag:39183765].hidden = false;
            [cell.contentView viewWithTag:39183766].hidden = false;
        }
    }
    
    return cell; 
    
}


- (void) getMessages {
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [theDelegate.protocol sendMessage:[NSString stringWithFormat:@"113:%i", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]]];    
}



- (void) populateUsers:(NSArray*) data {

    self.connectionData = [data mutableCopy];
    [self.theTable reloadData];
    
    NSString* theJson = @"{\"newOnes\":[{\"profile_id\":1101,\"status\":0,\"match_criteria\":{\"help\":{\"3\":\"French\"},\"locations\":{\"13\":\"San Francisco, USA\"},\"interested\":{}},\"shares\":1,\"name\":\"Adrian Avendano\",\"image_url\":\"(null)\",\"bio\":\"Since I was 19\",\"lastMessage\":\"\",\"isNewMessage\":false,\"proficiency\":{},\"interests\":[{\"name\":\"Web Development\"},{\"name\":\"Java\"},{\"name\":\"Social Networking\"},{\"name\":\"E-commerce\"},{\"name\":\"Linux\"},{\"name\":\"Mobile Applications\"},{\"name\":\"CSS\"},{\"name\":\"Start-ups\"},{\"name\":\"Scrum\"},{\"name\":\"Software Engineering\"},{\"name\":\"JavaScript\"},{\"name\":\"Software Development\"},{\"name\":\"PHP\"},{\"name\":\"Programming\"},{\"name\":\"iOS development\"},{\"name\":\"HTML 5\"},{\"name\":\"Web Applications\"},{\"name\":\"User Experience\"}],\"live_now\":0},{\"profile_id\":21,\"status\":0,\"match_criteria\":{\"help\":{\"3\":\"French\"},\"locations\":{\"13\":\"San Francisco, USA\"},\"interested\":{}},\"shares\":1,\"name\":\"Alex Murray 3245\",\"image_url\":\"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash2/t1.0-1/c36.8.95.95/p111x111/1003267_173795169462814_360186586_n.jpg\",\"bio\":\"Im an awesome designer from London, and Im be going to Chile to live\",\"lastMessage\":\"You are going to be the first person who wants to make or do We can help!\",\"isNewMessage\":false,\"proficiency\":{\"2\":3,\"3\":2},\"live_now\":0},{\"profile_id\":13,\"status\":0,\"match_criteria\":{\"help\":{\"3\":\"French\"},\"locations\":{\"13\":\"San Francisco, USA\"},\"interested\":{}},\"shares\":1,\"name\":\"Jim Stout\",\"image_url\":\"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash2/t1.0-1/p100x100/29526_102750373103520_2439047_a.jpg\",\"bio\":\"(null)\",\"lastMessage\":\"\",\"isNewMessage\":false,\"proficiency\":{\"3\":3},\"interests\":[{\"name\":\"ZARA\",\"created_time\":\"2014-05-13T03:04:53 0000\",\"id\":\"33331950906\",\"category\":\"Clothing\"},{\"name\":\"UNIQLO USA\",\"created_time\":\"2014-05-13T03:04:42 0000\",\"id\":\"266351330231\",\"category\":\"Clothing\",\"category_list\":[{\"id\":\"186230924744328\",\"name\":\"Clothing Store\"}]},{\"name\":\"Peoplehunt\",\"created_time\":\"2013-01-03T22:37:05 0000\",\"id\":\"348870721829876\",\"category\":\"App page\"},{\"name\":\"PromoBomb\",\"created_time\":\"2011-06-26T16:33:05 0000\",\"id\":\"139670726094394\",\"category\":\"Website\"}],\"live_now\":0}]}";
    
   
    //[self userLive:theDic];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == 0){
        return [self.connectionData count];
    }
    if (section == 1) {
        return [self.oldConnectionData count];
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
    
    /*[self.theTable beginUpdates];
    [self.theTable insertRowsAtIndexPaths:addArray withRowAnimation:UITableViewRowAnimationFade];
    if (replacedIndex != -1) [self.theTable deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
    [self.theTable endUpdates];*/
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
    NSLog(@"MESSAGE HERE %@", user);
    NSMutableDictionary *mutableUser = [user mutableCopy];
    NSMutableArray* newConnectionsCopy = [self.connectionData copy];
    NSMutableArray* selectedArray = self.connectionData;
    
    [self.theTable reloadData];
    
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
                if ([storedUser objectForKey:@"message"]) [liveUser setObject:[storedUser objectForKey:@"message"]forKey:@"message"];
            } else { //delete from live array for later insertion
                [liveArray removeObjectAtIndex:i];
                if (![liveUser objectForKey:@"message"] && [storedUser objectForKey:@"message"]) [liveUser setObject:[storedUser objectForKey:@"message"]forKey:@"message"];
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
    
    UITableViewCell* selectedCell = [theTable cellForRowAtIndexPath:indexPath];
    [selectedCell.contentView viewWithTag:39183764].hidden = true;
    [selectedCell.contentView viewWithTag:39183765].hidden = true;
    
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
   
    NSDictionary* theDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:[[data objectForKey:@"profile_id"] intValue]], @"other_id", [NSNumber numberWithInt:[indexPath section]], @"section", [data objectForKey:@"match_criteria"], @"match_criteria", data, @"profile_data", [data objectForKey:@"proficiency"], @"proficiency", nil];
    
    NSLog(@"DIC DAT_____ %@", theDic);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connection_selected" object:self userInfo:theDic];
    
    /*if ([indexPath section] == 0) {
        [self.connectionData removeObjectAtIndex:[indexPath row]];
        [self.oldConnectionData addObject:data];
    }*/
    
   
}

- (CGFloat)tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 95;
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
    headerLabel.text = @"MESSAGES";
    
    [sectionBack addSubview:subHeader];
    [sectionBack addSubview:blueBack];
    [sectionBack addSubview:headerLabel];
    
    
	return sectionBack;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.5;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
