//
//  GroupSelectionController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 02/12/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "GroupSelectionController.h"
#import "ProfileV2Controller.h"
#import "AvatarImageView.h"
#import "OpenGroupSelectionController.h"
#import <QuartzCore/QuartzCore.h>

@interface GroupSelectionController ()

@end

@implementation GroupSelectionController
@synthesize theTable, groupsData, selectedGroups, profileImageUrl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.hidesBackButton = YES;
    
    //add Next button
    UIButton *Button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 41)] autorelease];
    [Button setImage:[UIImage imageNamed:@"nextArrow.png"] forState:UIControlStateNormal];
    [Button setImage:[UIImage imageNamed:@"nextPressed.png"] forState:UIControlStateHighlighted];
    [Button setImage:[UIImage imageNamed:@"nextPressed.png"] forState:UIControlStateSelected];
    [Button addTarget:self action:@selector(doProcessing) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextButton = [[[UIBarButtonItem alloc] initWithCustomView:Button] autorelease];
    self.navigationItem.rightBarButtonItem = nextButton;

    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.selectedGroups = [[[NSMutableArray alloc] init] autorelease];
    [self.theTable setSeparatorColor:[UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1]];
   
    
    //if no groups notify user
    if (groupsData == nil){
        //UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)] autorelease];
        UIImageView *theImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)] autorelease];
        theImage.image = [UIImage imageNamed:@"grey_image_border.png"];
        //[headerView addSubview:theImage];
        self.theTable.tableHeaderView = theImage;
        self.theTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    } else {// preselect the rows 
        for (int i = 0; i < [groupsData count]; i++) {
            [self.selectedGroups addObject:[NSNumber numberWithInt:i]];
        }
    }

    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UILabel *theTopLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 300, 50)] autorelease];
    theTopLabel.text = [NSString stringWithFormat:@"Import your \nFacebook Groups"];
    theTopLabel.lineBreakMode = UILineBreakModeWordWrap;
    theTopLabel.textAlignment = UITextAlignmentCenter;
    theTopLabel.numberOfLines = 0;
    theTopLabel.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1];
	theTopLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    theTopLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:theTopLabel];
    
    
    UILabel *headerLine = [[[UILabel alloc] initWithFrame:CGRectMake(0,59,320,1)] autorelease];
	headerLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:232/255.0 blue:235/255.0 alpha:1];
    [headerView addSubview:headerLine];

    UIButton *accessInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [accessInfoBtn setFrame:CGRectMake(278, 5, 27, 42)];
    [accessInfoBtn addTarget:self action:@selector(accessInfoTap) forControlEvents:UIControlEventTouchUpInside];
    [accessInfoBtn setBackgroundImage:[UIImage imageNamed:@"infoButton.png"] forState:UIControlStateNormal];
    [self.view addSubview:accessInfoBtn];
    
    [self performSelector:@selector(accessInfoTap) withObject:nil afterDelay:1.0];
    
    //self.view = headerView;   
    //Process the Image
    NSLog(@"URL %@", self.profileImageUrl);
    AvatarImageView *theImage = [[[AvatarImageView alloc] init] autorelease];
    [theImage loadImageFromURL:[NSURL URLWithString:self.profileImageUrl] theImageFrame:CGRectMake(0, 0, 90, 90)];
    
}

- (void) accessInfoTap {
    
    UIView *accessInfoPop = [[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,self.view.frame.size.height)] autorelease];
    accessInfoPop.backgroundColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:0.5];
    accessInfoPop.tag = 721194;
    [self.view addSubview:accessInfoPop];
    
    UIView *accessImage = [[[UIView alloc] initWithFrame:CGRectMake(85,42, 225,136)] autorelease];
    accessImage.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    accessImage.layer.cornerRadius = 6.0;
    [accessInfoPop addSubview:accessImage];
    
    UIButton *gotItButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gotItButton setFrame:CGRectMake(140, 85, 73, 42)];
    [gotItButton addTarget:self action:@selector(accessInfoTapRemove) forControlEvents:UIControlEventTouchUpInside];
    [gotItButton setBackgroundImage:[UIImage imageNamed:@"gotit.png"] forState:UIControlStateNormal];
    [accessImage addSubview:gotItButton];
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15,15,200,80)] autorelease];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    infoLabel.lineBreakMode = UILineBreakModeWordWrap;
    infoLabel.textAlignment = UITextAlignmentLeft;
    infoLabel.numberOfLines = 0;
	infoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    infoLabel.text = [NSString stringWithFormat:@"Import your Facebook groups to see what people within them can show, tell or teach you (no spam!)."];
    [accessImage addSubview:infoLabel];
    [accessInfoPop setAlpha:0.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.5];
    
    [accessInfoPop setAlpha:1.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    
}

- (void) accessInfoTapRemove{
    NSArray *thearray = [self.view subviews];
    for (UIView *theView in thearray) {
        if (theView.tag == 721194) {
            [theView removeFromSuperview];
        }
        NSLog(@"removing access");
        
    }
    
}


