//
//  EditProfileScrollView.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 16/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//



#import "EditProfileScrollView.h"
#import "AboutMeCell.h"
#import "IliveCell.h"
#import "MyWebsite.h"
#import "SendProfileInfo.h"
#import "TextViewWithPlaceholder.h"


@implementation EditProfileScrollView
@synthesize profileInfo, request;

- (void)viewDidLoad {
	
	//229 227 227
	[super viewDidLoad];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;	
	[self.view setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1]];	
	
	UIBarButtonItem *totalButtonObj = [[UIBarButtonItem alloc] initWithTitle:@"Save" style: UIBarButtonItemStyleDone
																	  target:self
																	  action:@selector(saveDetails)];	
	
	self.navigationItem.rightBarButtonItem = totalButtonObj;
	
	UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(5, 80, 65, 65)];
	[headerView setBackgroundColor:[UIColor clearColor]];	
	
	UILabel *member = [[UILabel alloc] initWithFrame: CGRectMake(20, 5, 70, 30)];
	member.numberOfLines = 0;	
	member.text = @"member:";
	member.backgroundColor = [UIColor clearColor];
	member.textColor = [UIColor colorWithRed:93.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1];
	member.textAlignment = UITextAlignmentRight;
	member.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
	[headerView addSubview:member];
	[member release];		
	
	UILabel *theUsername = [[UILabel alloc] initWithFrame: CGRectMake(120, 10, 170, 30)];
	theUsername.numberOfLines = 0;
	//physical.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	theUsername.text = [self.profileInfo objectForKey:@"name"];
	theUsername.backgroundColor = [UIColor clearColor];
	theUsername.textColor = [UIColor colorWithRed:93.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1];	
	theUsername.textAlignment = UITextAlignmentLeft;
	theUsername.font = [UIFont fontWithName:@"Helvetica" size:16];
	[theUsername sizeToFit];
	[headerView addSubview:theUsername];
	[theUsername release];		
	
	////NEXT LABEL///////////////////////	
	UILabel *public = [[UILabel alloc] initWithFrame: CGRectMake(15, 24, 170, 30)];
	public.numberOfLines = 0;
	//virtually.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	public.text = @"this information will be public";
	public.textAlignment = UITextAlignmentCenter;
	public.backgroundColor = [UIColor clearColor];
	public.textColor = [UIColor colorWithRed:93.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1];	
	public.font = [UIFont fontWithName:@"Helvetica" size:11];
	[headerView addSubview:public];
	[public release];	
	
	self.tableView.tableHeaderView = headerView;
	[headerView release];	
	[totalButtonObj release];
		
	// we aren't editing any fields yet, it will be in edit when the user touches an edit field
	self.editing = NO;
}


- (void) saveDetails {
	
	if ([self validate]) {
		
		SendProfileInfo *profileRequest = [[SendProfileInfo alloc] init];
		self.request = profileRequest;
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(finishedRequest)
													 name:@"send_ok" object: self.request];		
		
		UITableViewCell *cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		UITextView *aboutMeField = (UITextView *)[cell0 viewWithTag:88];
		UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		UITextField *plaveLiveField = (UITextField *)[cell1 viewWithTag:1];
		UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
		UITextField *websiteField = (UITextField *)[cell2 viewWithTag:2];
		UITableViewCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
		UITextField *genderField = (UITextField *)[cell3 viewWithTag:3];
		
		NSLog(@"EDITITNG %@, %@, %@, %@",aboutMeField.text, plaveLiveField.text, websiteField.text, genderField.text);
		
		NSMutableDictionary *theDic = [[NSMutableDictionary alloc] initWithCapacity:5];		
		[theDic setObject:aboutMeField.text forKey:@"aboutme"];
		[theDic setObject:plaveLiveField.text forKey:@"placelive"];
		[theDic setObject:websiteField.text forKey:@"website"];
		[theDic setObject:genderField.text forKey:@"gender"];
		[theDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
		
		[self.request sendProfileInfo:theDic];
		
		[theDic release];
		[profileRequest release];		
	}
}

