//
//  FacebookActionSharing.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 05/05/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "FacebookActionSharing.h"
#import "AvatarImageView.h"
#import <FacebookSDK/FBRequest.h>
#import "ActionProtocol.h"
#import <QuartzCore/QuartzCore.h>
//#import "Mixpanel.h"
#import "iphoneCrowdAppDelegate.h"
#import "IndividualFeelerController.h"
#import "HuntFeedController.h"

@interface FacebookActionSharing ()

@end

@implementation FacebookActionSharing
@synthesize theTable, theTextField, allFriends, theSearchText, searchResults, selectedFeeler,avatar;
@synthesize selectedFriends, currentLocation, theMessage, classType, startTyping;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.theTable.hidden = true;    
    self.allFriends = [[[NSMutableArray alloc] init] autorelease];
    self.theTextField.delegate = self;
    [self.theTextField becomeFirstResponder];
    self.theSearchText = [[[NSMutableString alloc] init] autorelease];
    self.searchResults = [[[NSMutableArray alloc] init] autorelease];
    self.theTextField.text = self.theMessage;
    self.selectedFriends = [NSMutableArray new];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneTapped)];
    doneButton.tintColor = [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:239.0/255.0 alpha:1.0];
    [doneButton setBackgroundVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
     self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelTapped)];
    backButton.tintColor = [UIColor grayColor];
    [backButton setBackgroundVerticalPositionAdjustment:3 forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //add all friends
    [self.allFriends addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"all_friends"]];
    [self.avatar checkIfImageExists:[[NSUserDefaults standardUserDefaults] objectForKey:@"my_image"] theImageFrame:CGRectMake(0, 0, 40, 40)];
}

- (void) doneTapped {
    [self dismissViewControllerAnimated:YES completion:^{
        [self postAction];
        iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSArray *controllers = appDelegate.navigationController.viewControllers;
        for (UIViewController *controller in controllers) {
            if ([controller isKindOfClass:classType]){
                NSString *className = NSStringFromClass(classType);
                if ([className isEqualToString:@"HuntFeedController"])[((HuntFeedController *)controller) postedSuccessfullyFB:[self createPostSuccessView]];
                if ([className isEqualToString:@"IndividualFeelerController"])[((IndividualFeelerController *)controller) postedSuccessfullyFB:[self createPostSuccessView]];
                break;
            }
        }
    }];
}


- (UIView*) createPostSuccessView {
    UIControl *addFBDonePop = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)] autorelease];
    addFBDonePop.backgroundColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:0.5];
    //[addFBDonePop addTarget:self action:@selector(addInfoPopRemove) forControlEvents:UIControlEventTouchDown];
    addFBDonePop.tag = 152637;
    
    UIView *addInfoImage = [[[UIView alloc] initWithFrame:CGRectMake(35,75, 250,100)] autorelease];
    addInfoImage.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    addInfoImage.layer.cornerRadius = 6.0;
    [addFBDonePop addSubview:addInfoImage];
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15,14,210,70)] autorelease];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.numberOfLines = 0;
	infoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    infoLabel.text = [NSString stringWithFormat:@"Success! Your message just got posted on Facebook."];
    [addInfoImage addSubview:infoLabel];
    [addFBDonePop setAlpha:0.0];

    return addFBDonePop;
}

- (void) cancelTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.searchResults count];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    self.currentLocation = range.location;
    NSLog(@"location %i length %i", range.location, range.length);
    if ([text length] > 0 && ![[NSCharacterSet whitespaceCharacterSet] characterIsMember:[text characterAtIndex:0]]){
        [self.theSearchText appendString:text]; 
        NSLog(@"Searching %@", self.theSearchText);
        [self doTermSearch:self.theSearchText];
    } else {
        self.theTable.hidden = true;
        [self.theSearchText setString:@""];
    }
    return YES;
}

- (void) doTermSearch:(NSString *) term {
    
    startTyping.hidden = true;
    [self.searchResults removeAllObjects];
    NSMutableArray* containsAnother = [NSMutableArray array];
    for (NSDictionary* cellDic in self.allFriends) {
        NSString *cellContent = [cellDic objectForKey:@"name"];
        if ([cellContent rangeOfString:term options:NSCaseInsensitiveSearch].location != NSNotFound){
            [containsAnother addObject:cellDic];
        }
    }
    
    if ([containsAnother count] > 0){
        self.theTable.hidden = false;
        [self.searchResults addObjectsFromArray:containsAnother];
        [self.theTable reloadData];
    } else {
        self.theTable.hidden = true;
    }    
}



