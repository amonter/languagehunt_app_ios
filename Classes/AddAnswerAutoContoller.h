//
//  AddAnswerAutoContoller.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 18/02/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleHuntRequests.h"
#import "MyCustomSearch.h"

@interface AddAnswerAutoContoller : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate>  {

    IBOutlet MyCustomSearch *searchBar;
    IBOutlet UITableView *tableView;
    NSMutableArray *feelers;
    PeopleHuntRequests *req;
    NSString *savedTerm;

}

@property (nonatomic, retain) NSString *savedTerm;
@property (nonatomic, retain) PeopleHuntRequests *req;
@property (nonatomic, retain) NSMutableArray *feelers;
@property (nonatomic, retain) IBOutlet MyCustomSearch *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)dismissTheView:(NSString *)feeler feelerId:(int) feelerId isNew:(bool) newFeeler;
- (void) closePage;

@end
