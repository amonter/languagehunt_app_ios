//
//  ConnectionsCardController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 28/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionsCardController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView* theTable;
@property (nonatomic, retain) NSMutableArray* connectionData;
@property (nonatomic, retain) NSMutableArray* oldConnectionData;

- (void) userLive:(NSDictionary *) user;
- (void) populateUsers:(NSArray*) data;
- (void) getMessages;
@end
