//
//  FastConnectionsController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 5/25/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastConnectionsController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property bool helpMode;
@property (nonatomic, retain) IBOutlet UITableView* theTable;
@property (nonatomic, retain) NSMutableArray* connectionData;
@property (nonatomic, retain) NSMutableArray* oldConnectionData;
@property (nonatomic, retain) NSString* headerConnect;


- (void) userLive:(NSDictionary *) user;
- (void) selectTableCell:(int) index;


@end
