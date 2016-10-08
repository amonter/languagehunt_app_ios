//
//  BaseControllerDummy.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 12/23/13.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "BaseControllerDummy.h"
//
//  BaseSearchController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 12/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

//#import "Mixpanel.h"

@interface BaseControllerDummy ()

@end

@implementation BaseControllerDummy
@synthesize theTable, search, cachedSearchData, theSearchText, searchData, selectedDataTable, selectedDataDic, dataNew, allHeader;
@synthesize underScroll, page, numberDeletes, searchMode, bottomImage, middleImage, sortedData, currentFeelerId;






- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self init];
    self.page = 1;
    
	// Do any additional setup after loading the view.
    search.delegate = self;
    self.underScroll.delegate = self;
    [self.search setBackgroundImage:[UIImage new]];
    [self.search setTranslucent:YES];
    self.view.backgroundColor = [UIColor colorWithRed:109/255.0 green:105/255.0 blue:96/255.0 alpha:1.0];
    self.underScroll.backgroundColor = [UIColor clearColor];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line2.png"]];
    [self.theTable setSeparatorColor:color];
    
    self.selectedDataTable = [[SelectedDataController alloc] initWithNibName:@"SelectedDataController" bundle:nil];
    self.selectedDataTable.delegate = self;
    CGRect theFrame = self.selectedDataTable.view.frame;
    theFrame.origin.y = 400;
    theFrame.origin.x = 21;
    theFrame.size.height = 190;
    theFrame.size.width = 256;
    self.selectedDataTable.view.frame = theFrame;
    self.selectedDataTable.view.backgroundColor = [UIColor clearColor];
    self.selectedDataTable.view.hidden = true;
    self.selectedDataDic = [[NSMutableDictionary alloc] init];
    self.sortedData = [[NSMutableArray alloc] init];
    
    self.dataNew = [[NSMutableArray alloc] init];
    
    underScroll.scrollEnabled = true;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"screenHeight %f", screenHeight);
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        self.bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 495, 297.5, 28)];
        self.middleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 192, 297.5, 173)];
        [underScroll setContentSize:CGSizeMake(264, 760)];
    }else{
        self.bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 405, 297.5, 28)];
        self.middleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 192, 297.5, 173)];
        [underScroll setContentSize:CGSizeMake(264, 650)];
    }
    self.bottomImage.image = [UIImage imageNamed:@"cardback_bottom.png"];
    [self.underScroll addSubview:self.bottomImage];
    
    
    
    self.middleImage.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    [self.underScroll addSubview:self.middleImage];
    
    [self.underScroll bringSubviewToFront:self.theTable];
    [self.underScroll addSubview:self.selectedDataTable.view];
    
    
    CGRect underScrollFrame = self.underScroll.frame;
    underScrollFrame.size.width = 297.5;
    underScroll.frame = underScrollFrame;
    
    CGRect tableFrame = self.theTable.frame;
    tableFrame.size.width = 256;
    theTable.frame = tableFrame;
    
}

- (void)rotateElements {
    self.page++;
    NSArray* tempArray = self.sortedData;
    NSLog(@"TEMP ARRAy %@", tempArray);
    int top = page * 4;
    int countSeg =  ([tempArray count] - top);
    NSLog(@"C %i", countSeg);
    if (countSeg > 0){
        NSLog(@"TOP %i %i %i", top, [tempArray count], (top - [tempArray count]));
        int segment = 4;
        int offsetCount = [tempArray count] - top;
        if (offsetCount < 4) segment = (top - [tempArray count]);
        if (segment < 0) segment = 4;
        NSLog(@"SEG %i", segment);
        NSRange theRange = NSMakeRange(top - 4, segment);
        NSArray* theFour = [tempArray subarrayWithRange:theRange];
        self.searchData = [theFour mutableCopy];
        [self.theTable reloadData];
    }
}

