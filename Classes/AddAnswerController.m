//
//  AddAnswerController.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 02/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "AddAnswerController.h"
#import "TextViewCell.h"
#import "ProcessQuestionSQL.h"
#import "TextViewWithPlaceholder.h"


@implementation AddAnswerController
@synthesize theTextView;
@synthesize tableView;
@synthesize theAnswer;
@synthesize questionId;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
	tableView.backgroundColor = [UIColor lightGrayColor];
    [super viewDidLoad];
}


- (void) finishedRequest {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome" 
													message:@"Your answer has been added" delegate:self 
										  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];		
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"addAnswer" object:self];	
	[self dismissModalViewControllerAnimated:YES];		
}


- (IBAction) goBack {

	[self dismissModalViewControllerAnimated:YES];	

}

- (bool) validateQuestionData {
	
	bool valid = true;
	
	if ([self.theAnswer length] == 0) {
		TextViewWithPlaceholder *questionText = (TextViewWithPlaceholder *) theTextView;
		UILabel *placeHolderQuestion = (UILabel *)[questionText viewWithTag:999];
		placeHolderQuestion.frame = CGRectMake(8, 8, 250, 20);
		placeHolderQuestion.text = @"Please enter a answer";
		
		valid = false;
	}		
	
	[theTextView becomeFirstResponder];
	
	return valid;
}




#pragma mark Table view methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return 150.0;
}

- (UITableViewCell *)tableView:(UITableView *) thetableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    TextViewCell *cell = (TextViewCell *) [thetableView dequeueReusableCellWithIdentifier:@"CellTextView_ID"];
	
    if (cell == nil) {
        cell = [TextViewCell createNewTextCellFromNib];
    }
	
    // Set up the cell...
	
    cell.textView.text = @"";
    [cell.textView becomeFirstResponder];
    cell.textView.delegate = self;
	
    return cell;
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tableView release];
	[theTextView release];
    [super dealloc];
}


@end
