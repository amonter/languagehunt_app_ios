    //
//  NextViewController.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 27/09/2010.
//  Copyright 2010 crowdscanner. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NextViewController.h"
#import "AvatarImageView.h"


@implementation NextViewController
@synthesize avatarsView;


- (IBAction) goBack {

	UIView *currentView = self.view;			
	// remove the current view and replace with myView1
	UIView *theWindow = [currentView superview];	
	[currentView removeFromSuperview];	
	// set up an animation for the transition between the views
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.4];
	[animation setType:kCATransitionFade];
	//[animation setSubtype:kCATransitionFromLeft];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	
	[[theWindow layer] addAnimation:animation forKey:@"SwitchToView2"];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	float aWidth;
	float aHeight;
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait){			
		aWidth = 748/2;
		aHeight = 1024/2;				
	}
	else {				
		aWidth = 1024/2;
		aHeight = 748/2;
	}	
	
	AvatarImageView *asyncImageView = [[AvatarImageView alloc] initWithFrame:CGRectMake(aWidth -25, aHeight -25, 50, 50)];			
	asyncImageView.userInteractionEnabled = YES;
	//asyncImageView.tag = count;
	//asyncImageView.nodeData = node;
	[self.view addSubview:asyncImageView];	
	NSURL *url = [NSURL URLWithString:@"http://www.crowdscanner.com/retrieveprofileimage/568544861.jpg"]; 				
	[asyncImageView loadImageFromURL:url theImageFrame:CGRectMake(0,0, 50, 50)];
	
	//[self.avatarImages addObject:asyncImageView];
	[asyncImageView release];		
    [super viewDidLoad];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[avatarsView];
    [super dealloc];
}


@end
