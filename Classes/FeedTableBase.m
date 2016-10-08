//
//  FeedTableBase.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 24/10/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FeedTableBase.h"
#import "ProfileV2Controller.h"
#import "HuntFeedController.h"
#import "ConnectionListController.h"
#import "NotificationsController.h"
#define REFRESH_HEADER_HEIGHT 52.0f

@interface FeedTableBase ()

@end

@implementation FeedTableBase
@synthesize tableView, underNavView, navigationButton;



- (void)setupHomeTab {
    //home icon setup
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 41)] autorelease];
    button.tag = 222777;
    [button setImage:[UIImage imageNamed:@"buttonLeft.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"buttonLeftPressed.png"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"buttonLeftPressed.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(addNavUnder:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationButton = button;
    UIBarButtonItem *favorite = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = favorite;   

    
    UINavigationBar *theNav = self.navigationController.navigationBar;    
    CGRect underNavFrame = CGRectMake(0, -180, 320, 239);
    self.underNavView = [[[UIView alloc] initWithFrame: underNavFrame] autorelease];
    self.underNavView.tag = 888822;
    
    UIImageView *behindImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 239) ] autorelease];
    [behindImage setImage:[UIImage imageNamed:@"behindMenu.png"]];
    [self.underNavView addSubview:behindImage];
    
    //Feed button2  
    UIButton *feed = [UIButton buttonWithType:UIButtonTypeCustom];
    feed.tag = 1;
    [feed addTarget:self action:@selector(navigateNow:) forControlEvents:UIControlEventTouchUpInside];
    [feed setTitle:@"Home" forState:UIControlStateNormal];
    [feed setBackgroundImage:[UIImage imageNamed:@"backgroundButton.png"] forState:UIControlStateHighlighted];
    [feed setTitle:@"Home" forState:UIControlStateHighlighted];
    feed.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    feed.titleLabel.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    feed.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    feed.frame = CGRectMake(0.0, 26.0, 320.0, 51.0);
    [self.underNavView addSubview:feed];
    
    //Messages button
    UIButton *messages = [UIButton buttonWithType:UIButtonTypeCustom];
    messages.tag = 2;
    [messages addTarget:self action:@selector(navigateNow:) forControlEvents:UIControlEventTouchUpInside];
    [messages setTitle:@"Connections" forState:UIControlStateNormal];
    [messages setBackgroundImage:[UIImage imageNamed:@"backgroundButton.png"] forState:UIControlStateHighlighted];
    [messages setTitle:@"Connections" forState:UIControlStateHighlighted];
    messages.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    messages.titleLabel.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    messages.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    messages.frame = CGRectMake(0.0, 78.0, 320.0, 51.0);
    [self.underNavView addSubview:messages];
    
    /*UIImageView *newMessages = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 96, 13, 13) ] autorelease];
    [newMessages setImage:[UIImage imageNamed:@"lightOnNew.png"]];
    [self.underNavView addSubview:newMessages];*/

    //Notification button
    UIButton *notifications = [UIButton buttonWithType:UIButtonTypeCustom];
    notifications.tag = 3;
    [notifications addTarget:self action:@selector(navigateNow:) forControlEvents:UIControlEventTouchUpInside];
    [notifications setTitle:@"Notifications" forState:UIControlStateNormal];
    [notifications setBackgroundImage:[UIImage imageNamed:@"backgroundButton.png"] forState:UIControlStateHighlighted];
    [notifications setTitle:@"Notifications" forState:UIControlStateHighlighted];    
    notifications.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    notifications.titleLabel.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    notifications.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    notifications.frame = CGRectMake(0.0, 130.0, 320.0, 51.0);
    [self.underNavView addSubview:notifications];
    
    /*UIImageView *newNotifications = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 148, 13, 13) ] autorelease];
    [newNotifications setImage:[UIImage imageNamed:@"lightOnNew.png"]];
    [self.underNavView addSubview:newNotifications];*/
    
    //Profile button
    UIButton *profile = [UIButton buttonWithType:UIButtonTypeCustom];
    profile.tag = 4;
    [profile addTarget:self action:@selector(navigateNow:) forControlEvents:UIControlEventTouchUpInside];
    [profile setTitle:@"Profile" forState:UIControlStateNormal];
    [profile setBackgroundImage:[UIImage imageNamed:@"ProfileBackground.png"] forState:UIControlStateHighlighted];
    [profile setTitle:@"Profile" forState:UIControlStateHighlighted];
    profile.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    profile.titleLabel.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    profile.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    profile.frame = CGRectMake(0.0, 183.0, 320.0, 54.0);
    [self.underNavView addSubview:profile];      
    
    [theNav.superview insertSubview:self.underNavView belowSubview:theNav];
}



