//
//  ConnectionListController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 12/01/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "ConnectionListController.h"
#import "PeopleHuntRequests.h"
#import "AvatarImageView.h"
#import "HuntFeedController.h"
#import "HuntProfileHelper.h"
#import "AsynchMessageController.h"
#import "iphoneCrowdAppDelegate.h"
#import "StringEscapeUtil.h"
#import <QuartzCore/QuartzCore.h>
//#import "Mixpanel.h"

@interface ConnectionListController ()

@end

@implementation ConnectionListController
@synthesize lines;


- (void)retrieveMatchListReq {    
    NSLog(@"retrieveMatchListReq");
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [HuntProfileHelper addLoadingView:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneRetrivingNotifications:) name:@"load_end" object:req];
    [req retrieveMyNotifications];
}

- (void) doneRetrivingNotifications:(NSNotification*) notification {   
    [self stopLoading];
    [self.lines removeAllObjects];
    NSArray *theArray = [(NSArray *)[notification userInfo] retain];
    [self.lines addObjectsFromArray:theArray];
    [self callLiveStuff];

}
- (void) callLiveStuff {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"heartbeatdone" object:nil];
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllLiveUsers) name:@"heartbeatdone" object:nil];
    [appDelegate checkHeartBeat];
}


- (void) getAllLiveUsers {
    NSLog(@"get all live users");
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.protocol sendMessage:@"80:getliveusers"];
}

- (NSString *) dateDiff:(NSString *)origDate {
    
    long long milliseconds = [origDate longLongValue];
    NSDate *convertedDate = [NSDate dateWithTimeIntervalSince1970:(milliseconds/1000)];   
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    //NSLog(@"%@ today date %@", convertedDate, todayDate);
    ti = ti * -1;
    if(ti < 1) {
    	return @"live now";
    } else if (ti < 60) {
    	return @"less than a minute ago";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
        NSString *copy = [NSString stringWithFormat:@"%d minutes ago", diff];
        if (diff == 1) copy = @"1 minute ago";
    	return copy;
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
        NSString *copy = [NSString stringWithFormat:@"%d hours ago", diff];
        if (diff == 1) copy = @"1 hour ago";
    	return copy;
    } else if (ti < 2629743) {
    	int diff = round(ti / 60 / 60 / 24);
        NSString *copy = [NSString stringWithFormat:@"%d days ago", diff];
        if (diff == 1) copy = @"1 day ago";
    	return copy;
    } else {
    	return @"";
    }

}

- (void) updateData {
    NSLog(@"UPDATEING FAD");
    [self retrieveMatchListReq];
}


- (void)viewDidLoad {    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"Landed on Messages View"];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.lines = [[[NSMutableArray alloc] init] autorelease];
    
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"connections.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIButton *Button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 41)] autorelease];
    [Button setImage:[UIImage imageNamed:@"leftHome.png"] forState:UIControlStateNormal];
    [Button setImage:[UIImage imageNamed:@"leftHomePressed.png"] forState:UIControlStateHighlighted];
    [Button setImage:[UIImage imageNamed:@"leftHomePressed.png"] forState:UIControlStateSelected];
    [Button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView:Button] autorelease];
    self.navigationItem.leftBarButtonItem = backButton;      
    [self addHeaderAndFooter];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1]];
    
    NSLog(@"PROFILE ID %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"]);
    
}





#pragma mark real time connections
- (int) copyDataInRows:(NSMutableDictionary *) storedUser copyLines:(NSMutableArray *)liveArray currentIndex:(int) theIndex {
   
    NSMutableDictionary *liveUser = nil;
    NSArray *copyLiveArray = [[liveArray copy] autorelease];
    int replacedIndex = -1;
    for (int i = 0; i < [copyLiveArray count]; i++) {
        liveUser = [[[copyLiveArray objectAtIndex:i] mutableCopy] autorelease];
        if ([[liveUser objectForKey:@"id"] intValue] == [[storedUser objectForKey:@"id"] intValue]) {
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
            //if live user contains live message use that otherwise the stored one          
            
            replacedIndex = theIndex;
            [self.lines removeObjectAtIndex:theIndex];
            [self.lines insertObject:liveUser atIndex:0];            
        }
    }
    
    return replacedIndex;
}

