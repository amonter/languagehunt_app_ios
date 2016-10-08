//
//  EditProfileController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 7/15/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "EditProfileController.h"
#import "UITextView+Placeholder.h"


@interface EditProfileController ()

@end

@implementation EditProfileController
@synthesize theScroll, interestView, backImageView, aboutView, interests, bio, profileData, saveChanges;

// [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {

-(id)init {
	self = [super init];
	if(self){
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
            
            [self.theScroll setContentOffset:CGPointMake(0, 60
                                                         ) animated:YES];
        }];
       
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        }];       
	}
	
	return self;
}


- (void)addCardView {
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *coverSearch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    coverSearch.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *middleCard;
    UIImageView *bottomImage;
    UIView* middleView;
    UIImageView *orangeBack;
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 472)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 472)];
        bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 495, 297.5, 28)];
        orangeBack = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 15, 265, 35.5)];
        
    } else {
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 384)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 384)];
        bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 405, 297.5, 28)];
        orangeBack = [[UIImageView alloc] initWithFrame:CGRectMake(16.25, 15, 265, 35.5)];
    }
    
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    bottomImage.image = [UIImage imageNamed:@"cardback_bottom.png"];
    orangeBack.image = [UIImage imageNamed:@"orangeProfile.png"];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setFrame:CGRectMake(244.75, 117.5, 42, 42)];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refreshNew.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(rotateElements) forControlEvents:UIControlEventTouchUpInside];
    //levels view
    UIImageView *levels = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levels.png"]];
    levels.frame = CGRectMake(123, 185, 152, 24);
    
    CGRect underScrollFrame = self.view.frame;
    underScrollFrame.size.width = 297.5;
    self.view.frame = underScrollFrame;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,22,265,20)];
    nameLabel.tag = 200;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:18.0];
	nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"Edit Profile";
    //format the labels
    bio.textColor = [UIColor colorWithRed:222/255.0 green:122/255.0 blue:1/255.0 alpha:1.0];
    bio.font = [UIFont fontWithName:@"Delicious-Heavy" size:18.0];
    
    interests.textColor = [UIColor colorWithRed:222/255.0 green:122/255.0 blue:1/255.0 alpha:1.0];
    interests.font = [UIFont fontWithName:@"Delicious-Heavy" size:18.0];
    
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)];
    topview.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:95/255.0 blue:95.0/255.0 alpha:1];    
    
    
    [self.theScroll addSubview:topCard];
    [self.theScroll addSubview:middleView];
    [self.theScroll addSubview:bottomImage];
    [self.theScroll addSubview:orangeBack];
    [self.theScroll addSubview:nameLabel];
    
    [middleView addSubview:middleCard];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self init];
    // Do any additional setup after loading the view from its nib.
    [self addCardView];
   
    [self.theScroll bringSubviewToFront:self.backImageView];
    [self.theScroll bringSubviewToFront:self.aboutView];
    [self.theScroll bringSubviewToFront:self.backImageView2];
    [self.theScroll bringSubviewToFront:self.interestView];
    [self.theScroll bringSubviewToFront:self.bio];
    [self.theScroll bringSubviewToFront:self.interests];
    [self.theScroll bringSubviewToFront:self.saveChanges];
    
    CGRect backImageFrame = self.backImageView.frame;
    backImageFrame.size.width = 265;
    self.backImageView.frame = backImageFrame;
    
    CGRect backImageFrame2 = self.backImageView2.frame;
    backImageFrame2.size.width = 265;
    self.backImageView2.frame = backImageFrame2;
    
    
    self.theScroll.delegate = self;
    
    interestView.returnKeyType = UIReturnKeyDone;
    interestView.delegate = self;
    interestView.placeholder = @"Separate with commas e.g. (snorkeling, improv theatre)";
    interestView.placeholderColor = [UIColor lightGrayColor]; // optional
    
    aboutView.placeholder = @"Something short about yourself";
    aboutView.placeholderColor = [UIColor lightGrayColor]; // optional
    aboutView.returnKeyType = UIReturnKeyDone;
    aboutView.delegate = self;
    
    
    NSLog(@"INTERESTS DATA %@", [profileData objectForKey:@"interests"]);
    self.aboutView.text = [profileData objectForKey:@"bio"];
    self.interestView.text = [self extractInterest];
    
    
    /*self.theTable.delegate = self;
    CGRect frameTable = self.theTable.frame;
    frameTable.size.width = 280;
    self.theTable.frame = frameTable;
    [self.view bringSubviewToFront:self.theTable];*/
    
}

- (IBAction)saveChanges:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changes_done" object:self];
}



- (NSString *)extractInterest {
    
    NSString *interestsCopy= [profileData objectForKey:@"interests"];;
    NSMutableArray* arrayInterests = [NSMutableArray new];
    id theInterests = [profileData objectForKey:@"interests"];
    if ([theInterests isKindOfClass:[NSArray class]]){
        for (NSDictionary* theInterest in [profileData objectForKey:@"interests"]) {
            [arrayInterests addObject:[theInterest objectForKey:@"name"]];
        }
        interestsCopy = [arrayInterests componentsJoinedByString:@", "];
    }
    
    return interestsCopy;
}


- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString*) text {
    if ([text isEqualToString:@"\n"]) {
        [self.theScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        [textView resignFirstResponder];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changes_done" object:self];
        return NO;
    }
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
