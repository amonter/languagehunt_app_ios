//
//  ConnectionListController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 12/01/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTableBase.h"

@interface ConnectionListController : FeedTableBase {
    
    NSMutableArray *lines;

}

@property (nonatomic, retain) NSMutableArray *lines;

- (void) userLive:(NSDictionary *) user;
- (void) addLiveUsers:(NSArray *) users;
- (void)retrieveMatchListReq;
- (NSString*)theTitle;


- (void) populateUsers;
@end
