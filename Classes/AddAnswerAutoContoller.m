//
//  AddAnswerAutoContoller.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 18/02/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//


#import "AddAnswerAutoContoller.h"
#import "PeopleHuntRequests.h"
#import "CanShareController.h"
#import "iphoneCrowdAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface AddAnswerAutoContoller ()

@end

@implementation AddAnswerAutoContoller
@synthesize searchBar, tableView, feelers, req, savedTerm;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1.0];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIButton *Button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 41)] autorelease];
    [Button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [Button setImage:[UIImage imageNamed:@"closePressed.png"] forState:UIControlStateHighlighted];
    [Button setImage:[UIImage imageNamed:@"closePressed.png"] forState:UIControlStateSelected];
    [Button addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView:Button] autorelease];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view from its nib.
    //feelers = [[[NSArray alloc] initWithObjects:@"Antonio", @"Adriano", @"Elenita", @"Francesco", @"Colombo", nil] autorelease];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    self.feelers = [[[NSMutableArray alloc] init] autorelease];
    searchBar.delegate = self;
    //[searchBar becomeFirstResponder];
    //searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    if (savedTerm) {
        searchBar.text = savedTerm;
        [searchBar becomeFirstResponder];
        [self doTermSearch:savedTerm];
        
    } else {    
        if (self.req == nil){
            self.req = [[[PeopleHuntRequests alloc] init] autorelease];
        }
        [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
            NSArray *responseData = [(NSArray *) [data userInfo] retain];
            self.feelers = [[responseData mutableCopy] autorelease];
            [self.tableView reloadData];
        }];
        [self.req retrieveRandomFeelers];
    }
}


#pragma - mark search methods
- (void)doTermSearch:(NSString *)searchText {
    if (self.req == nil){
        self.req = [[[PeopleHuntRequests alloc] init] autorelease];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [self.feelers removeAllObjects];
        NSArray *responseData = [(NSArray *) [data userInfo] retain];
        self.feelers = [[responseData mutableCopy] autorelease];
        [self.tableView reloadData];
        UIView *theFooter = self.tableView.tableFooterView;
        CGRect theFooterFrame = tableView.tableFooterView.frame;
        theFooterFrame.origin.y = 10;
        tableView.tableFooterView.frame = theFooterFrame;
        if ([self.feelers count] == 0){
            if (theFooter == nil){
                UILabel *feelerName = [[[UILabel alloc] initWithFrame:CGRectMake(95, 0, 215, 44)] autorelease];
                feelerName.tag = 7776;
                feelerName.backgroundColor = [UIColor clearColor];
                feelerName.lineBreakMode = UILineBreakModeWordWrap;
                feelerName.numberOfLines = 0;
                feelerName.textColor = [UIColor whiteColor];
                feelerName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
                feelerName.text = [NSString stringWithFormat:@"I want to add a new interest called \"%@\"", searchText];
                UIView *addFooter = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
                UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 75, 44)] autorelease];
                [button setImage:[UIImage imageNamed:@"add_button.png"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(addTheFeeler) forControlEvents:UIControlEventTouchUpInside];
                [addFooter addSubview:feelerName];
                [addFooter addSubview:button];
                self.tableView.tableFooterView = addFooter;

            } else {
                UILabel *addLabel = (UILabel *)[theFooter viewWithTag:7776];
                addLabel.text = [NSString stringWithFormat:@"I want to add a new interest called \"%@\"", searchText];
            }
        } else {
            if (theFooter != nil){
                self.tableView.tableFooterView = nil;
            }
        }
    }];
    [self.req searchFeelerLike:searchText];
}

- (void) closePage{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {      
    
    int textLenght = [searchText length];
    if(textLenght > 0) {               
        [self doTermSearch:searchText];        
    } else {      
        [self.feelers removeAllObjects];
        [self.tableView reloadData];
         self.tableView.tableFooterView = nil;
    }       
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"CANCELLL");
}


- (void) addTheFeeler {
    [self dismissTheView:self.searchBar.text feelerId:0 isNew:YES];
}

