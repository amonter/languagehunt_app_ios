//
//  MatchDataTableController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 19/08/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchDataTableController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property bool inverseOrder;
@property CGFloat interestSize;
@property CGFloat linkSize;
@property CGFloat aboutSize;
@property CGFloat locationsSize;
@property CGFloat helpSize;
@property CGFloat interestedSize;
@property int numberSections;
@property (nonatomic, retain) NSMutableArray* addedSection;
@property (nonatomic, retain) NSMutableDictionary* addedHeight;
@property (nonatomic, retain) NSArray* interest;
@property (nonatomic, retain) NSString* link;
@property (nonatomic, retain) NSString* about;
@property (nonatomic, retain) NSDictionary* locations;
@property (nonatomic, retain) NSDictionary* help;
@property (nonatomic, retain) NSDictionary* interested;
@property (nonatomic, retain) NSString* interestedLabel;
@property (nonatomic, retain) NSString* helpLabel;
@property (nonatomic, retain) NSDictionary* proficiency;
@property (nonatomic, retain) IBOutlet UITableView* theTable;
- (CGFloat) calculateLayout;
- (UIView*) checkWhatSection:(int) section;
@end
