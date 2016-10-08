//
//  IntroSwipeController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "DummyViewController.h"
#import "PeopleHuntRequests.h"
#import "MainCardController.h"
//#import "Mixpanel.h"
#import "iphoneCrowdAppDelegate.h"

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;


@interface DummyViewController ()

@end

@implementation DummyViewController
@synthesize theScrollView, locationSearch, helpWith, interestedIn, facebooProfile, longProfile, allSelectedData;
@synthesize lastContentOffset, preStoredData, showProfile;


- (IBAction)justAlert:(id)sender {

    [self.locationSearch testDummy];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_profiledata"];
    // Do any additional setup after loading the view from its nib.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"load_matchconnections"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.theScrollView.delegate = self;
    self.theScrollView.clipsToBounds = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.allSelectedData = [[NSMutableDictionary alloc] init];
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor = [UIColor colorWithRed:109/255.0 green:105/255.0 blue:96/255.0 alpha:1.0];
    
    self.locationSearch = [[LocationSearchDummy alloc] initWithNibName:@"LocationSearchDummy" bundle:nil];
    //self.locationSearch.view.hidden = YES;
    [theScrollView addSubview:self.locationSearch.view];
    
    
    
    
    UIButton *closeItButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeItButton setTitle:@"PRess" forState:UIControlStateNormal];
    [closeItButton setFrame:CGRectMake(91, 135, 99, 46)];
    [closeItButton addTarget:self action:@selector(justAlert:) forControlEvents:UIControlEventTouchUpInside];
    //[closeItButton setBackgroundImage:[UIImage imageNamed:@"close_large.png"] forState:UIControlStateNormal];
    [theScrollView addSubview:closeItButton];
    
}

- (void) justDismiss {
    [[self.view viewWithTag:3172182] removeFromSuperview];
}


- (void)addNewDataDic:(NSMutableDictionary *)theDic newData:(NSArray *)newData {
    int count = -1;
    for (NSString* theData in newData){
        [theDic setObject:theData forKey:[NSString stringWithFormat:@"%i",count]];
        count--;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //[self.locationSearch.search resignFirstResponder];
    [self.interestedIn.search resignFirstResponder];
    [self.helpWith.search resignFirstResponder];
    
    ScrollDirection scrollDirection = ScrollDirectionCrazy;
    if (self.lastContentOffset > scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionLeft;
    
    else if (self.lastContentOffset < scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionRight;
    
    
    self.lastContentOffset = scrollView.contentOffset.x;
    if (scrollDirection == ScrollDirectionLeft){
        if (self.lastContentOffset < 1200){
            [self.longProfile removeButton];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"add_donebtn"];
        }
    }
    
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page == 2){
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"add_donebtn"] boolValue]){
            [self.longProfile addKeepBrowsing];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"add_donebtn"];
        }
        
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"display_profile"] boolValue]){
            NSMutableDictionary *selectedData = [[NSMutableDictionary alloc] init];
           // NSMutableDictionary* theLocDic = self.locationSearch.selectedDataDic;
            //NSArray* newLocData = self.locationSearch.dataNew;
            //[self addNewDataDic:theLocDic newData:newLocData];
            //[selectedData setObject:theLocDic forKey:@"locations"];
            
            NSMutableDictionary* theHelpDic = self.helpWith.selectedDataDic;
            NSArray* newHelpData = self.helpWith.dataNew;
            [self addNewDataDic:theHelpDic newData:newHelpData];
            [selectedData setObject:theHelpDic forKey:@"help"];
            NSMutableDictionary* proficiencyDic = self.helpWith.proficiencyLevels;
            [selectedData setObject:proficiencyDic forKey:@"proficiency"];
            
            NSMutableDictionary* theInterestedDic = self.interestedIn.selectedDataDic;
            NSArray* newInterestedData = self.interestedIn.dataNew;
            [self addNewDataDic:theInterestedDic newData:newInterestedData];
            [selectedData setObject:theInterestedDic forKey:@"interested"];
            [selectedData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"] forKey:@"name"];
            [selectedData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"my_image"] forKey:@"image_url"];
            NSLog(@"ALL SELECTED Data %@",selectedData);
            self.allSelectedData = selectedData;
            self.longProfile.profileData = selectedData;
            [self.longProfile displayProfileData];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"display_profile"];
        }
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