- (void) doProcessing {

    if ([self.selectedGroups count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Oops, please select at least one group!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
    } else {
        NSMutableArray *groupsArray = [[[NSMutableArray alloc] init] autorelease];
        for (id theRow in selectedGroups) {
            NSDictionary *theGroup = [groupsData objectAtIndex:[theRow intValue]];
            NSDictionary *leanGroup = [[[NSDictionary alloc] initWithObjectsAndKeys:[theGroup objectForKey:@"name"], @"description", [theGroup objectForKey:@"id"], @"id", @"facebook_group", @"type", nil] autorelease];
            [groupsArray addObject:leanGroup];
        }
    
        //Create json structure
       
        OpenGroupSelectionController *openContr = [[[OpenGroupSelectionController alloc] init] autorelease];
        openContr.groupsData = groupsArray;
        //openContr.resJson = theResult;
        [self.navigationController pushViewController:openContr animated:YES];
        /*
        ProfileV2Controller *profileV2 = [[[ProfileV2Controller alloc] initWithNibName:@"ProfileV2Controller" bundle:nil] autorelease];
        profileV2.groupData = theResult;
        profileV2.myGroups = groupsArray;
        [self.navigationController pushViewController:profileV2 animated:YES];
         */
    }    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [groupsData count];
}

- (UITableViewCell *)tableView:(UITableView *) aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"GroupCell";
    int theRow = [indexPath row];
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = 99;
        
        //Group name
        UILabel *groupName = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 248, 42)] autorelease];
        groupName.tag = 555;
        groupName.backgroundColor = [UIColor clearColor];
        groupName.lineBreakMode = UILineBreakModeWordWrap;
        groupName.numberOfLines = 0;
        groupName.textColor = [UIColor blackColor];
        groupName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
        
        //CheckBox
        UIButton *checkGroup = [UIButton buttonWithType:UIButtonTypeCustom];
        checkGroup.tag = theRow;
        [checkGroup setFrame:CGRectMake(270, 0, 42, 42)];
        [checkGroup addTarget:self action:@selector(selectGroup:) forControlEvents:UIControlEventTouchUpInside];
        [checkGroup setBackgroundImage:[UIImage imageNamed:@"knowPressed.png"] forState:UIControlStateSelected];
        [checkGroup setBackgroundImage:[UIImage imageNamed:@"knowUnpressed.png"] forState:UIControlStateNormal ];
        [checkGroup setBackgroundImage:[UIImage imageNamed:@"knowUnpressed.png"] forState:UIControlStateHighlighted | UIControlStateSelected];
        [checkGroup setBackgroundImage:[UIImage imageNamed:@"knowUnpressed.png"] forState:UIControlStateNormal | UIControlStateHighlighted ];
        [cell.contentView addSubview:groupName];
        [cell.contentView addSubview:checkGroup];        
        
    } else {              
        //normal providing buttom
        UIButton *theButton = [self retrieveUIButton:cell];
        [theButton setBackgroundImage:[UIImage imageNamed:@"knowUnpressed.png"] forState:UIControlStateNormal ];
        theButton.tag = theRow;
        theButton.selected = false;        
    }
    
    
    //add selection
    for (id theId in self.selectedGroups) {
        if ([theId intValue] == theRow) {
            UIButton *theButton = [self retrieveUIButton:cell];
            theButton.selected = true;
            [theButton setBackgroundImage:[UIImage imageNamed:@"knowPressed.png"] forState:UIControlStateSelected];
            
        }
    }    
    
    
    // Set up the cell...
    ((UILabel *)[cell viewWithTag:555]).text = [[groupsData objectAtIndex:theRow] objectForKey:@"name"];
    [cell setNeedsLayout];
    
    return cell;
}


- (UIButton *) retrieveUIButton:(UITableViewCell *) theCell {
    NSArray *subViews = [theCell.contentView subviews];
    for (id theView in subViews) {
        if ([theView isKindOfClass:[UIButton class]]){
            return ((UIButton *)theView);
            
        }
    }
    
    return nil;
}


- (void) selectGroup:(id) sender {
    
    NSLog(@"ROW NUMBER %i", ((UIButton *)sender).tag);
    if (((UIButton *)sender).selected) {//delete from selection
        ((UIButton *)sender).selected = NO;
        [self.selectedGroups removeObject:[NSNumber numberWithInt:((UIButton *)sender).tag]];
        
    } else {//add to selection
        ((UIButton *)sender).selected = YES;
        [self.selectedGroups addObject:[NSNumber numberWithInt:((UIButton *)sender).tag]];
    }
}


- (CGSize) getCellWidth:(UITableView *)aTableView copy:(NSString *)copy {
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    CGSize withinsize = CGSizeMake(248, 2000); //1000 is just a large number. could be 500 as well
    // You can choose a different Wrap Mode of your choice
    
    return [copy sizeWithFont:font constrainedToSize:withinsize lineBreakMode:UILineBreakModeWordWrap];
}


- (CGFloat)tableView:(UITableView *) aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int theRow = [indexPath row];
    NSString *copy = [[groupsData objectAtIndex:theRow] objectForKey:@"name"];
    CGSize sz = [self getCellWidth:aTableView copy:copy];
    //you need to use size to fit to make the label wrap correctly, but it needs to be constrained to the top or bottom using the struts, without any inner expansion in nib.
    //Or - if it causes funky behaviour, instead you can use setneedslayout of the cell, and in the cell, you calculate the frame again, and in the nib, position the uilabel at the very top of the cell and it will expand to fill it   
    
	return sz.height + 22;
}



- (void)dealloc {
    [profileImageUrl release];
    [selectedGroups release];
    [groupsData release];
    [theTable release];
    [super dealloc];
}


@end