- (void)dataSelected:(NSString *)theElement {
    NSArray *theKey = [self.cachedSearchData allKeysForObject:theElement];
    //NSLog(@"ELEMENT %@ cachedData %@", theElement, self.cachedSearchData);
    if ([theKey count] > 0){
        NSLog(@"ADDED selectedDataDIc %@", theElement);
        [self.selectedDataDic setObject:[theElement stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:[NSString stringWithFormat:@"%i",[[theKey objectAtIndex:0] intValue]]];
    }
}

- (void) deleteElement:(NSString *)theElement {
    NSArray* theKey = [self.selectedDataDic allKeysForObject:theElement];
    [self.selectedDataDic removeObjectForKey:[theKey objectAtIndex:0]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:[NSString stringWithFormat:@"SearchBar blue button selected %@", [self class]]];
    int textLenght = [searchBar.text length];
    [searchBar resignFirstResponder];
    if(textLenght > 0) {
        //[self addTheFeeler];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchMode = true;
    return YES;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    int textLenght = [searchText length];
    if(textLenght > 0) {
        self.searchMode = true;
        [self doTermSeach:searchText];
    } else {
        self.searchMode = false;
        [self resetTable];
    }
}


- (void)resetTable {
    [self.view viewWithTag:2211728].hidden = false;
    [self.searchData removeAllObjects];
    NSArray* tempArray = self.sortedData;
    NSRange theRange = NSMakeRange(0, 4);
    NSArray* theFour = [tempArray subarrayWithRange:theRange];
    self.searchData = [theFour mutableCopy];
    [self.theTable reloadData];
    self.theTable.tableFooterView = nil;
}

- (void) doTermSeach:(NSString*) searchText {
    [self.searchData removeAllObjects];
    self.theSearchText = searchText;
    NSMutableArray* containsAnother = [NSMutableArray array];
    NSLog(@"SEARCH DATA %@", [self.cachedSearchData allValues]);
    for (NSString* feelerDesc in [self.cachedSearchData allValues]) {
        if ([feelerDesc rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound){
            [containsAnother addObject:feelerDesc];
        }
    }
    
    UIView *theFooter = self.theTable.tableFooterView;
    if ([containsAnother count] == 0){
        [self.view viewWithTag:2211728].hidden = true;
        if (theFooter == nil){
            UILabel *congratsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 221, 20)];
            congratsLabel.backgroundColor = [UIColor clearColor];
            congratsLabel.textColor = [UIColor colorWithRed:244/255.0 green:122/255.0 blue:34/255.0 alpha:1.0];
            congratsLabel.textAlignment = UITextAlignmentCenter;
            congratsLabel.font = [UIFont fontWithName:@"FreightSans Bold" size:20.0];
            congratsLabel.text = @"Congrats";
            
            UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 181, 60)];
            searchLabel.backgroundColor = [UIColor clearColor];
            searchLabel.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1.0];
            searchLabel.numberOfLines = 0;
            searchLabel.lineBreakMode = UILineBreakModeWordWrap;
            searchLabel.textAlignment = UITextAlignmentCenter;
            searchLabel.font = [UIFont fontWithName:@"FreightSans Bold" size:12.0];
            [self setSearchLabel:searchLabel];
            
            UILabel *feelerName = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 181, 20)];
            feelerName.tag = 7776;
            feelerName.textAlignment = UITextAlignmentCenter;
            feelerName.backgroundColor = [UIColor clearColor];
            feelerName.textColor = [UIColor colorWithRed:244/255.0 green:122/255.0 blue:34/255.0 alpha:1.0];
            feelerName.font = [UIFont fontWithName:@"FreightSans Bold" size:10.0];
            feelerName.text = [NSString stringWithFormat:@"add \"%@\"", searchText];
            
            UIView *addFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 256, 200)];
            addFooter.backgroundColor = [UIColor clearColor];
            
            UIImageView *backgroundSearch = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 5, 221, 148.5)];
            backgroundSearch.image = [UIImage imageNamed:@"papernote_small.png"];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(95, 91, 65, 26)];
            [button setImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addTheFeeler) forControlEvents:UIControlEventTouchUpInside];
            [addFooter addSubview:backgroundSearch];
            [backgroundSearch addSubview:congratsLabel];
            [backgroundSearch addSubview:searchLabel];
            [backgroundSearch addSubview:feelerName];
            [addFooter addSubview:button];
            self.theTable.tableFooterView = addFooter;
        } else {
            UILabel *addLabel = (UILabel *)[theFooter viewWithTag:7776];
            addLabel.text = [NSString stringWithFormat:@"add \"%@\"", searchText];
        }
    } else {
        if (theFooter != nil){
            self.theTable.tableFooterView = nil;
        }
    }
    
    [self.searchData addObjectsFromArray:containsAnother];
    [self.theTable reloadData];
}


- (void) setSearchLabel:(UILabel*) theSeachLabel {
    
}

- (void) addTheFeeler {
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:[NSString stringWithFormat:@"Added new %@", [self class]]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"display_profile"];
    self.selectedDataTable.view.hidden = false;
    [self.selectedDataTable addTheElement:self.theSearchText isNew:YES];
    [self.cachedSearchData setObject:self.theSearchText forKey:@"-1"];
    [self.dataNew addObject:self.theSearchText];
    self.theSearchText = @"";
    self.search.text = @"";
    [self resetTable];
    [self.search resignFirstResponder];
    
}



