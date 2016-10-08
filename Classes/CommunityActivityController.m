//
//  CommunityActivityController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/05/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "CommunityActivityController.h"
#import "ActivityCell.h"

@interface CommunityActivityController ()

@end

@implementation CommunityActivityController
@synthesize theTable, activityData;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.activityData = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.activityData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ActivityCell";
    //int row = [indexPath row];
    
    ActivityCell *cell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        for (id oneObject in nib){
            cell = (ActivityCell *)oneObject;            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        
    }   
    
    // Configure the cell here...

    cell.chatLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    cell.chatLabel.textColor = [UIColor colorWithRed:25/255.0 green:136/255.0 blue:222/255.0 alpha:1.0];

    return cell;
}

- (CGFloat)tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {


    return 105;
}

- (NSString*)theTitle {
    return @"Community";
}
    
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [activityData release];
    [theTable release];
    [super dealloc];
}

@end
