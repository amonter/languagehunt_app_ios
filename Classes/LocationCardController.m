//
//  LocationCardController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 26/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "LocationCardController.h"

@interface LocationCardController ()

@end

@implementation LocationCardController
@synthesize theTable, cachedSearchData, searchData, search, theSearchText, selectedData;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.   
    NSArray* tempArray = [[self.cachedSearchData allValues] mutableCopy];
    NSRange theRange = NSMakeRange(0, 4);
    NSArray* theFour = [tempArray subarrayWithRange:theRange];
    self.searchData = [theFour mutableCopy];   
    [self.theTable reloadData];
    
   

    //CGRect searchFrame = self.search.frame;
    //searchFrame.size.width = 290;
    //search.frame = searchFrame;
    //add adddd
    
    
}

- (void) loadInterestedInData {
   

}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.searchData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    //NSLog(@"cellf %@", [self.searchData objectAtIndex:[indexPath row]]);
    cell.textLabel.text = [self.searchData objectAtIndex:[indexPath row]];
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_matchconnections"];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)doRestData {
    self.selectedDataTable.theSelectedData = self.selectedData;
    self.selectedDataTable.view.hidden = false;
    CGRect tableFrame = self.selectedDataTable.theTable.frame;
    tableFrame.size.height = 50 * [self.selectedData count];
    self.selectedDataTable.theTable.frame = tableFrame;
    
    [self.selectedDataTable.theTable reloadData];   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
