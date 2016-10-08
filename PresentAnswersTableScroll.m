//
//  PresentAnswersTableScroll.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 20/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "PresentAnswersTableScroll.h"
#import "PresentAnswerCell.h"


@implementation PresentAnswersTableScroll
@synthesize numberRows;
@synthesize currentResponder;



- (void)viewDidLoad {
	
	self.numberRows = 2;
	self.currentResponder = 0;
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return 80;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.numberRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSUInteger theRow = [indexPath row];
	NSLog(@"ROW REAL %i", theRow);
	if (numberRows == 2) {
	
		
	}
	
	if (theRow != self.currentResponder) {
		
		
	}
	
	//UITableViewCell *cell = nil;
	//NSLog(@"ROWROW ROW %i Current", theRow);
	/*
	NSLog(@"ROW %i CURRENT %i", theRow, self.currentResponder);
	if (theRow == 0) {
		static NSString *CellIdentifierNormal = @"CheckMarkNormal";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierNormal];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
										   reuseIdentifier:CellIdentifierNormal] autorelease];			
		}
		
		CGRect frame = CGRectMake(5.0, 5.0, 199, 31);
		UITextField *textFieldRounded = [[UITextField alloc] initWithFrame:frame];		
		textFieldRounded.borderStyle = UITextBorderStyleBezel;
		textFieldRounded.textColor = [UIColor blackColor];				
		textFieldRounded.backgroundColor = [UIColor lightGrayColor];
		textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		textFieldRounded.adjustsFontSizeToFitWidth = YES;
		textFieldRounded.keyboardType = UIKeyboardTypeDefault;
		textFieldRounded.returnKeyType = UIReturnKeyNext;
		textFieldRounded.tag = -1;
		textFieldRounded.textAlignment =  UITextAlignmentLeft; 
		textFieldRounded.delegate = self;
		if (theRow == currentResponder)  {
			[textFieldRounded becomeFirstResponder];
		}
		[cell.contentView addSubview:textFieldRounded];
		[textFieldRounded release];
	}
	else {	
	 */
		//static NSString *CellIdentifier = @"CheckMark";
		//cell = (PresentAnswerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		//if (cell == nil) {		
			NSLog(@"YES NIL");
			PresentAnswerCell *cell = [[[PresentAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault 
										   reuseIdentifier:@"CheckMark"] autorelease];	
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			
			/*
			if (theRow == self.currentResponder) {				
				[((PresentAnswerCell *)cell).theField becomeFirstResponder];
				[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:theRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];							
				
			} else { 				
				//((PresentAnswerCell *)cell).subButton.hidden = YES;
				//((PresentAnswerCell *)cell).addButton.hidden = YES;	
				if(theRow == 1) {
					((PresentAnswerCell *)cell).addButton.hidden = NO;	
				}							
			}		
			*/
			
			int scrollTo = theRow;
			if (numberRows > 4 && theRow == 0) {
				scrollTo = numberRows -1;
			}
			
			NSLog(@"scroll to %i", scrollTo);
			[((PresentAnswerCell *)cell).theField becomeFirstResponder];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:theRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];							
			
			((PresentAnswerCell *)cell).subButton.hidden = NO;
			((PresentAnswerCell *)cell).addButton.hidden = NO;
			
		
			
			//theRow = self.currentResponder;
			
					
	
	//NSLog(@"ROW TARGET %i", theRow);
	[((PresentAnswerCell *)cell).subButton addTarget:self action:@selector(subTractCell:) forControlEvents:UIControlEventTouchUpInside];
	[((PresentAnswerCell *)cell).addButton addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
	((PresentAnswerCell *)cell).subButton.tag = theRow;
	((PresentAnswerCell *)cell).addButton.tag = theRow;	
	((PresentAnswerCell *)cell).theField.delegate = self;	
	((PresentAnswerCell *)cell).theField.tag = theRow;	
		
	//}	
	
    return cell;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	NSLog(@" TAGG %i", textField.tag);
	if (textField.tag > 0) {
		[textField resignFirstResponder];
		int theRow = textField.tag;
		PresentAnswerCell *cellZero = (PresentAnswerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:theRow inSection:0]];
		cellZero.addButton.hidden = YES;
		cellZero.subButton.hidden = YES;		
		
		self.currentResponder =  theRow +1 ;
		self.numberRows = numberRows + 1;
		NSMutableArray *indexs = [[NSMutableArray alloc] init];
		[indexs addObject:[NSIndexPath indexPathForRow:theRow + 1 inSection:0]];	
		[self.tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationFade];		
	}else {
		[textField resignFirstResponder];
		int theRow = textField.tag + 1;
		PresentAnswerCell *cellZero = (PresentAnswerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:theRow inSection:0]];
		[cellZero.theField becomeFirstResponder];
	}	
	
	return NO;
}


- (void) subTractCell:(id) sender {
	
	int theRow = ((UIControl *)sender).tag;	
	PresentAnswerCell *cellZero = (PresentAnswerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:theRow -1 inSection:0]];
	cellZero.addButton.hidden = NO;
	cellZero.subButton.hidden = NO;
	[cellZero.theField becomeFirstResponder];
	self.currentResponder =  theRow -1;
	
	self.numberRows= numberRows -1;
	NSMutableArray *indexs = [[NSMutableArray alloc] init];
	[indexs addObject:[NSIndexPath indexPathForRow:theRow inSection:0]];	
	[self.tableView deleteRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationFade];
}


- (void) addCell:(id) sender {
	
	int theRow = ((UIControl *)sender).tag;
	PresentAnswerCell *cellZero = (PresentAnswerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:theRow inSection:0]];
	cellZero.addButton.hidden = YES;
	cellZero.subButton.hidden = YES;
	[cellZero.theField resignFirstResponder];
	
	
	self.currentResponder =  theRow +1 ;
	self.numberRows = numberRows + 1;
	NSMutableArray *indexs = [[NSMutableArray alloc] init];
	int realRow = theRow + 1;
	NSLog(@"ADDCELL ROW %i", realRow);
	[indexs addObject:[NSIndexPath indexPathForRow:realRow inSection:0]];	
	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView endUpdates];
	//[self.tableView reloadData];
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

