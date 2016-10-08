//
//  AddPhotoController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 05/04/2011.
//  Copyright 2011 crowdscanner. All rights reserved.
//

#import "AddPhotoController.h"
#import "ViewProfilePhotoController.h"
#import "UploadPhotoFileRequest.h"


@implementation AddPhotoController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (IBAction) addThePhotoController {
	
	ViewProfilePhotoController *present = [[ViewProfilePhotoController alloc] initWithNibName:@"ViewProfilePhotoController" bundle:nil];
	present.uploadRequest = [[[[UploadPhotoFileRequest alloc] init] autorelease] retain];
	present.hidesBottomBarWhenPushed = YES;
	present.isOwner = TRUE;
	[self.navigationController pushViewController:present animated:YES];
	[present release];	 		
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