#pragma mark - Table methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.feelers count];
}

- (UITableViewCell *)tableView:(UITableView *) aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SearchCell";    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *contentCell = [[self.feelers objectAtIndex:[indexPath row]] objectForKey:@"description"];
    CGSize withinsize = CGSizeMake(280, 2000);
    CGSize stringsize = [contentCell sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        //label
        NSLog(@"copy, %@", contentCell);
        UIView *copyBackground = [[[UIView alloc] initWithFrame:CGRectMake(10, 10, stringsize.width+20, stringsize.height+8)] autorelease];
        copyBackground.backgroundColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1];
        copyBackground.layer.cornerRadius = 2.0;
        copyBackground.tag = 712;
        [cell.contentView addSubview:copyBackground];
        
        UILabel *copyContent = [[[UILabel alloc] initWithFrame:CGRectMake(20, 14, stringsize.width, stringsize.height)] autorelease];
        copyContent.tag = 711;
        copyContent.lineBreakMode = UILineBreakModeWordWrap;
        copyContent.numberOfLines = 0;
        copyContent.backgroundColor = [UIColor clearColor];
        copyContent.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        copyContent.text = contentCell;
        copyContent.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        [cell.contentView addSubview:copyContent];       
        
    } else {
        UIView *behindLabel = (UIView *)[cell.contentView viewWithTag:712];
        CGRect recycledBehindFrame = behindLabel.frame;
        recycledBehindFrame.size.height = stringsize.height+8;
        recycledBehindFrame.size.width = stringsize.width+20;
        behindLabel.frame = recycledBehindFrame;
        
        UILabel *theLabel = (UILabel *)[cell.contentView viewWithTag:711];
        theLabel.text = contentCell;
        CGRect recycledFrame = theLabel.frame;
        recycledFrame.size.height = stringsize.height;
        recycledFrame.size.width = stringsize.width;
        theLabel.frame = recycledFrame;    
    }
    
    //date formatting
    //cell.textLabel.text = [[self.feelers objectAtIndex:[indexPath row]] objectForKey:@"description"];
    [cell setNeedsDisplay];
    return cell;
}


- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [searchBar resignFirstResponder];
}



- (CGSize) getCellWidth:(UITableView *)aTableView copy:(NSString *)copy {
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    CGSize withinsize = CGSizeMake(aTableView.frame.size.width - 40, 2000); //1000 is just a large number. could be 500 as well
    // You can choose a different Wrap Mode of your choice
    
    return [copy sizeWithFont:font constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap];
}


- (CGFloat)tableView:(UITableView *) aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int theRow = [indexPath row];
    NSString *copy = [[self.feelers objectAtIndex:theRow] objectForKey:@"description"];
    CGSize sz = [self getCellWidth:aTableView copy:copy];   
    
	return sz.height + 15;
}

- (void)dismissTheView:(NSString *)feeler feelerId:(int) feelerId isNew:(bool) newFeeler {    
   
    CanShareController *shareController = [[[CanShareController alloc] initWithNibName:@"CanShareController" bundle:nil] autorelease];
    [shareController.feelerBtn setTitle:feeler forState:UIControlStateNormal];
    shareController.selectionDone = feeler;
    shareController.feelerId = feelerId;
    shareController.newFeeler = newFeeler;
    shareController.dissmissVersion = TRUE;
    shareController.cancelMode = FALSE;
    //[shareController setFeeler];
    [self.navigationController pushViewController:shareController animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int theRow = [indexPath row];   
    NSString *feeler = [[self.feelers objectAtIndex:theRow] objectForKey:@"description"];

    int feelerId = [[[self.feelers objectAtIndex:theRow] objectForKey:@"id"] intValue];
    [self dismissTheView:feeler feelerId:feelerId isNew:NO];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UILabel *theLabel = (UILabel *)[cell.contentView viewWithTag:711];
    theLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [savedTerm release];
    [req release];
    [feelers release];
    [tableView release];
    [searchBar release];
    [super dealloc];
}

@end