- (void)dismissNavigator {
    
    isNavOpen = false;
    CGRect navUnderFrame = self.underNavView.frame;
    UINavigationBar *theNav = self.navigationController.navigationBar;
    self.navigationButton.selected = NO;
    [UIView animateWithDuration:0.23 animations:^{
        CGRect modified = navUnderFrame;
        modified.origin.y = theNav.frame.size.height + 10;
        self.underNavView.frame = modified;
    }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.40 animations:^{
                             CGRect modified2 = self.underNavView.frame;
                             modified2.origin.y =  -180;
                             self.underNavView.frame = modified2;
                         }];
                     }        
     ];
}

- (void) navigateNow:(id)sender {
    
    int tag = ((UIButton *)sender).tag;
    [self dismissNavigator];

    switch (tag) {
        case 1:            
            if (![self isKindOfClass:[HuntFeedController class]]) {
                HuntFeedController *prof = [[[HuntFeedController alloc] initWithNibName:@"HuntFeedController" bundle:nil] autorelease];
                [self.navigationController pushViewController:prof animated:NO];
            }
            break;
        case 2:
            if (![self isKindOfClass:[ConnectionListController class]]) {
                ConnectionListController *prof = [[[ConnectionListController alloc] initWithNibName:@"ConnectionListController" bundle:nil] autorelease];
                [self.navigationController pushViewController:prof animated:NO];
            }
            break;
        case 3:
            if (![self isKindOfClass:[NotificationsController class]]) {
                NotificationsController *notif = [[[NotificationsController alloc] initWithNibName:@"NotificationsController" bundle:nil] autorelease];
                [self.navigationController pushViewController:notif animated:NO];
            }
            break;
        case 4:
            if (![self isKindOfClass:[ProfileV2Controller class]]) {
                ProfileV2Controller *prof = [[[ProfileV2Controller alloc] initWithNibName:@"ProfileV2Controller" bundle:nil] autorelease];
                [self.navigationController pushViewController:prof animated:NO];
            }
            break;
            
        default:
            break;
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPullToRefreshHeader];
	// Do any additional setup after loading the view.      
}



- (void) addNavUnder:(id)theSender {
    
    CGRect navUnderFrame = self.underNavView.frame;
    UINavigationBar *theNav = self.navigationController.navigationBar;
    
    if (((UIButton *)theSender).selected) { //hide the view
        isNavOpen = false;
        ((UIButton *)theSender).selected = NO;
        [UIView animateWithDuration:0.23 animations:^{
            CGRect modified = navUnderFrame;
            modified.origin.y = theNav.frame.size.height + 20;
            self.underNavView.frame = modified;                
        }
            completion:^(BOOL finished){                             
                [UIView animateWithDuration:0.30 animations:^{
                    CGRect modified2 = self.underNavView.frame;
                    modified2.origin.y =  -180;
                    self.underNavView.frame = modified2;
                }];
            }        
         ];        
   
    } else { // show the view
        isNavOpen = true;
        ((UIButton *)theSender).selected = YES;
        [UIView animateWithDuration:0.37 animations:^{
            CGRect modified = navUnderFrame;
            modified.origin.y = theNav.frame.size.height;
            self.underNavView.frame = modified;
        }];
    }     
}

- (void)addPullToRefreshHeader {

    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 5, 252, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    refreshLabel.textAlignment = UITextAlignmentLeft;
    refreshLabel.text = @"Pull down to refresh...";
    refreshLabel.textColor = [UIColor whiteColor];
    refreshLabel.shadowColor = [UIColor whiteColor];
    refreshLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downArrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 17) / 2)+18,
                                    (floorf(REFRESH_HEADER_HEIGHT - 30) / 2),
                                    17, 30);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2)+18, floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.tableView addSubview:refreshHeaderView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = @"Release to refresh...";
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = @"Pull down to refresh...";;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
    if (isNavOpen) [self dismissNavigator];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}


- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = @"Loading...";
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!    
    [self updateData];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
    completion:^(BOOL finished) {
        [self performSelector:@selector(stopLoadingComplete)];
    }];    
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshLabel.text = @"Pull down to refresh...";
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [navigationButton release];
    [underNavView release];
    [tableView release];
    [super dealloc];
}

@end
