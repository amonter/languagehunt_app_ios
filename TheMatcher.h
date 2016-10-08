//
//  TheMatcher.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 29/09/2011.
//  Copyright 2011 crowdscanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeopleHuntRequests.h"

@interface TheMatcher : NSObject {
    
    int huntId;
    NSMutableSet *selectedTags;
    PeopleHuntRequests *huntRequest;
    int requestId;
    int remoteBundleId;
}

@property int remoteBundleId;
@property int requestId;
@property int huntId;
@property (nonatomic, retain) PeopleHuntRequests *huntRequest;
@property (nonatomic, retain) NSMutableSet *selectedTags;


- (void) findMatch;
- (void) requestDone:(NSNotification *) data;
- (id)init:(int) theHuntId;
- (void) killHunting;
@end