- (void) finishedRequest {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome" 
													message:@"Your info has been added" delegate:self 
										  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];		
	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (![alertView.title isEqualToString:@"About me"]) {
	
		[self.navigationController popViewControllerAnimated:YES];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];	
	}	
}


- (bool) validate {
	
	bool valid = true;
	UITableViewCell *cellZero = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	UITextView *theTextView = (UITextView *)[cellZero viewWithTag:88];
	
	UITableViewCell *cellGender = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
	UITextField *theTextGender = (UITextField *)[cellGender viewWithTag:3];	
	NSLog(@"THE Lenght %i text %@", [theTextView.text length], theTextView.text);
	if ([theTextView.text length] > 118) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About me" 
														message:@"whoops! you have more than 118 characters" delegate:self 
											  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];		
		valid = false;		
	}	
	
	NSLog(@"THE GENder %@",  theTextGender.text);
	NSString *genderString = [theTextGender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([genderString length] > 0) {
		if (!([genderString isEqualToString:@"Male"] || [genderString isEqualToString:@"Female"])) {			
			theTextGender.text= @"";
			theTextGender.textColor = [UIColor blackColor];
			theTextGender.placeholder = @"Male or Female only";			
			valid = false;
		}		
	}
	
	return valid;
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

// to determine specific row height for each cell, override this.
// In this example, each row is determined by its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	if (row == 0) {
		return 143.0;
	
	}else {
		return 54.0;	
	}
	
	return 0;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.tableView.separatorColor = [UIColor clearColor];
	NSUInteger row = [indexPath row]; 
	UITableViewCell *cell;
	NSString *stringLabel = nil;
	NSString *cellInfo = @"";
	if (row == 1){
		stringLabel = @"I live in";
		cellInfo = [self.profileInfo objectForKey:@"placeLive"];
	}
	if (row == 2){
		stringLabel = @"my website";
		cellInfo = [self.profileInfo objectForKey:@"website"];
	}
	if (row	== 3) {
		stringLabel = @"gender";
		cellInfo = [self.profileInfo objectForKey:@"gender"];
	}	
	if (row == 0) {	
		static NSString *CustomCellIdentifier = @"cellIdentifier";
		cellInfo = [self.profileInfo objectForKey:@"aboutMe"];
		cell = (AboutMeCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
		if (cell == nil) { 			
			cell = [[[AboutMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier] autorelease];
			((AboutMeCell *)cell).aboutMeView.delegate = self;
			((AboutMeCell *)cell).aboutMeView.text = cellInfo;
		} 
	}
	else {
		static NSString *CustomCellIdentifierShort = @"cellIdentifierShort";
		cell = (IliveCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifierShort];
		if (cell == nil) { 			
			cell = [[[IliveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifierShort theLabel:stringLabel] autorelease];						
			((IliveCell *)cell).theField.delegate = self;
			((IliveCell *)cell).theField.tag = row;
			((IliveCell *)cell).theField.text = cellInfo;
		} 		
	}		
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundView.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1];	
	
	return cell;
}


#pragma mark keyboard methodssf
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
													replacementText:(NSString *)text { 
	if ([text isEqualToString:@"\n"]) {		
		NSInteger currentTag = textView.tag;
		if (currentTag == 88) {
			[textView resignFirstResponder];
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
			UITextField *nextTextField = (UITextField *)[cell viewWithTag:1];
			[nextTextField becomeFirstResponder];										
		}		
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;	
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	NSLog(@" TAGG %i", textField.tag);
	if (textField.tag <= 3) {
		[textField resignFirstResponder];
		int theIndex = textField.tag + 1;	
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:theIndex inSection:0]];
		UITextField *nextTextField = (UITextField *)[cell viewWithTag:theIndex];
		[nextTextField becomeFirstResponder];		
	}	
		
	return NO;
}


- (void)viewDidUnload {
	[super viewDidUnload];	
}


- (void)viewWillAppear:(BOOL)animated {	
	[super viewWillAppear:animated];
}

- (void)dealloc {	
	[request release];
	[profileInfo release];
	[super dealloc];
}


@end

