//
//  IncomingConnection.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 04/04/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "IncomingConnection.h"
#import "iphoneCrowdAppDelegate.h"
#import "AsynchMessageController.h"
#import "AvatarImageView.h"
#import "HuntFeedController.h"
#import <QuartzCore/QuartzCore.h>

@implementation IncomingConnection
@synthesize incomeData;

- (id)initWithFrame:(CGRect)frame superController:(UIView *) superView data:(NSDictionary *) incomeDic {
    self = [super initWithFrame:frame];
    if (self) {
        //get location of scanning button to position it?       
       
        self.incomeData = incomeDic;
        self.frame =  CGRectMake(0,0, 320, superView.frame.size.height);
        self.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:32/255.0 alpha:0.9];
        self.tag = 888987;
        [superView addSubview:self];
        
        UILabel *incomingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15,40,280,22)] autorelease];
        incomingLabel.backgroundColor = [UIColor clearColor];
        incomingLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        incomingLabel.lineBreakMode = NSLineBreakByWordWrapping;
        incomingLabel.textAlignment = NSTextAlignmentCenter;
        incomingLabel.numberOfLines = 0;
        incomingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        incomingLabel.text = [NSString stringWithFormat:@"Incoming Connection"];
        [self addSubview:incomingLabel];
        
        NSString *theMatchText = [NSString stringWithFormat:@"%@ %@", [incomeDic objectForKey:@"name"], [incomeDic objectForKey:@"matchItem"]];
        // or Fuare wants to know more about
       
        
        AvatarImageView *asyncImageView = [[[AvatarImageView alloc] initWithFrame:CGRectMake(110, 75, 100, 100)] autorelease];
        asyncImageView.userInteractionEnabled = NO;
        asyncImageView.tag = 12;
        asyncImageView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6].CGColor;
        asyncImageView.layer.borderWidth = 2.0;
        asyncImageView.displayUImage = true;
        [asyncImageView checkIfImageExists:[incomeData objectForKey:@"imageurl"] theImageFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:asyncImageView];
        
        UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20,180,280,40)] autorelease];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.numberOfLines = 0;
        infoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        infoLabel.text = theMatchText;
        [self addSubview:infoLabel];
        
        UIButton *openItButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [openItButton setFrame:CGRectMake(30, 230, 259, 56)];
        [openItButton addTarget:self action:@selector(incomingMatchAddScreen) forControlEvents:UIControlEventTouchUpInside];
        [openItButton setBackgroundImage:[UIImage imageNamed:@"startLiveChatBlue.png"] forState:UIControlStateNormal];
        [self addSubview:openItButton];
        
        UILabel *orLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20,293,280,20)] autorelease];
        orLabel.backgroundColor = [UIColor clearColor];
        orLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        orLabel.lineBreakMode = NSLineBreakByWordWrapping;
        orLabel.textAlignment = NSTextAlignmentCenter;
        orLabel.numberOfLines = 0;
        orLabel.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:16];
        orLabel.text = @"or";
        [self addSubview:orLabel];
        
        UIButton *closeIt = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeIt setFrame:CGRectMake(30, 320, 259, 55)];
        [closeIt addTarget:self action:@selector(incomingMatchInfoPopRemove) forControlEvents:UIControlEventTouchUpInside];
        [closeIt setBackgroundImage:[UIImage imageNamed:@"keepBrowsing.png"] forState:UIControlStateNormal];
        [self addSubview:closeIt];        
        [self setAlpha:0.0];
        
        [UIView beginAnimations:@"animation_1" context:NULL];
        
        // define how long the animation should take, in seconds. 0.5 is half a second.
        [UIView setAnimationDuration:0.50];        
        [self setAlpha:1.0];
        
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        // start animating!
        [UIView commitAnimations];
    }
    return self;
}


- (void) incomingMatchInfoPopRemove {
    [self removeFromSuperview];
}

- (void) incomingMatchAddScreen {
    [self removeFromSuperview];
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate cancelHunting];
    AsynchMessageController *message = [[[AsynchMessageController alloc] initWithNibName:@"AsynchMessageController" bundle:nil] autorelease];
    message.otherProfileId = [[incomeData objectForKey:@"id"] intValue];
    UINavigationController *myNavigationController = [[[UINavigationController alloc] initWithRootViewController:message] autorelease];
    UINavigationBar *navBar = [myNavigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];    
    [appDelegate.navigationController presentModalViewController:myNavigationController animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [incomeData release];
    [super dealloc];
}

@end
