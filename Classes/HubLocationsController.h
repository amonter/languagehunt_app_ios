//
//  HubLocationsController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 12/29/13.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSearchController.h"

@interface HubLocationsController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate> {
    
     id<SelectedDataDelegate> delegate;
}



@property (nonatomic, retain) IBOutlet UIView *allHeader;
@property (nonatomic, retain) IBOutlet UIScrollView *underScroll;
@property (nonatomic, retain) IBOutlet UITableView *theTable;
@property (nonatomic, retain) IBOutlet UIImageView *bottomImage;
@property (nonatomic, retain) IBOutlet UIImageView *middleImage;
@property (nonatomic, retain) NSArray* hubLocation;
@property (nonatomic, retain) NSDictionary* selectedData;
@property (retain) id delegate;

- (void) populateLocatons:(NSArray*) locations;
@end
