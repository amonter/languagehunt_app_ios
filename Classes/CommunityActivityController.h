//
//  CommunityActivityController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/05/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityCell.h"

@interface CommunityActivityController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, retain) NSArray *activityData;
@property (nonatomic, retain) IBOutlet UITableView *theTable;

- (NSString*)theTitle;
@end
