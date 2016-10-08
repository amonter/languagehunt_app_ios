//
//  ProfileFlipController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 24/04/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "ProfileFlipController.h"
#import "PeopleHuntRequests.h"

@interface ProfileFlipController ()

@end

@implementation ProfileFlipController
@synthesize avatarView, bioField, currentLocation, meetingLocation;



- (void)loadData:(int) profileId {
    
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        NSDictionary *allData = [data userInfo];
        if ([allData objectForKey:@"bio"] != (NSString *)[NSNull null]) self.bioField.text = [allData objectForKey:@"bio"];
        if ([allData objectForKey:@"location"] != (NSString *)[NSNull null]) self.currentLocation.text = [allData objectForKey:@"location"];
        if ([allData objectForKey:@"meeting"] != (NSString *)[NSNull null]) self.meetingLocation.text = [allData objectForKey:@"meeting"];
        
        [self.avatarView checkIfImageExists:[allData objectForKey:@"otherurl"] theImageFrame:CGRectMake(0, 0, 100, 100)];
        //code here similar to AsynchMessageController
        if ([[allData objectForKey:@"providing"] count] > 0){
            //countProviding = [[allData objectForKey:@"providing"] count];
            //askCopy = [[allData objectForKey:@"providing"] componentsJoinedByString:@" \n"];
        }
        if ([[allData objectForKey:@"looking"] count] > 0) {
            //countLooking = [[allData objectForKey:@"looking"] count];
            //helpCopy = [[allData objectForKey:@"looking"] componentsJoinedByString:@" \n"];
        }
        
        
    }];
    [req retrieveProfileFeelerData:profileId];
    
}


- (void)dealloc {
    [currentLocation release];
    [meetingLocation release];
    [bioField release];
    [avatarView release];
    [super dealloc];
}

@end
