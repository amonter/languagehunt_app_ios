//
//  TheMatcher.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 29/09/2011.
//  Copyright 2011 crowdscanner. All rights reserved.
//

#import "TheMatcher.h"
#import "PeopleHuntRequests.h"


@implementation TheMatcher
@synthesize huntId, selectedTags, huntRequest, requestId, remoteBundleId;



- (id)init:(int) theHuntId {


    self = [super init];
    if (self) {
        self.huntId = theHuntId;       
    }
    return self;
}



- (void) findMatch {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.huntRequest = [[[PeopleHuntRequests alloc] init] autorelease];
    
    //check that the huntid is not 0
   
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(requestDone:)
                                                 name:@"load_end" object:self.huntRequest];
    [self.huntRequest findAmigoMatch:self.huntId];
    
}

- (void) requestDone:(NSNotification *) data {
    
    //NSLog(@"%i is matched with %@", self.huntId, [data userInfo]);
    
    NSDictionary *theData = [data userInfo];
    int theKey = [[[theData allKeys] objectAtIndex:0] intValue];
    
    //NSLog(@"request id %i data %@", self.requestId, theData);
    if (theKey == 1){
         NSLog(@"RESPONSE MATCH");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"match_found" object:self userInfo:theData];
    } else if (theKey == 4) {
        NSLog(@"RESPONSE NO MATCH");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"no_match" object:self userInfo:theData];
    }
    
}



- (void) killHunting {
    [self.huntRequest cancelConnectionForHunt];    
}



- (void)dealloc {
    [huntRequest release];
    [selectedTags release];
    [super dealloc];
}


@end
