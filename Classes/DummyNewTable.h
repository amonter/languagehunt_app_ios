//
//  DummyNewTable.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 3/23/15.
//  Copyright (c) 2015 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DummyNewTable : UIViewController <UITableViewDelegate, UITableViewDataSource>



@property CGFloat interestSize;
@property CGFloat linkSize;
@property CGFloat aboutSize;
@property CGFloat locationsSize;
@property CGFloat helpSize;
@property CGFloat interestedSize;
@property CGFloat askForSize;
@property int numberSections;
@property int withinSizeVal;
@property (nonatomic, retain) NSDictionary* paymentType;
@property (nonatomic, retain) NSMutableArray* addedSection;
@property (nonatomic, retain) NSMutableDictionary* addedHeight;
@property (nonatomic, retain) id interest;
@property (nonatomic, retain) NSString* link;
@property (nonatomic, retain) NSString* askFor;
@property (nonatomic, retain) NSString* about;
@property (nonatomic, retain) NSDictionary* locations;
@property (nonatomic, retain) NSDictionary* help;
@property (nonatomic, retain) NSDictionary* interested;
@property (nonatomic, retain) NSString* interestedLabel;
@property (nonatomic, retain) NSString* helpLabel;
@property (nonatomic, retain) NSString* askForLabel;
@property (nonatomic, retain) NSDictionary* proficiency;
@property (nonatomic, retain) IBOutlet UITableView* theTable;

- (CGFloat) calculateLayout;
- (UIView*) checkWhatSection:(int) section;
- (void) customTableOrder;


@end
