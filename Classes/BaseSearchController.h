//
//  BaseSearchController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 12/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomSearch.h"
#import "SelectedDataController.h"

@interface BaseSearchController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SelectedDataDelegate, UIScrollViewDelegate>


@property (nonatomic, retain) IBOutlet UIView *allHeader;
@property int numberDeletes;
@property int page;
@property int currentFeelerId;
@property bool searchMode;
@property (nonatomic, retain) IBOutlet UITableView *theTable;
@property (nonatomic, retain) IBOutlet UIImageView *bottomImage;
@property (nonatomic, retain) IBOutlet UIImageView *middleImage;
@property (nonatomic, retain) NSMutableDictionary *cachedSearchData;
@property (nonatomic, retain) NSMutableArray *sortedData;
@property (nonatomic, retain) NSMutableArray *searchData;
@property (nonatomic, retain) IBOutlet MyCustomSearch *search;
@property (nonatomic, retain) NSString *theSearchText;
@property (strong, retain) SelectedDataController *selectedDataTable;
@property (nonatomic, retain) NSMutableDictionary* selectedDataDic;
@property (nonatomic, retain) NSMutableArray* selectedData;
@property (strong, retain) NSMutableArray* dataNew;
@property (nonatomic, retain) IBOutlet UIScrollView* underScroll;

- (void) rotateElements;
- (void) pullFastData:(int) feelerId;
- (void) setSearchLabel:(UILabel*) theSeachLabel;
- (void) resizeLayout:(int) numberRows;
- (void) doRestData;
- (void) addTheFeeler;
- (void) setCellSelected:(UITableViewCell *)cell;


@end
