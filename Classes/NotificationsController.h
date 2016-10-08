//
//  NotificationsController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 16/02/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTableBase.h"

@interface NotificationsController : FeedTableBase {
    
    NSArray *notifications;
}

@property (nonatomic, retain) NSArray *notifications;

- (void)updateNotificationData;
- (void) scanningInfoPopRemove;
- (void) scanningInfoPopPauseRemove;

@end