#pragma mark - Table view delegate
- (void)resizeLayout:(int) numberRows {
    int scrollHeigt;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        scrollHeigt = numberRows * 80 + 660;
    }else{
        scrollHeigt = numberRows * 80 + 550;
    }
    
    CGRect footerFrame = self.bottomImage.frame;
    footerFrame.origin.y = numberRows * 35 + 465;
    self.bottomImage.frame = footerFrame;
    
    CGRect middleFrame = self.middleImage.frame;
    middleFrame.size.height = numberRows * 35 + 280;
    self.middleImage.frame = middleFrame;
    
    NSLog(@"SCROLL HEIHGT %i", scrollHeigt);
    [underScroll setContentSize:CGSizeMake(297.5, scrollHeigt)];
    underScroll.scrollEnabled = true;
    [self.view setNeedsLayout];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:[NSString stringWithFormat:@"Selected existing %@", [self class]]];
    
    [self.search resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"display_profile"];
    NSString* theElement = [self.searchData objectAtIndex:[indexPath row]];
    
    NSArray* tempArray = [[self.cachedSearchData allValues] mutableCopy];
    NSArray* feelerId = [self.cachedSearchData allKeysForObject:theElement];
    NSMutableArray* selectedKeys = [[self.selectedDataDic allKeys] mutableCopy];
    if ([self.selectedData count] > 0) {
        for (NSString* selectedElement in self.selectedData) {
            NSArray* feelerId = [self.cachedSearchData allKeysForObject:selectedElement];
            if ([feelerId count] > 0){
                [selectedKeys addObject:[feelerId objectAtIndex:0]];
            }
        }
    }
    
    self.currentFeelerId = [[feelerId objectAtIndex:0] intValue];
    //NSLog(@"DIC %@ selected Data %@ feeler %@",[self.selectedDataDic allKeys], self.selectedData, [feelerId objectAtIndex:0]);
    if ([selectedKeys containsObject:[feelerId objectAtIndex:0]]){
        
        UIView *fuckenView = [[UIView alloc] initWithFrame:CGRectMake(40, 200, 220, 90)];
        fuckenView.tag = 8172182;
        fuckenView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel;
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(23,10,190,35)];
        nameLabel.tag = 7414;
        nameLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:16.0];
        nameLabel.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
        nameLabel.numberOfLines = 0;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = [NSString stringWithFormat:@"Sorry, you have selected %@, already!", theElement];
        [nameLabel sizeToFit];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(justDismiss)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"OK" forState:UIControlStateNormal];
        button.frame = CGRectMake(30.0, 55.0, 160.0, 40.0);
        [fuckenView addSubview:button];
        
        [fuckenView addSubview:nameLabel];
        [self.view addSubview:fuckenView];
        
        return;
    }
    
    int top = ((self.page + 1) * 4) + self.numberDeletes;
    [self.searchData removeObjectAtIndex:[indexPath row]];
    
    NSRange theRange = NSMakeRange(top - 4, 1);
    NSArray* theFour = [[NSArray alloc] init];
    NSMutableArray *addArray = [[NSMutableArray alloc] init];
    if (!searchMode && ((top - 4) + 1 <= [tempArray count])){
        theFour = [tempArray subarrayWithRange:theRange];
        [self.searchData insertObject:[theFour objectAtIndex:0] atIndex:3];
        //add the row to the section
        [addArray addObject:[NSIndexPath indexPathForRow:3 inSection:0]];//index here
    }
    
    self.selectedDataTable.view.hidden = false;
    [self.selectedDataTable addTheElement:theElement isNew:NO];
    NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
    [deleteArray addObject:indexPath];
    //delete the element
    
    [self.theTable beginUpdates];
    [self.theTable insertRowsAtIndexPaths:addArray withRowAnimation:UITableViewRowAnimationFade];
    [self.theTable deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
    [self.theTable endUpdates];
    self.numberDeletes++;
    
    int total = self.numberDeletes + [[self.selectedDataDic allKeys] count];
    [self resizeLayout:total];
    [self addProficiencyView:theElement];
    
}


- (void) justDismiss {
    [[self.view viewWithTag:8172182] removeFromSuperview];
}

- (void)addProficiencyView:(NSString*) element {
    
}

- (void) pullFastData:(int) feelerId {
    
    
}


-(void) keyboardWillShow:(NSNotification *)note{
    NSLog(@"SCROOOL");
    if (searchMode){
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        NSLog(@"SCROOOL 2");
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            [underScroll scrollRectToVisible:CGRectMake(0, underScroll.frame.size.height - 500, underScroll.frame.size.width, underScroll.frame.size.height) animated:YES];
        } else {
            [underScroll scrollRectToVisible:CGRectMake(0, underScroll.frame.size.height - 400, underScroll.frame.size.width, underScroll.frame.size.height) animated:YES];
        }
    }
}

-(void) keyboardWillHide:(NSNotification *)note {
    
    
}

- (void)doRestData {
    self.selectedDataTable.theSelectedData = self.selectedData;
    self.selectedDataTable.view.hidden = false;
    CGRect tableFrame = self.selectedDataTable.theTable.frame;
    CGRect viewFrame = self.selectedDataTable.view.frame;
    tableFrame.size.height = 50 * [self.selectedData count];
    viewFrame.size.height = 50 * [self.selectedData count];
    self.selectedDataTable.view.frame = viewFrame;
    self.selectedDataTable.theTable.frame = tableFrame;
    [self.selectedDataTable.theTable reloadData];
}


#pragma - mark search methods
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [search resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

