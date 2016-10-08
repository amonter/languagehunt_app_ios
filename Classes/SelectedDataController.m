//
//  SelectedDataController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 14/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "SelectedDataController.h"

@interface SelectedDataController ()

@end

@implementation SelectedDataController
@synthesize theTable, theSelectedData, delegate, cellHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.theSelectedData = [[NSMutableArray alloc] init];
    self.theTable.opaque = NO;
    self.theTable.backgroundColor = [UIColor clearColor];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line2.png"]];
    [self.theTable setSeparatorColor:color];
   
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"count a %i", [self.theSelectedData count]);
    return [self.theSelectedData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
     NSLog(@"count  b %i", [indexPath row]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //NSLog(@"cellOrangeSize %f", cellHeight);
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"orange.png"]];
        
        UIImageView *boxCheck = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 14.5, 16.5, 16.5)] ;
        [boxCheck setImage:[UIImage imageNamed:@"check_icon.png"]];
        [cell.contentView addSubview:boxCheck];
        
        UILabel *selection = [[UILabel alloc] initWithFrame:CGRectMake(30,3,220,cellHeight)];
        selection.tag = 7245;
        selection.font = [UIFont fontWithName:@"Delicious-Roman" size:18.0];
        selection.textColor = [UIColor whiteColor];
        
        selection.backgroundColor = [UIColor clearColor];
        selection.lineBreakMode = NSLineBreakByWordWrapping;
        selection.numberOfLines = 0;
        [cell.contentView addSubview:selection];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
        [cell setSelectedBackgroundView:bgColorView];
    } 
    
    // Configure the cell... 
    
    ((UILabel*)[cell.contentView viewWithTag:7245]).text = [self.theSelectedData objectAtIndex:[indexPath row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    NSLog(@"SELECTED now");
    NSString* elementToDelete = [self.theSelectedData objectAtIndex:[indexPath row]];
    [self.theSelectedData removeObjectAtIndex:[indexPath row]];
    NSArray* deleteElement = [NSArray arrayWithObject:indexPath];
    [self.theTable beginUpdates];
    [self.theTable deleteRowsAtIndexPaths:deleteElement withRowAnimation:UITableViewRowAnimationFade];
    [self.theTable endUpdates];
    [delegate deleteElement:elementToDelete];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellText =  [self.theSelectedData objectAtIndex:[indexPath row]];
    UIFont *cellFont = [UIFont fontWithName:@"Delicious-Roman" size:18.0];
    CGSize constraintSize = CGSizeMake(220.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    //NSLog(@"labelSize %f", labelSize.height);
    if (labelSize.height==21) return cellHeight = labelSize.height+20;
    
    if (labelSize.height==42) return cellHeight = labelSize.height+10;
    
    if (labelSize.height==63)  return cellHeight = labelSize.height+20;
    
    if (labelSize.height==84)  return cellHeight = labelSize.height+10;
    
    return cellHeight = labelSize.height+20;
    
    //return 55;
}



- (void) addTheElement:(NSString*) theElement isNew:(bool) isNewElement {
    NSLog(@"ADD %@", theElement);
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];   
    [rowArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.theSelectedData insertObject:[theElement stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] atIndex:0];
    if (!isNewElement)[delegate dataSelected:theElement];
    
    /*[self.theTable beginUpdates];
    [self.theTable insertRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationFade];
    [self.theTable endUpdates];
    
    CGRect tableFrame = self.theTable.frame;
    CGRect viewFrame = self.view.frame;
    tableFrame.size.height = 50 * [self.theSelectedData count];
    viewFrame.size.height = 70 * [self.theSelectedData count];
    self.theTable.frame = tableFrame;
    if ([self.theSelectedData count] > 2) self.view.frame = viewFrame;*/
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
