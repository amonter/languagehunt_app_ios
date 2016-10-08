//
//  AsyncronousView.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 22/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "AsyncronousView.h"
#import "AsyncImageView.h"


@implementation AsyncronousView

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	CGRect theFrame = [UIScreen mainScreen].applicationFrame;		
	theFrame.size.height = 100;	
	theFrame.origin.x = 0.0;
	
	
	
	AsyncImageView *asyncImageView = [[[AsyncImageView alloc] initWithFrame:theFrame] autorelease];
	
	[self.view addSubview:asyncImageView];
	
	
	NSURL *url = [NSURL URLWithString:@"http://a3.twimg.com/profile_images/59762219/profilePhoto1_normal.JPG"]; 
	[asyncImageView loadImageFromURL:url theImageFrame:CGRectMake(20, 20, 54, 54)];
	
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
