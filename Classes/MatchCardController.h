//
//  MatchCardController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/13/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynchMessageController.h"
#import "DummyNewTable.h"

@interface MatchCardController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UITableView *theTableView;
}


@property bool helpMode;
@property (nonatomic, retain) NSArray* interests;
@property (nonatomic, retain) NSString* theName;
@property (nonatomic, retain) NSString* language;
@property (nonatomic, retain) NSDictionary* proficiency;
@property (nonatomic, retain) NSDictionary* matchCriteria;
@property (nonatomic, retain) NSDictionary* ratings;
@property (nonatomic,retain) NSString* theOtherUrl;
@property(nonatomic, retain) MatchDataTableController* matchLayout;
@property(nonatomic, retain) DummyNewTable* dummyTable;
- (void)createCard:(NSDictionary*) matchArray;
- (void) doMatchOnly:(NSDictionary*) matchArray;

@end