- (void) userLive:(NSDictionary *) user {
    
    
    NSMutableDictionary *mutableUser = [[user mutableCopy] autorelease];
    NSMutableArray *copyLines = [[self.lines copy] autorelease];
    
    int replacedIndex = -1;
    [mutableUser setObject:[NSNumber numberWithBool:YES] forKey:@"liveuser"];
    if ([copyLines count] > 0){
        replacedIndex = [self copyDataInRows:mutableUser copyLines:copyLines currentIndex:-1];
        if (replacedIndex == -1) [self.lines insertObject:mutableUser atIndex:0];
    } else {
        [self.lines insertObject:mutableUser atIndex:0];  
    }
    
    //add the row to the section
    NSMutableArray *addArray = [[[NSMutableArray alloc] init] autorelease];
    [addArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];//index here
    
    //delete the row to the section   
    NSMutableArray *deleteArray = [[[NSMutableArray alloc] init] autorelease];
    if (replacedIndex == 0){
        [self.tableView reloadData];
        return;
    } else if (replacedIndex != -1){
        [deleteArray addObject:[NSIndexPath indexPathForRow:replacedIndex inSection:0]];
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:addArray withRowAnimation:UITableViewRowAnimationFade];
    if (replacedIndex != -1) [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];    
}


- (void) addLiveUsers:(NSArray *) users {
    [HuntProfileHelper removeLoadingView:self.view];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if ([users count] > 0){
        NSMutableArray *copyLiveArray = [[users mutableCopy] autorelease];
        NSMutableArray *copyLines = [[self.lines copy] autorelease];
        for (int i=0; i < [copyLines count]; i++) {//reshuffle existing users
            NSMutableDictionary *userData = [[[copyLines objectAtIndex:i] mutableCopy] autorelease];
            [self copyDataInRows:userData copyLines:copyLiveArray currentIndex:i];
        }
        //add users not in the list
        for (NSDictionary *liveUser in copyLiveArray) {
            [self.lines insertObject:liveUser atIndex:0];
        }
    }
    
    [self.tableView reloadData];
}


- (void) liveConnectionAnimation {
    
}


#pragma mark - Table methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.lines count];
}

- (void) backButtonTapped {
   
    bool createNew = true;
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *controllers = appDelegate.navigationController.viewControllers;
    for (UIViewController *controller in controllers) {
        if ([controller isKindOfClass:[HuntFeedController class]]) {
            createNew = false;
        }
    }
    
    if (createNew){
        HuntFeedController *theFeed = [[[HuntFeedController alloc] initWithNibName:@"HuntFeedController" bundle:nil] autorelease];
        [self.navigationController pushViewController:theFeed animated:NO];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *) aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ConnectCell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *cellContent = [self.lines objectAtIndex:[indexPath row]];
    NSString *cellContentReal = [cellContent objectForKey:@"matchItem"];
    CGSize withinsize = CGSizeMake(210, 3000);
    CGSize stringsize = [cellContentReal sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0] constrainedToSize:withinsize lineBreakMode:NSLineBreakByWordWrapping];
    AvatarImageView *asyncImageView = nil;
    UILabel *nameLabel = nil;
    UILabel *contentLabel = nil;
    UILabel *messageLabel = nil;
    UILabel *timeLabel = nil;
    if (cell == nil) {        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        asyncImageView = [[[AvatarImageView alloc] initWithFrame:CGRectMake(10,10, 50, 50)] autorelease];
        asyncImageView.userInteractionEnabled = NO;
        asyncImageView.tag = 12;
        asyncImageView.displayUImage = true;
        //asyncImageView.layer.cornerRadius = 6.0;
        //asyncImageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:asyncImageView];
        
        nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70,10,210,15)] autorelease];
        nameLabel.tag = 7414;
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        nameLabel.textColor = [UIColor colorWithRed:25/255.0 green:136/255.0 blue:222/255.0 alpha:1.0];
        nameLabel.backgroundColor = [UIColor clearColor];
    
        
        timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,10,310,15)] autorelease];
        timeLabel.tag = 82837;
        timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentRight;

        
        contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70,26,210,stringsize.height)] autorelease];
        contentLabel.tag = 24671;
        contentLabel.lineBreakMode = UILineBreakModeWordWrap;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.backgroundColor = [UIColor clearColor];     
        
        float messageLabelypos;
        //message label
        if (stringsize.height <= 26){
             messageLabelypos = 65;
        }else{
            messageLabelypos = stringsize.height + 36;
        }
        
        messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,messageLabelypos,300,16)] autorelease];
        messageLabel.tag = 985348;
        messageLabel.lineBreakMode = UILineBreakModeWordWrap;
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
        messageLabel.textColor = [UIColor colorWithRed:255/255.0 green:27/255.0 blue:142/255.0 alpha:1.0];
        
        //accesory stuff
        UIImage *arrow = [UIImage imageNamed:@"sendMessage.png"]; //or wherever you take your image from
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:arrow];
        //cell.accessoryView = arrowImageView;
        //cell.accessoryView.backgroundColor = [UIColor redColor];
        [arrowImageView release];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:timeLabel];
        [cell.contentView addSubview:contentLabel];
        [cell.contentView addSubview:messageLabel];
        
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
        UILabel *theMsgLabel = (UILabel *)[cell.contentView viewWithTag:985348];
        CGRect recycledMsgYFrame = theMsgLabel.frame;
        if (stringsize.height <= 26){
            recycledMsgYFrame.origin.y = 65;
            theMsgLabel.frame = recycledMsgYFrame;
        }else{
            recycledMsgYFrame.origin.y = stringsize.height + 36;
            theMsgLabel.frame = recycledMsgYFrame;
        }
        //reset the data
        timeLabel = (UILabel*)[cell.contentView viewWithTag:82837];
        messageLabel.text = @"";
    }
    
    
    //set the time
    if ([cellContent objectForKey:@"liveuser"]) {
        timeLabel.text = @"live now";
    } else {
        NSString *date = [self dateDiff:[cellContent objectForKey:@"notificationTime"]];
        timeLabel.text = [NSString stringWithFormat:@"%@", date];
        
    }
    
    // Set up the cell...
    [asyncImageView checkIfImageExists:[cellContent objectForKey:@"imageurl"] theImageFrame:CGRectMake(0,0, 50, 50)];
    nameLabel.text = [cellContent objectForKey:@"name"];
   
    //set content
    contentLabel.text = cellContentReal;
    //NSString *messageKey = [NSString stringWithFormat:@"message_%i", [[cellContent objectForKey:@"id"] intValue]];
    //NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:messageKey];
    NSString *storedMessage = [cellContent objectForKey:@"lastMessage"];    
    if ((storedMessage != (NSString *)[NSNull null]) && storedMessage != nil){
        NSLog(@"database %@ key", storedMessage);     
        NSString *theContent = [StringEscapeUtil urlDecoder:storedMessage];
        theContent = [theContent stringByReplacingOccurrencesOfString:@"=$$=" withString:@":" options:NSLiteralSearch range:NSMakeRange(0, [theContent length])];
        messageLabel.text = [NSString stringWithFormat:@"> %@",theContent];
    }
    
    return cell;
}


