//
//  NotificationsController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 16/02/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "NotificationsController.h"
#import "NotificationCell.h"
#import "PeopleHuntRequests.h"
#import "HuntProfileHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface NotificationsController ()

@end

@implementation NotificationsController
@synthesize notifications;

- (void)updateNotificationData {
    
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [HuntProfileHelper addLoadingView:self.view];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        [self stopLoading];
        [HuntProfileHelper removeLoadingView:self.view];
        self.notifications = nil;
        self.notifications = [(NSArray *)[notification userInfo] retain];
        [self.tableView reloadData];
        
    }];
    
    [req retrieveMyNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
     [self.tableView setSeparatorColor:[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1]];
    self.navigationItem.leftBarButtonItem = nil;
    self.notifications = [[[NSArray alloc] init] autorelease];
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"Notifications.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    
    [self updateNotificationData];
    [self setupHomeTab];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"senderid_15"];
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
    return [self.notifications count];
}

- (UITableViewCell *)tableView:(UITableView *) aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NotificationCell";
    
    NotificationCell *cell = (NotificationCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *cellContent = [self.notifications objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        for (id oneObject in nib){
            cell = (NotificationCell *)oneObject;
            [cell setBackgroundShadow];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else {
        cell.photoChat.image = nil;
    }
    
    //date formatting
    long long milliseconds = [[cellContent objectForKey:@"notificationTime"] longLongValue];
    NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:(milliseconds/1000)];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd HH:mm"];
    
    cell.dateLabel.text = [format stringFromDate:theDate];
    cell.dateLabel.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
	cell.dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    
    cell.nameLabel.text = [cellContent objectForKey:@"senderName"];
    cell.nameLabel.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
	cell.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
    
    
    [cell setOtherPhoto:[cellContent objectForKey:@"senderImageUrl"]];
    
    cell.photoChat.layer.cornerRadius = 6.0;
    cell.photoChat.layer.masksToBounds = YES;
    // Set up the cell...
    
    
    cell.theChatMessage.text = [NSString stringWithFormat:@"tried to connect with you about: %@",[cellContent objectForKey:@"matchItem"]];
    cell.theChatMessage.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
	cell.theChatMessage.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    
    [cell setNeedsLayout];
    
    return cell;
}



- (CGSize) getCellWidth:(UITableView *)aTableView copy:(NSString *)copy {
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    CGSize withinsize = CGSizeMake(aTableView.frame.size.width - 80, 2000); //1000 is just a large number. could be 500 as well
    // You can choose a different Wrap Mode of your choice
    
    return [copy sizeWithFont:font constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap];
}


- (CGFloat)tableView:(UITableView *) aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int theRow = [indexPath row];
    NSString *copy = [NSString stringWithFormat:@"tried to connect with you about: %@",[[self.notifications objectAtIndex:theRow] objectForKey:@"matchItem"]];
    CGSize sz = [self getCellWidth:aTableView copy:copy];
    
    float heightCell = sz.height;
    
	return heightCell +60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    req.notificationName = @"done_push";
    int theRow = [indexPath row];
    int senderId = [[[self.notifications objectAtIndex:theRow] objectForKey:@"senderId"] intValue];
    NSDate *lastNotified = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"senderid_%i", senderId]];
    NSDate *currentDate = [NSDate date];
    if (!lastNotified) lastNotified = [currentDate dateByAddingTimeInterval:610];
    //NSLog(@"STORED DATE %@ current date %@ comp %g", [lastNotified description], [currentDate description], [currentDate timeIntervalSinceDate:lastNotified]);
    NSString *senderName = [[self.notifications objectAtIndex:theRow] objectForKey:@"senderName"];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:lastNotified];
    if (fabs(interval) > 20.0f) {
        [[NSNotificationCenter defaultCenter] addObserverForName:@"done_push" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
            req.notificationName = @"done_all";
            [req removePreviousMatch:senderId];
        }];
        [req postPushNotification:senderId];
        [self scanningInfoPop:senderName];
        
    }else{
        
        [self scanningInfoPopPause:senderName];
    }
}

