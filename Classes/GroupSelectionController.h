//
//  GroupSelectionController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 02/12/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupSelectionController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    IBOutlet UITableView *theTable;
}

@property (nonatomic, retain) IBOutlet UITableView *theTable;
@property (nonatomic, retain) NSArray *groupsData;
@property (nonatomic, retain) NSMutableArray *selectedGroups;
@property (nonatomic, retain) NSString *profileImageUrl;


- (void) accessInfoTap;
- (void) accessInfoTapRemove;


@end