- (void) postAction {
 
    
    NSString *format = [NSString stringWithFormat:@"http://peoplehunt.me/friendmention?fb:app_id=317688634927277&og:type=peoplehuntapp:request&name=%@&message=%@&feeler=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"], self.theTextField.text, self.selectedFeeler];
    
    id<TheRequest> result = (id<TheRequest>)[FBGraphObject graphObject];
    result.url = format;
    
    // Now create an Open Graph eat action with the meal, our location,
    // and the people we were with.
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
    action[@"request"] = result;
   
    
    NSString *inputText = self.theTextField.text;
    //validate friend Selection
    if ([self.selectedFriends count] > 0) {        
        NSArray *copySelectedFriends = [[self.selectedFriends copy] autorelease];
        for (NSString* friendId in copySelectedFriends) {
            NSString* theName = nil;
            for (NSDictionary* friendData in self.allFriends) {
                if ([friendId isEqualToString:[friendData objectForKey:@"id"]]){
                    theName = [friendData objectForKey:@"name"];
                    break;
                }
            }
            if (theName && ([inputText rangeOfString:theName].location == NSNotFound)) {
                NSLog(@"removing %@", theName);
                [self.selectedFriends removeObject:friendId];
            } else {//add friend id to the message
                inputText = [inputText stringByReplacingOccurrencesOfString:theName withString:[NSString stringWithFormat:@"@[%@]", friendId]];
            }
        }           
    }
    NSLog(@"MESSAGE %@", inputText);
    action[@"message"] = inputText;
    
    
    [FBRequestConnection startForPostWithGraphPath:@"me/peoplehuntapp:make"
                                       graphObject:action
                                 completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         NSString *alertText;
         if (!error) {
             alertText = [NSString stringWithFormat:
                          @"Posted Open Graph action, id: %@",
                          [result objectForKey:@"id"]];
             
         } else {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
             NSLog(@"ERROR %@", error);
         }     
     
        }
     ];
    
}

- (void) postedSuccessfullyFB {
    UIControl *addFBDonePop = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)] autorelease];
    addFBDonePop.backgroundColor = [UIColor colorWithRed:95/255.0 green:104/255.0 blue:115/255.0 alpha:0.5];
    [addFBDonePop addTarget:self action:@selector(addInfoPopRemove) forControlEvents:UIControlEventTouchDown];
    addFBDonePop.tag = 152637;
    [self.view addSubview:addFBDonePop];
    
    UIView *addInfoImage = [[[UIView alloc] initWithFrame:CGRectMake(35,75, 250,100)] autorelease];
    addInfoImage.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    addInfoImage.layer.cornerRadius = 6.0;
    [addFBDonePop addSubview:addInfoImage];
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15,14,210,70)] autorelease];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.numberOfLines = 0;
	infoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    infoLabel.text = [NSString stringWithFormat:@"Success! Your message just got posted on Facebook."];
    [addInfoImage addSubview:infoLabel];
    [addFBDonePop setAlpha:0.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    
    [addFBDonePop setAlpha:1.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];

    [self performSelector:@selector(alreadyFBPopRemove) withObject:nil afterDelay:2.0];
}

- (void) alreadyFBPopRemove{
    [[self.view viewWithTag:152637] setAlpha:1.0];
    
    [UIView beginAnimations:@"animation_1" context:NULL];
    
    // define how long the animation should take, in seconds. 0.5 is half a second.
    [UIView setAnimationDuration:0.50];
    
    [[self.view viewWithTag:152637] setAlpha:0.0];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    //[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"scanningfeeler"];
    [[self.view viewWithTag:152637] removeFromSuperview];
}




- (void)textViewDidChange:(UITextView *)textView {
    
    //NSLog(@"TEXT %@", textView.text);
}

- (UITableViewCell *)tableView:(UITableView *) aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ConnectCell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *cellContent = [self.searchResults objectAtIndex:[indexPath row]];
    AvatarImageView *asyncImageView = nil;
    UILabel *nameLabel = nil;   
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        asyncImageView = [[[AvatarImageView alloc] initWithFrame:CGRectMake(5,0, 50, 50)] autorelease];
        asyncImageView.userInteractionEnabled = NO;
        asyncImageView.tag = 12;
        asyncImageView.displayUImage = true;       
        [cell.contentView addSubview:asyncImageView];
        
        nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70,5,210,15)] autorelease];
        nameLabel.tag = 7414;
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        nameLabel.textColor = [UIColor colorWithRed:25/255.0 green:136/255.0 blue:222/255.0 alpha:1.0];
        nameLabel.backgroundColor = [UIColor clearColor];       
        //accesory stuff      
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:nameLabel];
     
        
    } else {
        asyncImageView = (AvatarImageView *)[cell.contentView viewWithTag:12];
        [asyncImageView removeImageView];
        asyncImageView.fileName = nil;
        
        nameLabel = (UILabel*) [cell.contentView viewWithTag:7414];
    }   
    
    // Set up the cell...
    NSLog(@"Cell CONTENT %@", cellContent);
    [asyncImageView checkIfImageExists:[[[cellContent objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"] theImageFrame:CGRectMake(0,0, 50, 50)];
    nameLabel.text = [cellContent objectForKey:@"name"];  
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* theFriend = [self.searchResults objectAtIndex:[indexPath row]];
    NSString* currentText = self.theTextField.text;    
    int startIndex = self.currentLocation - self.theSearchText.length +1;
    self.theTextField.text = [currentText stringByReplacingCharactersInRange:NSMakeRange(startIndex, self.theSearchText.length) withString:[theFriend objectForKey:@"name"]];    
    [self.selectedFriends addObject:[theFriend objectForKey:@"id"]];
    self.theTable.hidden = true;
}

- (CGFloat)tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
	return 50;
}


- (void)dealloc {
    [theMessage release];
    [selectedFriends release];
    [avatar release];
    [selectedFeeler release];
    [searchResults release];
    [theSearchText release];
    [allFriends release];
    [theTextField release];
    [theTable release];
    [startTyping release];
    [super dealloc];
}

@end