- (void) scanningInfoPop:(NSString *)senderName{
    
    //get location of scanning button to position it?
    UIView *scanningInfoPop = [[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,self.view.frame.size.height)] autorelease];
    scanningInfoPop.backgroundColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:0.5];
    scanningInfoPop.tag = 888987;
    [self.view addSubview:scanningInfoPop];
    
    UIView *scanningInfoImage = [[[UIView alloc] initWithFrame:CGRectMake(35, 50, 250, 178)] autorelease];
    scanningInfoImage.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    scanningInfoImage.layer.cornerRadius = 6.0;
    [scanningInfoPop addSubview:scanningInfoImage];
    
    UIButton *gotItButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gotItButton setFrame:CGRectMake(166, 130, 73, 42)];
    [gotItButton addTarget:self action:@selector(scanningInfoPopRemove) forControlEvents:UIControlEventTouchUpInside];
    [gotItButton setBackgroundImage:[UIImage imageNamed:@"gotit.png"] forState:UIControlStateNormal];
    [scanningInfoImage addSubview:gotItButton];
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15,14,210,115)] autorelease];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    infoLabel.lineBreakMode = UILineBreakModeWordWrap;
    infoLabel.textAlignment = UITextAlignmentLeft;
    infoLabel.numberOfLines = 0;
	infoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    infoLabel.text = [NSString stringWithFormat:@"Cool we've just notified %@! \n\nIf they open the notification, we'll connect you in a live chat, right here.", senderName];
    [scanningInfoImage addSubview:infoLabel];
    
    [scanningInfoPop setAlpha:0.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    
    [scanningInfoPop setAlpha:1.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    
}

- (void) scanningInfoPopRemove{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"scanningfeeler"];
    [[self.view viewWithTag:888987] removeFromSuperview];
    
}

- (void) scanningInfoPopPause:(NSString *)senderName{
    
    //get location of scanning button to position it?
    UIView *scanningInfoPop = [[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,self.view.frame.size.height)] autorelease];
    scanningInfoPop.backgroundColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:0.5];
    scanningInfoPop.tag = 888778;
    [self.view addSubview:scanningInfoPop];
    
    UIView *scanningInfoImage = [[[UIView alloc] initWithFrame:CGRectMake(35, 50, 250, 178)] autorelease];
    scanningInfoImage.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    scanningInfoImage.layer.cornerRadius = 6.0;
    [scanningInfoPop addSubview:scanningInfoImage];
    
    UIButton *gotItButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gotItButton setFrame:CGRectMake(166, 130, 73, 42)];
    [gotItButton addTarget:self action:@selector(scanningInfoPopPauseRemove) forControlEvents:UIControlEventTouchUpInside];
    [gotItButton setBackgroundImage:[UIImage imageNamed:@"gotit.png"] forState:UIControlStateNormal];
    [scanningInfoImage addSubview:gotItButton];
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15,14,210,115)] autorelease];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    infoLabel.lineBreakMode = UILineBreakModeWordWrap;
    infoLabel.textAlignment = UITextAlignmentLeft;
    infoLabel.numberOfLines = 0;
	infoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    infoLabel.text = [NSString stringWithFormat:@"Hold your horses! We don't want to notify everyone at the same time. Let's wait a few more seconds to see if %@ reponds.", senderName];
    [scanningInfoImage addSubview:infoLabel];
    
    [scanningInfoPop setAlpha:0.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    
    [scanningInfoPop setAlpha:1.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    
}

- (void) scanningInfoPopPauseRemove{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"scanningfeeler"];
    [[self.view viewWithTag:888778] removeFromSuperview];
    
}

- (void) updateData {
    [self updateNotificationData];
}

- (void)dealloc {
    [notifications release];
    [super dealloc];
}

@end
