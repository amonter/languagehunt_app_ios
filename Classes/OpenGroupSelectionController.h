//
//  OpenGroupSelectionController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 07/02/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenGroupSelectionController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *theTable;
    NSString *resJson;
    NSArray *groupsData;
}

@property (nonatomic, retain) NSArray *groupsData;
@property (nonatomic, retain) NSString *resJson;
@property (nonatomic, retain) IBOutlet UITableView *theTable;
@property (nonatomic, retain) NSArray *openGroupsData;
@property (nonatomic, retain) NSMutableArray *selectedOpenGroups;

- (void) accessInfoTapRemove;
- (void) accessInfoTap;

@end