- (CGSize) getCellWidth:(UITableView *)aTableView copy:(NSString *)copy {
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    CGSize withinsize = CGSizeMake(210, 3000); //1000 is just a large number. could be 500 as well
    // You can choose a different Wrap Mode of your choice    
    return [copy sizeWithFont:font constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap];
}


- (CGFloat)tableView:(UITableView *) aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int theRow = [indexPath row];
    NSString *copy = [NSString stringWithFormat:@"%@",[[self.lines objectAtIndex:theRow] objectForKey:@"matchItem"]];
    CGSize sz = [self getCellWidth:aTableView copy:copy];
   
    float heightCell = sz.height;    
	return heightCell +70;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellContent = [self.lines objectAtIndex:[indexPath row]];
    if ([[cellContent objectForKey:@"hasnew"] boolValue]) {
          [cell setBackgroundColor:[UIColor colorWithRed:15/255.0 green:165/255.0 blue:224/255.0 alpha:0.2]];
        
    } else {
         [cell setBackgroundColor:[UIColor whiteColor]];        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //do next view controller
   
    
    AsynchMessageController *message = [[[AsynchMessageController alloc] initWithNibName:@"AsynchMessageController" bundle:nil] autorelease];
    message.otherProfileId = [[[self.lines objectAtIndex:[indexPath row]] objectForKey:@"id"] intValue];
  
    UINavigationController *myNavigationController = [[[UINavigationController alloc] initWithRootViewController:message] autorelease];
    UINavigationBar *navBar = [myNavigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController presentModalViewController:myNavigationController animated:YES];
    
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [theDelegate cancelHunting];
    
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"View appearing");
    [self retrieveMatchListReq];
}

- (NSString*)theTitle {
    return @"List";
}


- (void) addHeaderAndFooter {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)] ;
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:v];
    [self.tableView setTableFooterView:v];
    [v release];
}

- (void)dealloc {
    [lines release];
    [super dealloc];
}

@end
